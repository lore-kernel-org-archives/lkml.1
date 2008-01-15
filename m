Return-Path: <linux-kernel-owner+w=401wt.eu-S1752039AbYAOMAC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039AbYAOMAC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 07:00:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751055AbYAOL7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 06:59:54 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:19116
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750991AbYAOL7y convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 06:59:54 -0500
Message-Id: <478CAE60.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Tue, 15 Jan 2008 12:00:16 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Andi Kleen" <ak@suse.de>
Cc: <mingo@elte.hu>, <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [26/31] CPA: Fix reference counting when changing
	already changed pages
References: <200801141116.534682000@suse.de>
 <20080114221659.63C7514F83@wotan.suse.de>
 <478C8578.76E4.0078.0@novell.com> <200801151104.03666.ak@suse.de>
In-Reply-To: <200801151104.03666.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Andi Kleen <ak@suse.de> 15.01.08 11:04 >>>
>On Tuesday 15 January 2008 10:05:44 Jan Beulich wrote:
>> >+	ref_prot = canon_pgprot(ref_prot);
>> >+	prot = canon_pgprot(prot);
>> >+
>> > 	if (pgprot_val(prot) != pgprot_val(ref_prot)) { 
>> >...
>> > 	} else if (level == 4) {
>> >...
>> > 	} else {
>> > 		/*
>> > 		 * When you're here you either set the same page to PAGE_KERNEL
>> 
>> Doesn't this change require modifying the BUG() here into a BUG_ON() so
>> that it doesn't trigger if pgprot_val(prot) == pgprot_val(ref_prot) and
>> level != 4?
>
>I addressed this in the comment
>
>+               /*
>+                * When you're here you either set the same page to PAGE_KERNEL
>+                * two times in a row or the page table reference counting is
>+                * broken again. To catch the later bug for now (sorry)
>+                */
>
>Do you think it's important to handle?  The function already has too many
>special cases and setting something several times in a row to PAGE_KERNEL
>is usually a bug in the caller anyways (or a cpa bug)

It definitely is when making ref_prot variable (as discussed in an earlier
reply regarding a different patch), but I think it's even inconsistent given
the possible presence/absence of _PAGE_NX.

Jan

