Return-Path: <linux-kernel-owner+w=401wt.eu-S1753529AbYADNns@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529AbYADNns (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 08:43:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751842AbYADNnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 08:43:40 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:32370 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825AbYADNnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 08:43:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=OaNzxf2peA0rkwkbaOnCF04uqkMi9AP1cc0gcfMOmPePYP951bUY+u0CMN0cx0xV3Ubmp/vVKvmwbkVsN+F5ENxu+0LH6+GzvDPPza2Q47XMK4OT4U5P7mBi+b6eUUJRtwuco7VNrY2AtoffNVWMnYGEK+oK6lmRG2RNqyFBcaI=
Message-ID: <4d8e3fd30801040543y411472a8je83b4b68ebe73026@mail.gmail.com>
Date: Fri, 4 Jan 2008 14:43:36 +0100
From: "Paolo Ciarrocchi" <paolo.ciarrocchi@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] This patch to profile.c fixes a few errors reported by checkpatch.pl
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080104132328.GA27330@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080104003253.7a7309d8@paolo-desktop>
	 <20080104083442.GD22803@elte.hu>
	 <4d8e3fd30801040318q2e3be951rbf517f7d6022ae04@mail.gmail.com>
	 <20080104130702.GC20981@elte.hu>
	 <4d8e3fd30801040518q4e115efcoc8967e516fa365f1@mail.gmail.com>
	 <20080104132328.GA27330@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 4, 2008 2:23 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com> wrote:
>
> > > i.e. take the implicit assignment out of the condition. (it's easy
> > > to mistake it for '==' while reviewing the code and forgetting about
> > > the assignment's side-effect)
> >
> > OK, thanks.
> >
> > Is the following correct?
> >
> > Before:
> >  if (!(entry = create_proc_entry("prof_cpu_mask", 0600, root_irq_dir)))
> >
> > After:
> > entry = create_proc_entry("prof_cpu_mask", 0600, root_irq_dir)
> > if (!entry)
> >
> > BTW, how can i compile only the profile.c file?
>
> make kernel/profile.o

Thanks.

> > I would like to verify that my changes (now I'm at total: 2 errors, 1
> > warnings, 599 lines checked) doesn't impact on the compiled code?
>
> check out:
>
>  http://people.redhat.com/mingo/misc/q-size-obj-compare
>
> which does a size and md5 comparison. (assuming your patch is in a quilt
> queue) But if you reorder symbols (due to the EXPORT_SYMBOL moving) the
> md5 might differ. (but size should still be the same)

I'm not using quilt but git.

Unfortunatelly size changed:
paolo@paolo-desktop:/tmp$ size profile.o
   text    data     bss     dec     hex filename
   3718     144      12    3874     f22 profile.o
paolo@paolo-desktop:/tmp$ size profile.o.after
   text    data     bss     dec     hex filename
   3693     144      12    3849     f09 profile.o.after

I'll post the patch for review in a minute.

Thanks.

Ciao,
-- 
Paolo
http://paolo.ciarrocchi.googlepages.com/
