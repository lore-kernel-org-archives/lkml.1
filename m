Return-Path: <linux-kernel-owner+w=401wt.eu-S933324AbXGLMqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933324AbXGLMqj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 08:46:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756581AbXGLMqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 08:46:32 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55091 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754956AbXGLMqb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 08:46:31 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [PATCH 0/2] Kexec jump: The first step to kexec base hibernation
Date: Thu, 12 Jul 2007 14:53:48 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, Jeremy Maitin-Shepard <jbms@cmu.edu>,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
References: <1184167831.12556.13.camel@caritas-dev.intel.com> <20070711172243.ab44c4d4.akpm@linux-foundation.org> <1184251423.9346.55.camel@caritas-dev.intel.com>
In-Reply-To: <1184251423.9346.55.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707121453.49616.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 12 July 2007 16:43, Huang, Ying wrote:
> On Wed, 2007-07-11 at 17:22 -0700, Andrew Morton wrote:
> > This sounds awesome.  Am I correct in expecting that ultimately the
> > existing hibernation implementation just goes away and we reuse (and hence
> > strengthen) the existing kexec (and kdump?) infrastructure?
> > And that we get hibernation support almost for free on all kexec (and
> > relocatable-kernel?) capable architectures?
> > And that all the management of hibernation and resume happens in userspace?
> 
> Yes. Ultimately, most of the hibernation code such as process freezer,
> memory shrinking, memory snapshot (atomic copy), image reading/writing
> can go away, because kexec based hibernation doesn't depend on them.
> Just the device/CPU state quiescent/save/restore is necessary to remain.
> And, the management of hibernation and resume will happen in userspace.
> 
> > 
> > I didn't understand the ACPI problem.  Does this mean that CONFIG_ACPI must
> > be disabled in the to-be-hibernated kernel, or in the little transient
> > kexec kernel?
> 
> Under current implementation of device state quiescent/save/restore, the
> CONFIG_ACPI must be turned off both in to-be-hibernated kernel and
> transient kexec kernel.
> 
> But the hibernation people are going to separate the device suspend from
> device hibernate. The device hibernate will put device in quiescent
> state but not in low power state. When this is done, it is not necessary
> to disable CONFIG_ACPI at all. It is just a workaround for current
> implementation that disabling CONFIG_ACPI.
> 
> > How close do you think all this is to being a viable thing?
> 
> The kexec jump is the first step, maybe the simplest step. There are
> many other issues to be resolved, at least the following ones.
> 
> 1. Separate device suspend from device hibernate.

Step 0, I'd say. :-)

> 2. Do not reserve memory for kexec kernel. That is, backup needed memory
> before kexec and restore them after kexec.

I don't think this is very important initially.

> 3. Support the in-place kexec? The relocatable kernel is not necessary
> if this can be implemented.
> 4. Image writing/reading. (Only user space application is needed).

And a kernel interface for that application.

> 5. A smooth resume process. Maybe it is not needed to kexec a new kernel
> for resume. For example, in the first stage of kernel boot, just first
> 16M (or a little more) RAM is used, if the resume image is found, the
> saved kernel image is resumed; if the resume image is not found, turn on
> the remaining RAM. This will depends on 3.

I think that this is the most difficult part of the whole thing.

> 6. Reduce the boot-up time of kexec kernel. Maybe the kexec kernel can
> be hibernate/resume by the normal kernel too. This way, a real
> kexec/boot-up is only needed for the first time.

I'm not sure what you mean.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
