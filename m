Return-Path: <linux-kernel-owner+w=401wt.eu-S1764249AbXGPPcz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764249AbXGPPcz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 11:32:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755017AbXGPPcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 11:32:48 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43322 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754331AbXGPPcr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 11:32:47 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [PATCH 0/2] Kexec jump: The first step to kexec base hibernation
Date: Mon, 16 Jul 2007 17:40:25 +0200
User-Agent: KMail/1.9.5
Cc: david@lang.hm, Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
References: <1184167831.12556.13.camel@caritas-dev.intel.com> <200707161417.50166.rjw@sisk.pl> <1184596950.24143.28.camel@caritas-dev.intel.com>
In-Reply-To: <1184596950.24143.28.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707161740.26703.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 16 July 2007 16:42, Huang, Ying wrote:
> On Mon, 2007-07-16 at 14:17 +0200, Rafael J. Wysocki wrote:
> > > is this  a matter of running some test to find out, or is this a question 
> > > for the kexec implemantors?
> > 
> > Actually, I'd like someone to tell me. ;-)
> > 
> > I've browsed the kexec code, but haven't found anything related to the devices
> > in it.  Perhaps I didn't know where to look ...
> 
> There are two stages for kexec. For "normal" kexec, first the
> sys_kexe_load is called to load the kernel image, then
> sys_reboot(LINUX_REBOOT_CMD_KEXEC) is called to boot the new kernel.

OK, thanks.  This is the information that I was missing.

> The call chain is as follow:
> 
> sys_reboot(LINUX_REBOOT_CMD_KEXEC)
>     kernel_kexec
>         kernel_restart_prepare
>             device_shutdown
>         machine_shutdown
>         machine_kexec
> 
> In device_shutdown, the dev->bus->shutdown or dev->driver->shutdown of
> every device is called to put device in quiescent state. In
> machine_kexec, the new kernel is booted.

Yes.

> So, for normal kexec, there is no code path for device state saving and
> restoring.

Exactly.

> State of device can be restore after shutdown? I don't think so.

No, it can't, but we need something like this for hibernation and
device_shutdown() is not appropriate for this purpose IMO.

> > I think that the right approach is to separate devices' suspend from the
> > devices' hibernation-related operations FIRST.  Then, many different approaches
> > to hibernation will be much easier to implement than they are now.
> > 
> > I've been saying this for weeks now, but no one seems to listen frankly I'm
> > tired of repeating it:
> 
> I agree with you on this. :)

OK :-)

> > If we want to improve things, let's do that IN AN ORDERED WAY.  If everyone
> > will come up with a new idea every two days, we won't be able to get anything
> > actually _done_.
> 
> Yes, and I am very glad to collaborate with everybody who is interested
> in this subject. But I think we should try to verify our idea with code
> as early as possible. Now, I am trying to implement a prototype of
> kexec/kdump based image writing/reading mechanism to verify the
> feasibility. (I suppose you are working on separating device suspend and
> device hibernate).

Yes, I am.

> What do you think about the pattern of collaboration?

Sounds good.

> At last, thank you very much for your valuable reminding in the mail of
> "hibernation considerations".

You're welcome. :-)

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
