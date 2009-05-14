Return-Path: <linux-kernel-owner+w=401wt.eu-S1761791AbZENOQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761791AbZENOQb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 10:16:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760503AbZENOQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 10:16:05 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:44942 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759962AbZENOQE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 10:16:04 -0400
Message-Id: <4A0C43C50200007800000ECA@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Thu, 14 May 2009 15:16:05 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Tejun Heo" <tj@kernel.org>
Cc: <mingo@elte.hu>, <andi@firstfloor.org>, <tglx@linutronix.de>,
       <linux-kernel@vger.kernel.org>, <linux-kernel-owner@vger.kernel.org>,
       <hpa@zytor.com>
Subject: Re: [PATCH 2/4] x86: simplify cpa_process_alias()
References: <1242305390-21958-1-git-send-email-tj@kernel.org>
 <1242305390-21958-3-git-send-email-tj@kernel.org>
In-Reply-To: <1242305390-21958-3-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Tejun Heo <tj@kernel.org> 14.05.09 14:49 >>>
>The two existing alias conditions in cpa_process_alias() are mutually
>exclusive and future ones are likely to be exclusive too.  Simplify
>control flow to ease adding other alias cases.
>
>The within(vaddr, (unsigned long)_text, _brk_end) test is removed as
>it's guaranteed to be false if vaddr is in the page mapped area.

I don't think that's correct - just consider the case where the originally passed
in virtual address is from the vmalloc area: In that case, both the 1:1 mapping
*and* the kernel mapping need to be checked.

Jan

