Return-Path: <linux-kernel-owner+w=401wt.eu-S1755530AbZGFX5t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530AbZGFX5t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 19:57:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754318AbZGFX4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 19:56:35 -0400
Received: from mail-pz0-f193.google.com ([209.85.222.193]:62381 "EHLO
	mail-pz0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755215AbZGFX4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 19:56:32 -0400
Message-ID: <4A528EE5.5090901@gawab.com>
Date: Mon, 06 Jul 2009 16:55:17 -0700
From: Justin Madru <jdm64@gawab.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090319)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       linux-input@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: Re: 2.6.30-rc1: touchpad disabled on hibernation
References: <4A438BA7.9010800@tuffmail.co.uk> <8db1092f0906251016l5ac85bfdpbac841b939cfac2a@mail.gmail.com> <4A43B1FC.7060609@tuffmail.co.uk> <200907070040.14796.rjw@sisk.pl>
In-Reply-To: <200907070040.14796.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Thursday 25 June 2009, Alan Jenkins wrote:
>   
>> Maciej Rutecki wrote:
>>     
>>> 2009/6/25 Alan Jenkins <alan-jenkins@tuffmail.co.uk>:
>>>   
>>>       
>>>> The synaptics touchpad on my EeePC 701 dies on hibernation.  2.6.30 was
>>>> fine, and it doesn't happen on suspend to ram either.  There are no
>>>> obvious error messages, but maybe this boot message is relevant:
>>>>
>>>> Platform driver 'i8042' needs updating, please use dev_pm_ops
>>>>
>>>>     
>>>>         
>>> Similar on s2disk, HP/Compaq notebook. Try reload psmouse module. I
>>> reported it, but nobody answer.
>>>   
>>>       
>> That works, thanks.
>>     
>
> Alan, Maciej, can you both try the patch at
> http://patchwork.kernel.org/patch/34075/, please?
>
> Rafael
>
>   
I've been having the same issue (laptop touchpad not working after resume).
Your patch seams to fix the problem. I no longer have to reload the 
psmouse module after resume.

$ modinfo psmouse

filename:      
/lib/modules/2.6.31-rc2-git/kernel/drivers/input/mouse/psmouse.ko
license:        GPL
description:  PS/2 mouse driver
author:         Vojtech Pavlik <vojtech@suse.cz>
alias:            serio:ty05pr*id*ex*
alias:            serio:ty01pr*id*ex*
depends:
vermagic:     2.6.31-rc2-git SMP preempt mod_unload modversions PENTIUM4 
4KSTACKS
parm:           proto:Highest protocol extension to probe (bare, imps, 
exps, any). Useful for KVM switches. (proto_abbrev)
parm:           resolution:Resolution, in dpi. (uint)
parm:           rate:Report rate, in reports per second. (uint)
parm:           smartscroll:Logitech Smartscroll autorepeat, 1 = enabled 
(default), 0 = disabled. (bool)
parm:           resetafter:Reset device after so many bad packets (0 = 
never). (uint)
parm:           resync_time:How long can mouse stay idle before forcing 
resync (in seconds, 0 = never). (uint)

Justin Madru
