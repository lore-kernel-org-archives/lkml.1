Return-Path: <linux-kernel-owner+w=401wt.eu-S1755599AbZCFLSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755599AbZCFLSq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 06:18:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754878AbZCFLSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 06:18:32 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45793 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755402AbZCFLSa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 06:18:30 -0500
Date: Fri, 6 Mar 2009 12:18:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Mike Galbraith <efault@gmx.de>
Subject: Re: [x86-tip] overflow in relocation type 11 val 39ffdd0e8690
Message-ID: <20090306111822.GI21168@elte.hu>
References: <1236287654.3677.3.camel@localhost.localdomain> <20090305212535.GA13848@elte.hu> <1236288780.3677.9.camel@localhost.localdomain> <49B083AC.1070505@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49B083AC.1070505@kernel.org>
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


* Tejun Heo <tj@kernel.org> wrote:

> Jaswinder Singh Rajput wrote:
> > On Thu, 2009-03-05 at 22:25 +0100, Ingo Molnar wrote:
> >> * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> >>
> >>> On latest tip I am getting:
> >>>
> >>> [  124.169475] overflow in relocation type 11 val 39ffdd0e8690
> >>> [  124.169508] `msr_debug' likely not compiled with -mcmodel=kernel
> >>> [  146.582299] overflow in relocation type 11 val 39ffdd0e8690
> >>> [  146.582299] `msr_debug' likely not compiled with -mcmodel=kernel
> >>> [  836.653168] overflow in relocation type 11 val 39ffdd0e8690
> >>> [  836.653201] `msr_debug' likely not compiled with -mcmodel=kernel
> >>>
> >>> But 1d10914bf2c8 was working fine.
> > 
> > No it is also not fine :( for percpu.
> > 
> >> That's a linker bug - Tejun Cc:-ed.
> >>
> > 
> > Problem is basically with 64 bit percpu on 32 bit it is OK. Ahh, Here is
> > the solution:
> > 
> > http://lkml.org/lkml/2009/3/3/129
> > 
> > because of commit 8ac83757149 of Tejun Heo.
> 
> Yeah, patchset almost ready.  Please wait a bit more.
> 
> Thanks.

Latest tip:master should have your fixes for modules and kernel 
text getting farther than ~2GB apart from each other on 64-bit.

	Ingo
