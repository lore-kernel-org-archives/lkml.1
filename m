Return-Path: <linux-kernel-owner+w=401wt.eu-S1756109AbYAOKAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109AbYAOKAv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 05:00:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752708AbYAOKAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 05:00:41 -0500
Received: from mx1.suse.de ([195.135.220.2]:56473 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752693AbYAOKAk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 05:00:40 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [PATCH] [7/31] Extract page table dumping code from i386 fault handler into dump_pagetable()
Date: Tue, 15 Jan 2008 11:00:35 +0100
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, jbeulich@novell.com, mingo@elte.hu,
       tglx@linutronix.de
References: <200801141116.534682000@suse.de> <20080114221639.31FC714F83@wotan.suse.de> <1200387377.16794.9.camel@brick>
In-Reply-To: <1200387377.16794.9.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801151100.35927.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> > +void dump_pagetable(unsigned long address)
> 
> static?

This is used by other files too with future patches. Also
in general it's useful for debugging stuff - i often put calls 
to it into debugging patches.

> > +{
> > +	typeof(pte_val(__pte(0))) page;
> 
> Is there any type that could be picked that would be nicer than
> sprinkling ((__typeof__(page) *), typeof(pte_val(__pte(0))) etc
> through here, I know it's just moving the code out to another
> function, just wondering if you had any better ideas that someone
> could follow-up on.

It could be pteval_t now which Jeremy recently introduced. But for pure
code movement I don't want to do any improvements.

-Andi
