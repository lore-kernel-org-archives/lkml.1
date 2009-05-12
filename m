Return-Path: <linux-kernel-owner+w=401wt.eu-S1756827AbZELPTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827AbZELPTR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 11:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754535AbZELPS7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 11:18:59 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:5842 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524AbZELPS6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 11:18:58 -0400
Message-Id: <4A09AF8402000078000007DC@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Tue, 12 May 2009 16:19:00 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Nick Piggin" <npiggin@suse.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: uses of cmpxchg/xadd in spinlock.h and rwsem.h vs. CONFIG_M386
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While looking at a completely different issue I happened to grep for uses of
xadd, and it would appear to me that there got uses added that would make
a M386-configured SMP kernel die on an actual i386.

Oh, for the rwsem case I see - it would use the RWSEM_GENERIC_SPINLOCK case
when selecting M386. But I see nothing similar for the ticket spinlocks - am
I overlooking something?

Jan

