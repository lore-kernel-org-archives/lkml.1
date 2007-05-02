Return-Path: <linux-kernel-owner+w=401wt.eu-S2993038AbXEBKw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993038AbXEBKw3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 06:52:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993036AbXEBKw3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 06:52:29 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:43116
	"EHLO gwia-smtp.id2.novell.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S2993028AbXEBKw2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 06:52:28 -0400
Message-Id: <463889A9.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.1 
Date: Wed, 02 May 2007 11:52:57 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Andi Kleen" <ak@suse.de>, <zach@vmware.com>
Cc: <linux-kernel@vger.kernel.org>, <patches@x86-64.org>
Subject: Re: [patches] [PATCH] [28/34] i386: pte xchg optimization
References: <20070430549.617098000@suse.de>
 <20070430155001.8525915209@wotan.suse.de>
In-Reply-To: <20070430155001.8525915209@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Andi Kleen <ak@suse.de> 30.04.07 17:50 >>>
>
>From: Zachary Amsden <zach@vmware.com>
>
>In situations where page table updates need only be made locally, and there is
>no cross-processor A/D bit races involved, we need not use the heavyweight
>xchg instruction to atomically fetch and clear page table entries.  Instead,
>we can just read and clear them directly.

I always wondered why the xchg is necessary here at all. If the process of
tearing down a page table entry has started, other users of the mapped
linear address are broken anyway - why is it necessary to still monitor the
effect they may have on the A/D bits, unless this is a transient tear down?

Checking for the uses of ptep_get_and_clear, I would judge that the use in
change_pte_range() may in fact need the xchg, but the uses in
vunmap_pte_range() and zap_pte_range() shouldn't.

Jan

