Return-Path: <linux-kernel-owner+w=401wt.eu-S1751964AbZKKL1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751964AbZKKL1d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 06:27:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751300AbZKKL1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 06:27:32 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:25058 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbZKKL1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 06:27:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=iEeFBmcCtLoH+W84fUAyg6VcKa/MSc0IHPHYuTeaI7CoVE329KO3KShd7EAzaezp/+
         S2q/Rp7hxAxEhl+tvXpLJZEbE9Sdaqy+ozKqDBXb2AYesc6/U4VNOLmeefmZb4tjQzwX
         eaV4skak86GQ/DdEZNeer3DneQXjtoXWLgyRU=
Date: Wed, 11 Nov 2009 12:27:33 +0100
From: Andreas Herrmann <herrmann.der.user@googlemail.com>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] x86, ucode-amd: Load ucode-patches once and not
 separately fo each CPU
Message-ID: <20091111112733.GE18592@alberich.amd.com>
References: <20091110110601.GG30802@alberich.amd.com>
 <20091110110723.GH30802@alberich.amd.com>
 <b647ffbd0911100402k4f8648b8ref712f4c60fb8a7b@mail.gmail.com>
 <4AFA6CEB.6020202@ladisch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AFA6CEB.6020202@ladisch.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 11, 2009 at 08:51:07AM +0100, Clemens Ladisch wrote:
> Dmitry Adamushko wrote:
> > btw., if we could safely assume that all the cpus after the ucode
> > upgrade share the same version/patch-level of ucode, we would be able
> > to cache a single ucode instance once and use it for all.

Hmm, I think all ucode-versions needed in a mixed silicon system need
to be cached. See below.

> > I don't recall anyone clearly stating that such multi-cpu-type
> > systems can't really exist.

> > e.g. is it possible to have AMD systems with cpus which differ from
> > each other not only by their revisions (patch_level)?

Mixed silicon is possible.

So at least in theory this could result in different patch_levels
because the required microcode is identified via processor revision
consisting of family/model/stepping.

> The Revision Guide for AMD Family 10h Processors (#41322) says, in
> section "Mixed Silicon Support", that the Opteron B steppings can be
> used with each other (DR-BA, DR-B2, DR-B3; CPUID 00100F2xh).  Are
> different steppings considered equivalent?

The microcode to be loaded is identified by an Equivalent Processor
ID.  The Equivalent Processor ID is determined with an equivalence
table which maps the processor revision IDs to Equivalent Processor
IDs.

Above revision B steppeings have different processor revision IDs:
(because the stepping differs)

  00100F2Ah (DR-BA)
  00100F22h (DR-B2)
  00100F23h (DR-B3)

An example of an equivalence table is

  0x00100F2A; 0x1020
  0x00100F22; 0x1022
  0x00100F23; 0x1022

This means when combining DR-BA and DR-B2 (or DR-B3) different ucode
gets installed for the two processors.


Regards,
Andreas
