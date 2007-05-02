Return-Path: <linux-kernel-owner+w=401wt.eu-S1767023AbXEBVRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767023AbXEBVRz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 17:17:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423508AbXEBVRy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 17:17:54 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:35343 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423524AbXEBVRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 17:17:53 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Gerd Hoffmann <kraxel@redhat.com>,
       Jeff Garzik <jeff@garzik.org>, patches@x86-64.org,
       linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@in.ibm.com>,
       virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [patches] [PATCH] [21/22] x86_64: Extend bzImage protocol for relocatable bzImage
References: <20070428758.455116000@suse.de>
	<20070428175909.1D09D151CA@wotan.suse.de> <46338D72.70402@garzik.org>
	<m1fy6kdzi1.fsf@ebiederm.dsl.xmission.com> <4634483E.9030307@goop.org>
	<m14pmz8bbb.fsf@ebiederm.dsl.xmission.com> <46363A68.6080201@goop.org>
	<46385A8A.6070405@redhat.com> <4638AB55.20408@goop.org>
	<4638F9BE.8090508@zytor.com>
Date: Wed, 02 May 2007 15:17:16 -0600
In-Reply-To: <4638F9BE.8090508@zytor.com> (H. Peter Anvin's message of "Wed,
	02 May 2007 13:51:10 -0700")
Message-ID: <m13b2fvsbn.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> Jeremy Fitzhardinge wrote:
>> 
>> True.  But the plan is already to make bzImage an ELF file, so notes
>> would seem to be the best option.  At worst, it could be ELF notes
>> wrapped in some other container, but that's not pretty.
>> 
>
> It's not going to happen.  Too many boot loaders make assumptions about
> ELF files which aren't really compatible; the entry conditions for an
> ELF from a boot loader are pretty ill-defined, so I think this is a bad
> idea.
>
> At the very least, it shouldn't present the ELF magic number IMNSHO.

I agree that there are some issues.

However we need the information that is contained in ELF headers or
a semantic equivalent so we might as well play with the possibility.

There are two practical issues for ELF and bootloaders.
virtual vs. physical addresses.   In a bzImage header all
we will present will be physical addresses so that isn't an
issue.

The other issue is what is the format of the arguments that the
executable expects.  There seems to be 0 consensus on this so
bootloaders simply can't agree, and any bootloader that is
prepared to deal with kernels from different locations is going
to have to cope.

So I figure we keep our current calling conventions and have a
note saying that we are linux so the format can be auto-detected.

There are of course plenty of bootloaders that load whatever happens
to be their OS kernel however they managed to get ld to spit it out,
and there are some really weird things going on there.  But that doesn't
matter because those bootloaders can make no pretense at being general
purpose.

There is a lot of future flexibility that comes from this in addition
to making x86 closer to the other architectures.

I do agree we need to tread carefully, but I have yet to hear about
any show stopper bugs, and it works well enough at least one major distro
has shipped a linux kernel bzImage with an ELF header.

So we won't do this casually and if it there are real problems we will
remove the ELF magic number.

Eric
