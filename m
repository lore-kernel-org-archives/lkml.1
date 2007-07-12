Return-Path: <linux-kernel-owner+w=401wt.eu-S932874AbXGLMb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932874AbXGLMb1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 08:31:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755974AbXGLMbV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 08:31:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54964 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755410AbXGLMbU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 08:31:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/2] Kexec jump: The first step to kexec base hibernation
Date: Thu, 12 Jul 2007 14:38:41 +0200
User-Agent: KMail/1.9.5
Cc: "Huang, Ying" <ying.huang@intel.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, Jeremy Maitin-Shepard <jbms@cmu.edu>,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
References: <1184167831.12556.13.camel@caritas-dev.intel.com> <20070711172243.ab44c4d4.akpm@linux-foundation.org>
In-Reply-To: <20070711172243.ab44c4d4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707121438.42590.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 12 July 2007 02:22, Andrew Morton wrote:
> On Wed, 11 Jul 2007 15:30:31 +0000
> "Huang, Ying" <ying.huang@intel.com> wrote:
> 
> > Kexec base hibernation has some potential advantages over uswsusp and
> > suspend2. Some most obvious advantages are:
> > 
> > 1. The hibernation image size can exceed half of memory size easily.
> > 2. The hibernation image can be written to and read from almost
> >    anywhere, such as USB disk, NFS.
> > 
> > This patch implements the functionality of "jumping from kexeced
> > kernel to original kernel". That is, the following sequence is
> > possible:
> > 
> > 1. Boot a kernel A
> > 2. Work under kernel A
> > 3. Kexec another kernel B in kernel A
> > 4. Work under kernel B
> > 5. Jump from kernel B to kernel A
> > 6. Continue work under kernel A
> > 
> > This is the first step to implement kexec based hibernation. If the
> > memory image of kernel A is written to or read from a permanent media
> > in step 4, a preliminary version of kexec based hibernation can be
> > implemented.
> > 
> > The kernel B is run as a crashdump kernel in reserved memory
> > region. This is the biggest constrains of the patch. It is planed to
> > be eliminated in the next version. That is, instead of reserving memory
> > region previously, the needed memory region is backuped before kexec
> > and restored after jumping back.
> > 
> > Another constrains of the patch is that the CONFIG_ACPI must be turned
> > off to make kexec jump work. Because ACPI will put devices into low
> > power state, the kexeced kernel can not be booted properly under
> > it. This constrains can be eliminated by separating the suspend method
> > and hibernation method of the devices as proposed earlier in the LKML.
> > 
> > The kexec jump is implemented in the framework of software suspend. In
> > fact, the kexec based hibernation can be seen as just implementing the
> > image writing and reading method of software suspend with a kexeced
> > Linux kernel.
> > 
> > Now, only the i386 architecture is supported. The patch is based on
> > Linux kernel 2.6.22, and has been tested on my IBM T42.
> 
> This sounds awesome.  Am I correct in expecting that ultimately the
> existing hibernation implementation just goes away and we reuse (and hence
> strengthen) the existing kexec (and kdump?) infrastructure?

Well, I haven't had the time to look at it more closely, but I'd assume that if
we can reuse the kexec infrastructure for hibernation, then yes, the existing
implementation will go away.

> And that we get hibernation support almost for free on all kexec (and
> relocatable-kernel?) capable architectures?

We should be able to, in theory.

> And that all the management of hibernation and resume happens in userspace?

I'm not sure what you mean here.

The image saving/loading certainly can be done in the user space.

> I didn't understand the ACPI problem.  Does this mean that CONFIG_ACPI must
> be disabled in the to-be-hibernated kernel, or in the little transient
> kexec kernel?

I think that this mechanism requires that devices be not suspended (ie. in low
power states).

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
