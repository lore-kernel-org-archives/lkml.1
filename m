Return-Path: <linux-kernel-owner+w=401wt.eu-S1753830AbZK2MHF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830AbZK2MHF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 07:07:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753428AbZK2MHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 07:07:04 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:61961 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937AbZK2MHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 07:07:01 -0500
Date: 29 Nov 2009 12:24:00 +0100
From: lirc@bartelmus.de (Christoph Bartelmus)
To: stefanr@s5r6.in-berlin.de
Cc: awalls@radix.net
Cc: dmitry.torokhov@gmail.com
Cc: j@jannau.net
Cc: jarod@redhat.com
Cc: jarod@wilsonet.com
Cc: jonsmirl@gmail.com
Cc: khc@pm.waw.pl
Cc: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-media@vger.kernel.org
Cc: maximlevitsky@gmail.com
Cc: mchehab@redhat.com
Cc: superm1@ubuntu.com
Message-ID: <BDodb$iHqgB@lirc>
In-Reply-To: <4B11881B.7000204@s5r6.in-berlin.de>
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel IR 	system?
User-Agent: OpenXP/4.10.7369 (Linux) (i386)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX1/mDG4dKwqUOl4ebfhaxntMwE5Sj8TM/FgelUL
 6iPfBmhgAnXo4rWwiPn4whlJKmTky/AQpeve3pmfl5n1fa+5yM
 FnFU/wxcU0n3f1Tjmdivf2F25fg2Y9V
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stefan,

on 28 Nov 09 at 21:29, Stefan Richter wrote:
> Jon Smirl wrote:
>> On Sat, Nov 28, 2009 at 2:45 PM, Stefan Richter
>> <stefanr@s5r6.in-berlin.de> wrote:
>>> Jon Smirl wrote:
>>>> Also, how do you create the devices for each remote? You would need to
>>>> create these devices before being able to do EVIOCSKEYCODE to them.
>>> The input subsystem creates devices on behalf of input drivers.  (Kernel
>>> drivers, that is.  Userspace drivers are per se not affected.)
>>
>> We have one IR receiver device and multiple remotes. How does the
>> input system know how many devices to create corresponding to how many
>> remotes you have?

> If several remotes are to be used on the same receiver, then they
> necessarily need to generate different scancodes, don't they?  Otherwise
> the input driver wouldn't be able to route their events to the
> respective subdevice.

Consider this case:
Two remotes use different protocols. The scancodes after decoding happen  
to overlap.
Just using the scancodes you cannot distinguish between the remotes.  
You'll need to add the protocol information to be able to solve this which  
complicates the setup.

In LIRC this is solved by having protocol parameters and scancode mapping  
in one place.

Christoph
