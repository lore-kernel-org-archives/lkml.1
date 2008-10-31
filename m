Return-Path: <linux-kernel-owner+w=401wt.eu-S1753258AbYJaQKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258AbYJaQKi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 12:10:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751379AbYJaQKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 12:10:10 -0400
Received: from hobbit.corpit.ru ([81.13.33.150]:22441 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751162AbYJaQKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 12:10:09 -0400
Message-ID: <490B2DDF.5050809@msgid.tls.msk.ru>
Date: Fri, 31 Oct 2008 19:10:07 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
User-Agent: Icedove 1.5.0.12 (X11/20070607)
MIME-Version: 1.0
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
CC: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: data corruption: revalidating a (removable) hdd/flash on re-insert
References: <490B2659.9010304@msgid.tls.msk.ru> <20081031155901.GE5682@csclub.uwaterloo.ca>
In-Reply-To: <20081031155901.GE5682@csclub.uwaterloo.ca>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lennart Sorensen wrote:
> On Fri, Oct 31, 2008 at 06:38:01PM +0300, Michael Tokarev wrote:
>> To make a long story short: is there a way to force kernel
>> to re-validate a replaced usb-connected hard drive (or a
>> flash) *automatically*?
>>
>> Because right now, the kernel does not see that the drive
>> has been replaced, and uses *some* old cached values, which
>> results in random data corruption here and there, and other
>> similar odd things.
>>
>> For example, I've an USB flash reader (Carry Computer Eng.,
>> Co., Ltd 6-in-1 Card Reader, but that's not really relevant).
>> Among other things it has a compact flash slot.  And I've
>> 2 differently-size CF cards.
[]
>> So at some point the kernel stopped noticing the drive
>> change in this configuration some time ago.  I can't say
>> when exactly, since I didn't use the card reader for over
>> a year, and certainly didn't try it with more than one
>> card in a row for even longer time.   It worked in the
>> past, that's for sure.  And it definitely does not work
>> (resulting in the above mess) with 2.6.25, 2.6.26 and 2.6.27.
> 
> I have had this happen with a few usb flash card readers.  My solution
> was to unplug the usb cable then swap the card and connect the usb cable
> again.  In the end I went and bought a different card reader, which does
> work correctly.

Well, this one is internal reader, which plugs into a 3" slot.
AND it also has the regular floppy drive in it, too. It's a combo,
a floppy drive AND a USB flash reader.  As such, I can't easily
re-plug it (which definitely helps, too, but for that to work I
have to open the case), and I can't replace it either, because
this device is almost unique: I still need a floppy and there's
no other such combo drives, at least I wasn't able to find it.
It's a great device if you think of it: it connects two epochs
together...

> I highly suspect it is a mistake in the hardware causing the problem
> given the vast majority of readers do work correctly already.

So at least a) I'm not alone, and b) there's SOMETHING that works.
Excellent!

> So far I have had no problems with a silverstone, mitsumi, dell (in
> monitor), sandisk.  I have had a problem with a no name cheap "15 in
> 1" reader which I stopped using because plugging and unplugging got
> annoying.
> 
> So my recommendation is get a non broken device.

The thing is that with some older kernel(s) it defeinitely worked.
So I'd say it's the kernel which broke/regressed, not the hardware.
Suggesting to fix the hardware because new kernel does not work with
it anymore is.. strange at least.

And yes it was definitely a el cheapo no-name thing.  But a..
great (epochs!) and hence unique thing, see above.. ;)

I'll try to find out when it broke.  My first suspect was the patch
introduced not-so-recently (in 2.6.2x series) to support media
change notifications done by some hardware (wait for notify instead
of constantly polling).

Thanks!

/mjt
