Return-Path: <linux-kernel-owner+w=401wt.eu-S1754224AbYAWOZF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224AbYAWOZF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 09:25:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752419AbYAWOYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 09:24:55 -0500
Received: from ns2.suse.de ([195.135.220.15]:37469 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752279AbYAWOYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 09:24:55 -0500
From: Andi Kleen <andi@firstfloor.org>
To: Karl Kiniger <karl.kiniger@med.ge.com>
Subject: Re: [PATCH for mm] Remove iBCS support
Date: Wed, 23 Jan 2008 15:24:34 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: David Newall <davidn@davidnewall.com>, akpm@osdl.org,
       linux-kernel@vger.kernel.org
References: <20080120031153.GB6275@one.firstfloor.org> <p73k5m1lygb.fsf@crumb.suse.de> <20080123141222.GA29243@wszip-kinigka.euro.med.ge.com>
In-Reply-To: <20080123141222.GA29243@wszip-kinigka.euro.med.ge.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801231524.35294.andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 January 2008 15:12:22 Karl Kiniger wrote:
> On Wed 080123, Andi Kleen wrote:
> > Karl Kiniger <karl.kiniger@med.ge.com> writes:
> > > FYI,
> > >
> > > on http://www.feise.com/~jfeise/Downloads/linux-abi/
> > >
> > > a patch named  linux-abi-2.6.22.3_3.diff.bz2 can be found.
> >
> > So just add a reversed version of my binfmt_elf patch to that.
> > If people need to apply a patch anyways it doesn't make much
> > difference if it has a few more hunks.
>
> it will force to recompile. The latest version of linux-abi  on
> SourceForge is named ibcs-3_4.tgz and IIRC it can be built
> as an external module w/o kernel recompile.

Ok I wasn't aware of that earlier.

Does it really work on a recent kernel (as in .23 or .24-rc)? I have my doubts 
especially since  the default_ldt is gone it will be probably difficult for 
an external module to implement the lcall7 and lcall27 entry points.

<reads code> Ok it seems to load its own GDT and IDT. With that lcall
might still work. It's unclear how it works on SMP and how TLS rewriting
still works. But you don't really expect us to support any kernel modules who 
do such hacks, do you? This thing is likely pure race country anyways. I hope
nobody uses it in production.

Anyways what it could still do is to register an own copy or wrapper of the 
ELF loader that is registered before the normal binfmt_elf and then
checks for its own flavour of ELF and handles that and passes all
other binaries on.

I stand by my earlier point that it doesn't make sense to have all
Linux kernels always execute these strcmps.

-Andi
