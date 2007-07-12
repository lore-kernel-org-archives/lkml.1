Return-Path: <linux-kernel-owner+w=401wt.eu-S933587AbXGLTTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933587AbXGLTTg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 15:19:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753774AbXGLTT3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 15:19:29 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:53050
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197AbXGLTT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 15:19:28 -0400
Date: Thu, 12 Jul 2007 12:14:20 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Huang, Ying" <ying.huang@intel.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, Jeremy Maitin-Shepard <jbms@cmu.edu>,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH 0/2] Kexec jump: The first step to kexec base hibernation
In-Reply-To: <200707122120.19662.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.64.0707121210210.25614@asgard.lang.hm>
References: <1184167831.12556.13.camel@caritas-dev.intel.com>
 <200707121446.14170.rjw@sisk.pl> <Pine.LNX.4.64.0707121138140.25614@asgard.lang.hm>
 <200707122120.19662.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jul 2007, Rafael J. Wysocki wrote:

>>>> note that what devices get put to sleep could be configurable, potentially
>>>> to the extreme of things like the OLPC (that have hardware designed for
>>>> cheap sleeping) going into a light suspend-to-ram state between keystrokes
>>>> if nothing else has a timer event scheduled before that.
>>>>
>>>> Suspend-do-disk (Hibernate) involves stopping the system, makeing a
>>>> snapshot of ram, writing the snapshot to somewhere and powering off the
>>>> box. on wakeup (power-on) a helper kernel boots, loads the snapshot into
>>>> ram and jumps to the kernel in the snapshot to resume operation.
>>>>
>>>> as I understand the proposal the thought is to do the following
>>>>
>>>> 1. system kernel does suspend-to-ram to put the devices into a known safe
>>>> state.
>>>
>>> Not necessarily suspend-to-RAM.  I'd much prefer it if devices were not put
>>> into low power states but quiesced (ie. no DMA, no interrupts).
>>
>> as I asked in another message, is it really worth having two (or more)
>> modes here?
>
> I think so.  The suspend-to-RAM mode is quite specific and on some platform
> (ie. ACPI) it requires platform support.
>
> We've already reached the conclusion that it's better to separate suspend from
> hibernation, as far as device drivers are concerned, and let's not repeat the
> discussion.

Ok, I seem to have been miscommunicating here. the old combined 
suspend/hibernate took everything to the hibernate state even if you only 
needed to suspend.

I was still seeing two diffent states involved

for suspend go to low-power mode

for hibernate go to low-power mode, kexec the new kernel, do your stuff, power off

note that this doesn't really matter as you have pointed out in other 
messages that we don't really want to put things in low-power mode, and 
Eric pointed out that kexec already handles disabling devices, so it 
sounds like this may be a solved problem if he's right and an issue to be 
solved differently if he's not.

David Lang
