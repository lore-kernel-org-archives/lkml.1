Return-Path: <linux-kernel-owner+w=401wt.eu-S933129AbXGLNwK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933129AbXGLNwK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 09:52:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760445AbXGLNv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 09:51:56 -0400
Received: from rtr.ca ([64.26.128.89]:2781 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757331AbXGLNv4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 09:51:56 -0400
Message-ID: <469631FA.2070405@rtr.ca>
Date: Thu, 12 Jul 2007 09:51:54 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: david@lang.hm, Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Huang, Ying" <ying.huang@intel.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, Jeremy Maitin-Shepard <jbms@cmu.edu>,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH 0/2] Kexec jump: The first step to kexec base hibernation
References: <1184167831.12556.13.camel@caritas-dev.intel.com> <4695C096.5080400@goop.org> <Pine.LNX.4.64.0707112319550.28090@asgard.lang.hm> <200707121446.14170.rjw@sisk.pl>
In-Reply-To: <200707121446.14170.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Thursday, 12 July 2007 08:43, david@lang.hm wrote:
>> On Wed, 11 Jul 2007, Jeremy Fitzhardinge wrote:
>>
>>> Andrew Morton wrote:
..
>> 8. hibernate kernel does syspend-to-ram to put the devices into a known 
>> safe state.
> Again, the devices should be quiesced rather then suspended in this step.

That's just not possible.  The Hibernate kernel will not have all
of the same device drivers as the mainline kernel.  Or at least that's
what people have previously stated here.

..
>>>>  This sounds awesome.  Am I correct in expecting that ultimately the
>>>>  existing hibernation implementation just goes away and we reuse (and hence
>>>>  strengthen) the existing kexec (and kdump?) infrastructure?

No, not so simple.  We still need much of the code to santize devices
upon wakeup from hibernation.   And adding this extra reboot-kernel step
in the midst of hibernate will double the time it takes (ugh).

Currently, TuxOnIce(suspend2) takes about 10 seconds to suspend my notebook.
Switching to this new scheme would double that to 10 seconds to boot/probe,
plus the original 10 seconds to hibernate.  Assuming the new implementation
even comes close to suspend2 speed.

And the complexity and difficulty of setup really scares me.
Right now, we've got a pretty good/fast in-kernel (well, external patch)
that allows my machines to hibernate very quickly, wake up even faster,
and not swap like mad afterwards.  Without any external programs,
initramfs, or extra kernels required.

And we want to replace this with an ultra-complex setup because.. ????

Cheers
