Return-Path: <linux-kernel-owner+w=401wt.eu-S1754719AbZAJSr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719AbZAJSr6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 13:47:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751059AbZAJSru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 13:47:50 -0500
Received: from mx.hosting-seguridad.com ([88.198.93.158]:54190 "EHLO
	mx.hosting-seguridad.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbZAJSru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 13:47:50 -0500
X-Spam-Score: -0.889
Message-ID: <4968ED53.8060404@rs-labs.com>
Date: Sat, 10 Jan 2009 19:47:47 +0100
From: Roman Medina-Heigl Hernandez <roman@rs-labs.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; es-ES; rv:1.8.1.19) Gecko/20081209 Thunderbird/2.0.0.19 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Alistair John Strachan <alistair@devzero.co.uk>
CC: Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org
Subject: Re: Oops with Gigabyte motherboard "GA-X48-DQ6" and r8168 Realtek
 driver
References: <49671B77.7080705@rs-labs.com> <200901092252.46448.elendil@planet.nl> <4967DE52.3040709@rs-labs.com> <200901101255.07611.alistair@devzero.co.uk>
In-Reply-To: <200901101255.07611.alistair@devzero.co.uk>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alistair John Strachan escribió:
> On Friday 09 January 2009 23:31:30 Roman Medina-Heigl Hernandez wrote:
>> Frans Pop escribió:
>>> Roman Medina-Heigl Hernandez wrote:
>>>> It includes two RTL8111/8168B NICs, which seem the cause of the kernel
>>>> crashes (*but I'm not sure*)..., a Quad core, 4GB RAM and two 500GB HDs.
>>>>
>>>> I installed Debian Linux (4.0) on it and I'm getting *kernel panic*
>>>> errors (r8168 module) when set to production state. I couldn't get any
>>>> kernel debug messages since I'm using Debian stock kernel
>>>> (2.6.18-6-686-bigmem) and I'm not a kernel hacker either.
>>> Have you tried the 2.6.24 kernel that is available for Debian Etch? That
>>> seems to me the most logical thing to try first as a possible solution.
>> I didn't (although I thought of it). It seems to me like a blind attempt
>> and the problem is that I cannot afford to waste another "production
>> attempt" and that I cannot reproduce the crash whenever I want, so if I
>> upgrade I'll not be able to know whether the problem is fixed or not until
>> I got a new crash (or not). Moreover, if the root cause of the problem is
>> r8168 driver, it will crash in both cases (the driver doesn't change, it's
>> compiled from source by me).
> 
> One thing to bear in mind is that if you're using a CPU which goes via swiotlb 
> (such as a pre-nehalem Intel Quad) 2.6.24 won't be new enough. The r8169 
> driver until recently had a grave bug on >=4GB RAM systems where the kernel 
> would crash after some amount of transfer.

Oh!

> My advice to you is to install the very latest Debian kernel (2.6.27) in which 
> this bug has been fixed. That said, I think if you do this, you won't have any 
> further problems. Using the vendor driver instead of the one in mainline 
> probably isn't a good idea.

I'm using vendor driver because mainline (r8169) didn't work for my
rtl8111B chipset. The r8169 driver recognized both NICs but it was
constantly giving failures at recognizing link (sometimes worked, sometimes
not) and NIC leds weren't working ok also (clear signal of something wasn't
working properly...). When I banned r8169 module and installed/loaded
vendor driver (r8168), NICs problems disappeared. That's why I was using
vendor driver. I didn't note estability problems by then; they only
appeared when running in production environment (Murphy's law!) :-(

Another curiosity: I've discovered than *another* machine I'm administering
(different customer, different hardware, different isp... but same Debian
version and same kernel: 2.6.18-6-686-bigmem) is using r8169 module without
problems at all. And guess it, it has the same NIC hardware (!!!):
02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B
PCI Express Gigabit Ethernet controller (rev 01)

The working machine is an AMD dual core with 2 MB RAM and 1 rtl8111B NIC
(being the non-working an Intel Quad core with 4 MB RAM and 2 rtl8111B
NICs). So yes, as you said, the problems could be due to Quad / 4GB RAM.

There's no Debian-official 2.6.27 deb packages (latest is 2.6.26),
according to:
http://packages.qa.debian.org/l/linux-2.6.html
Best for etch I've found is a 2.6.26 deb package (backport).

I suppose you're refering to the ultra-experimental "trunk" branch at:
deb http://kernel-archive.buildserver.net/debian-kernel trunk main
Right?

I'll give it a try, it seems a good choice (given the circunstances).
Another option: Do you think it worth the pain to compile a custom 2.6.28
kernel? (in other words, do you think it contains fixes that could solve
the strange issues I've been affected with? I don't follow kernel
development so I cannot answer this question but perhaps you could...).

Thank you very much for your comments. They are greatly appreciated.

-- 

Saludos,
-Roman

PGP Fingerprint:
09BB EFCD 21ED 4E79 25FB  29E1 E47F 8A7D EAD5 6742
[Key ID: 0xEAD56742. Available at KeyServ]
