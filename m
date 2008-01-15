Return-Path: <linux-kernel-owner+w=401wt.eu-S1755561AbYAOJFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561AbYAOJFq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 04:05:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755988AbYAOJFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 04:05:21 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:9245
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755957AbYAOJFS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 04:05:18 -0500
Message-Id: <478C8578.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Tue, 15 Jan 2008 09:05:44 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <ak@suse.de>
Cc: <mingo@elte.hu>, <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [26/31] CPA: Fix reference counting when changing
	already changed pages
References: <200801141116.534682000@suse.de>
 <20080114221659.63C7514F83@wotan.suse.de>
In-Reply-To: <20080114221659.63C7514F83@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>+	ref_prot = canon_pgprot(ref_prot);
>+	prot = canon_pgprot(prot);
>+
> 	if (pgprot_val(prot) != pgprot_val(ref_prot)) { 
>...
> 	} else if (level == 4) {
>...
> 	} else {
> 		/*
> 		 * When you're here you either set the same page to PAGE_KERNEL

Doesn't this change require modifying the BUG() here into a BUG_ON() so
that it doesn't trigger if pgprot_val(prot) == pgprot_val(ref_prot) and
level != 4?

>+#define canon_pgprot(p) __pgprot(pgprot_val(p) & __supported_pte_mask)

While I remember you stated the inverse, I continue to think that it'd be
safer to mask out the accessed and dirty flags for the comparisons this
macro is being used for.

Jan

