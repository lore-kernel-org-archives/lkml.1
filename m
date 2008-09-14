Return-Path: <linux-kernel-owner+w=401wt.eu-S1754666AbYINNV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666AbYINNV2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 09:21:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753436AbYINNVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 09:21:20 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33731 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753375AbYINNVT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 09:21:19 -0400
Date: Sun, 14 Sep 2008 15:21:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: roberto@unbit.it, jeremy@xensource.com, linux-kernel@vger.kernel.org,
       Mirko Iannella <mirko@unbit.it>, Alex Nixon <alex.nixon@citrix.com>
Subject: Re: Fix for xen guest with mem > 3.7G
Message-ID: <20080914132104.GB32106@elte.hu>
References: <1221333418.6036.9.camel@sirius> <48CC2C12.4080302@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48CC2C12.4080302@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Roberto De Ioris wrote:
> > Xen domU kernel 2.6.26 and 2.6.27-rc cannot allocate
> > more than 3.7GB of ram on my PAE systems (compiled
> > with gcc version 4.2.3 (Ubuntu 4.2.3-2ubuntu7)).
> >
> > I have found the problem is in function xen_memory_setup (in
> > arch/x86/xen/setup.c).
> >
> > It set max_pfn as 'unsigned long' but add_memory_region()
> > takes 'unsigned long long'.
> >
> > I do not know if it is a compiler problem but this is the simple fix
> > (works on my systems):
> >   
> 
> Thanks very much for the patch.  We have a more general fix for this in
> Ingo's tip.git tree, but I overlooked that this particular problem
> affected current -rc.
> 
> Ingo, this is fixed by the phys_addr_t + PFN_PHYS() patches.  Should 
> we send them up to Linus, or do an ad-hoc fix in this one place?

send an ad-hoc fix please .. the phys_addr_t patches have a too wide 
impact i think.

	Ingo
