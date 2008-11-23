Return-Path: <linux-kernel-owner+w=401wt.eu-S1758129AbYKWJ3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758129AbYKWJ3t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 04:29:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754199AbYKWJ3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 04:29:40 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:52960 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872AbYKWJ3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 04:29:39 -0500
Date: 23 Nov 2008 10:14:00 +0100
From: lirc@bartelmus.de (Christoph Bartelmus)
To: pavel@suse.cz
Cc: jonsmirl@gmail.com
Cc: jrm8005@gmail.com
Cc: linux-kernel@vger.kernel.org
Message-ID: <AqQThtpZjFB@christoph>
In-Reply-To: <20081115115859.GA1572@ucw.cz>
Subject: Re: In-kernel IR remote control support
User-Agent: OpenXP/4.10.7369 (Linux) (i386)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX18OuP/zYuEhh+6Ph5DUc0CeE9QEpUYCvoN1tVo
 PcQZz3bw5BIqqMpTmgwqkzR3xEP8lr8pNZ9J+dP+T4hYgptw+h
 iV0RIkk/aRhLagBE0TL36Wy3pGLXPQVDWKxcN377Ys=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

on 15 Nov 08 at 12:58, Pavel Machek wrote:
[...]
> On Thu 2008-11-13 00:09:00, Christoph Bartelmus wrote:
>> Hi,
>>
>> on 12 Nov 08 at 14:39, J.R. Mauro wrote:
>> [...]
>>> On Wed, Nov 5, 2008 at 3:07 PM, Jon Smirl <jonsm...@gmail.com> wrote:
>>>> On Wed, Nov 5, 2008 at 2:59 PM, J.R. Mauro <jrm8...@gmail.com> wrote:
>>>>> On Wed, Nov 5, 2008 at 2:47 PM, Jon Smirl <jonsm...@gmail.com> wrote:
>>>>>> New release of in-kernel IR support implementing evdev support. The
>>>>>> goal of in-kernel IR is to integrate IR events into the evdev input
>>>>>> event queue and maintain ordering of events from all input devices.
>>>>>> Still looking for help with this project.
>>
>>>>> (Forgive me if this has already been asked or dealt with)
>>
>>>>> Have you contacted the LIRC developers? Is there any overlap between
>>>>> your projects?
>>
>>>> The LIRC people know about this. Pieces of the code are coming from
>>>> the LIRC source base and being reworked for kernel inclusion.
>>
>>> Great, it's nice to see there's cooperation.
>>
>> LOL. There's just a small omission from Jon's side...
>> Yes, LIRC people know about this. And Jon has a no-go from me.
>>
>> Decoding IR protocols in-kernel is the wrong way IMHO and this will not be
>> supported by LIRC as long as I maintain LIRC.

> Time to fork lirc...?

This wouldn't be a fork. It has nothing to do with how LIRC currently is  
working.

> Can you elaborate?  I don't see why IR remotes deserve special
> handling. I'd expect to just plug in the receiver and have it work as
> /dev/input/*.
>
>> It's simply not possible to decode all existing IR protocols and LIRC  
just
>> stores the timing data for these protocols as-is without trying to decode
>> them. With the in-kernel decoding approach these remotes cannot be
>> supported. I'm not willing to sacrifice the support for these even though
>> they only consist of a very small fraction of remotes in use.

> So you make it suck for everyone just because few obscure IR
> remotes. Perfect enemy of good, I'd say :-(.

Watch your words. This is getting personal.

Who is telling you that LIRC cannot work like simply plugging in the  
receiver and start using the remote?

You can have LIRC setup to decode all common remote control protocols.  
It's just a matter of proper packaging and pre-configuration.
You don't have to write a single line of code for this (I still have to  
add uinput support, though, which I probably would have done by now, if I  
weren't busy writing posts like this).

> Can we merge the common ones into the kernel, while still keeping the
> obscure ones in userspace using uinput or something?

Why do you want to complicate things even more. When you have an obscure  
protocol, you have to use LIRC style kernel drivers anyway. Why not use  
them for all protocols if you need them anyway?
Everyone seems to be so focussed on the input layer, that he does not even  
consider that it might not be the right approach for all cases.

> I don't see why Jon's work bothers you. He's trying to do the right
> support for the common remotes. That seems like a net plus to me, and
> you can still keep the obscure ones in userland.

Jon's code and the LIRC approach exclude each other. It does not make  
sense to have both in the kernel. There have been attempts to clean up  
LIRC code to be included in the kernel. The current discussion lessens my  
hope that this will happen anytime soon.

The decision to include some IR support using the Linux input layer some  
time ago has forced *me* to add support for this in LIRC and explain to  
people why for some devices they need LIRC drivers, and for some they need  
the kernel drivers, and for other configurations they have to explicitly  
disable the kernel drivers and replace them by LIRC drivers, etc.
I'm just telling you now, that I will not do this work again for the  
drivers in question.

Christoph
