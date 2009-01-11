Return-Path: <linux-kernel-owner+w=401wt.eu-S1755200AbZAKSGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200AbZAKSGo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 13:06:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752241AbZAKSGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 13:06:32 -0500
Received: from mx.hosting-seguridad.com ([88.198.93.158]:51724 "EHLO
	mx.hosting-seguridad.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbZAKSGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 13:06:30 -0500
X-Spam-Score: -0.895
Message-ID: <496A3527.2090702@rs-labs.com>
Date: Sun, 11 Jan 2009 19:06:31 +0100
From: Roman Medina-Heigl Hernandez <roman@rs-labs.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; es-ES; rv:1.8.1.19) Gecko/20081209 Thunderbird/2.0.0.19 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Alistair John Strachan <alistair@devzero.co.uk>
CC: Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org
Subject: Re: Oops with Gigabyte motherboard "GA-X48-DQ6" and r8168 Realtek
 driver
References: <49671B77.7080705@rs-labs.com> <200901101255.07611.alistair@devzero.co.uk> <4968ED53.8060404@rs-labs.com> <200901102035.19733.alistair@devzero.co.uk>
In-Reply-To: <200901102035.19733.alistair@devzero.co.uk>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alistair John Strachan escribió:
> Hi Roman,
> 
> On Saturday 10 January 2009 18:47:47 Roman Medina-Heigl Hernandez wrote:
>> Alistair John Strachan escribió:
>>> My advice to you is to install the very latest Debian kernel (2.6.27) in
>>> which this bug has been fixed. That said, I think if you do this, you
>>> won't have any further problems. Using the vendor driver instead of the
>>> one in mainline probably isn't a good idea.
> [snip]
>> The working machine is an AMD dual core with 2 MB RAM and 1 rtl8111B NIC
>> (being the non-working an Intel Quad core with 4 MB RAM and 2 rtl8111B
>> NICs). So yes, as you said, the problems could be due to Quad / 4GB RAM.
> 
> Francois Romieu would be the best person to confirm, but I suspect you are 
> correct and it does not surprise me that the vendor driver has the same bug.
> 
> It would manifest exactly like this -- the NIC would be basically non-
> functional with 4GB RAM, but the minute it stops using the swiotlb or AMD GART 
> IOMMU there was no problem.
> 
>> There's no Debian-official 2.6.27 deb packages (latest is 2.6.26),
>> according to:
>> http://packages.qa.debian.org/l/linux-2.6.html
>> Best for etch I've found is a 2.6.26 deb package (backport).
>>
>> I suppose you're refering to the ultra-experimental "trunk" branch at:
>> deb http://kernel-archive.buildserver.net/debian-kernel trunk main
>> Right?
>>
>> I'll give it a try, it seems a good choice (given the circunstances).
>> Another option: Do you think it worth the pain to compile a custom 2.6.28
>> kernel? (in other words, do you think it contains fixes that could solve
>> the strange issues I've been affected with? I don't follow kernel
>> development so I cannot answer this question but perhaps you could...).
> 
> Yes, vanilla 2.6.27 and of course 2.6.28 have the fixes. There's no 
> requirement to use Debian's mildly patched kernels if you don't want to. The 
> reason I recommended the Debian package (though unfortunately as you point out 
> it doesn't yet exist) is that it's less faff and is presumably more likely to 
> work in your production environment.

I've built two custom .deb packages for kernels:
- 2.6.28
- 2.6.27.10

The reason why I built the second one is due to this:
http://marc.info/?l=linux-kernel&m=123074869611409&w=4

It scared me a bit!

Now the dilemma is: which kernel to choose? 2.6.28 should be better but if
the former bug report is confirmed....... Kernel 2.6.28 have several r8169
patches merged; this could be good... or not... who knows... In the other
side, 2.6.27.10 is perhaps newer enough, and it's reported to work ok
(well, not exactly: former bug report said "r8169 worked fine in 2.6.27.8",
and since there are no changes in r8169 from 2.6.27.7 to 2.6.27.10, it
should be safe).

I'll probably go for 2.6.27.10. If you think I'm not right, please, correct
me :-)

> Another (good) option would be to grab the Debian kernel sources (apt-get 
> source linux-image-<whatever>) and then patch it with the fix, available from 
> this bugzilla thread:
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=9468
> 
> Then debuild it as normal (hopefully you're familiar with this process).

If I have to go towards the PITA of maintaining my own .deb kernel package
I prefer to use latest kernels (2.6.18 is pretty older) so at least I'll
have the benefits of better hardware support (drivers) and (hopefully) more
fixes applied :)

>> Thank you very much for your comments. They are greatly appreciated.
> 
> No problem. I ran into similar problems with this hardware many months ago and 
> nobody knew anything about it. It's just unfortunate that Debian are behind 
> the curve in terms of kernel version.

Yes, but Debian has also reasons to keep doing this so "stable" release
continues being called "stable" :-) Anyway, I don't want to enter a
flamewar here.

I'll try to install one of the new kernels tomorrow evening...

-- 

Saludos,
-Roman

PGP Fingerprint:
09BB EFCD 21ED 4E79 25FB  29E1 E47F 8A7D EAD5 6742
[Key ID: 0xEAD56742. Available at KeyServ]
