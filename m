Return-Path: <linux-kernel-owner+w=401wt.eu-S1753345AbYLMXOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345AbYLMXOd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 18:14:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752053AbYLMXOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 18:14:25 -0500
Received: from rn-out-0910.google.com ([64.233.170.190]:6824 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049AbYLMXOY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 18:14:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=NtEy96ET0wfPveYTGin+9psP0DlUAx7IjJ46wHAOCXQR82qgVtkAEbe8KpOqsjTrsK
         VY6GYGhDubghUbbHQQVe5o+Vh9clO1qF+66glRlGOyLGuveJ+LTYwEYgKgfOmTpz06nm
         /cW4lfkQVZDTlkmANvNad9hb0YSU7v/83/IOs=
Message-ID: <21d7e9970812131514v328eff11o9a2fcaa0b2cce1db@mail.gmail.com>
Date: Sun, 14 Dec 2008 09:14:23 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "=?ISO-8859-1?Q?C=E9dric_Godin?=" <cedric@belbone.be>
Subject: Re: Xorg crash at first start
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <493CF58F.9080503@belbone.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <4937E87C.6030106@belbone.be>
	 <21d7e9970812042027w13271ceas91ecab87aa60562e@mail.gmail.com>
	 <49391512.4000604@belbone.be>
	 <21d7e9970812072029w2b5f47ecoeb1d042880e4bff1@mail.gmail.com>
	 <493CF58F.9080503@belbone.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 8, 2008 at 8:23 PM, Cédric Godin <cedric@belbone.be> wrote:
> Dave Airlie wrote:
>> On Fri, Dec 5, 2008 at 9:48 PM, Cédric Godin <cedric@belbone.be> wrote:
>>
>>> Dave Airlie wrote:
>>>
>>>> On Fri, Dec 5, 2008 at 12:26 AM, Cédric Godin <cedric@belbone.be> wrote:
>>>>
>>>>
>>>>> Hello,
>>>>>
>>>>> With the v2.6.28-rc7-105-gfeaf384 kernel, when booting my compaq with
>>>>> attached config, the screen switches in graphical mode but then switches
>>>>> back in textual mode with an 'irq10 nobody cared' error in dmesg (attached).
>>>>>
>>>>> If I restart kdm by hand, all is ok (i have my kdm) but the error yet
>>>>> appears in dmesg (at each X start in fact).
>>>>>
>>>>> I bisected the problem (git bisect log attached) and found the following
>>>>> commit as "culprit" :
>>>>>
>>>>> commit 52440211dcdc52c0b757f8b34d122e11b12cdd50
>>>>> Author: Keith Packard <keithp@keithp.com>
>>>>> Date:   Tue Nov 18 09:30:25 2008 -0800
>>>>>
>>>>>    drm: move drm vblank initialization/cleanup to driver load/unload
>>>>>
>>>>>    drm vblank initialization keeps track of the changes in driver-supplied
>>>>>    frame counts across vt switch and mode setting, but only if you let
>>>>> it by
>>>>>    not tearing down the drm vblank structure.
>>>>>
>>>>>    Signed-off-by: Keith Packard <keithp@keithp.com>
>>>>>    Signed-off-by: Dave Airlie <airlied@redhat.com>
>>>>>
>>>>> Reverting it brings back my X screen at first start.
>>>>>
>>>>>
>>>> Just for testing, can you try without using vesafb....
>>>>
>>>> so remove the vga= line from the commandline or build the kernel
>>>> without vesafb support.
>>>>
>>>>
>>> I can confirm the problem without vesafb
>>>
>>
>> Can you boot to a runlevel with no X running
>> do
>> modprobe drm debug=1
>> or if drm is loaded
>> echo 1 > /sys/module/drm/parameters/debug
>> and then start X
>>
>> and attach the dmesg here.
>>
>> I've some ideas but no concrete reason for what might be going wrong.
>>
>> Dave.
>>
>
> First sorry for late answer.
> Here is the dmesg asked in attach (modprobe + startx).
> Hope it helps.
>

Can you check out latest Linus git and retry this.

Dave.
