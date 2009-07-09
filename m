Return-Path: <linux-kernel-owner+w=401wt.eu-S1759192AbZGIJm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759192AbZGIJm2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 05:42:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756453AbZGIJmS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 05:42:18 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34727 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756332AbZGIJmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 05:42:16 -0400
Date: Thu, 9 Jul 2009 10:42:28 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: tridge@samba.org
Cc: Martin Steigerwald <Martin@lichtvoll.de>,
       Jan Engelhardt <jengelh@medozas.de>, Theodore Tso <tytso@mit.edu>,
       Rusty Russell <rusty@rustcorp.com.au>, Pavel Machek <pavel@ucw.cz>,
       john.lanza@linux.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, corbet@lwn.net,
       jcm@jonmasters.org, James.Bottomley@hansenpartnership.com
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regressions
Message-ID: <20090709104228.7821e2f0@lxorguk.ukuu.org.uk>
In-Reply-To: <19029.17896.769106.375379@samba.org>
References: <19013.8005.541836.436991@samba.org>
	<alpine.LSU.2.00.0907062221520.27775@fbirervta.pbzchgretzou.qr>
	<19026.38137.63807.427511@samba.org>
	<200907072356.51553.Martin@lichtvoll.de>
	<19028.3736.892828.352905@samba.org>
	<20090708110451.1092afa7@lxorguk.ukuu.org.uk>
	<19028.31088.400461.939917@samba.org>
	<20090708130256.40957c3f@lxorguk.ukuu.org.uk>
	<19028.39145.180869.603673@samba.org>
	<20090708142510.5068b4c3@lxorguk.ukuu.org.uk>
	<19029.17896.769106.375379@samba.org>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> no, when the vendors are given a clearly non-infringing way of
> implementation then I think they will go for it. The proof is that

Even if they go for the non-infringing tweak they will still end up with
patches to rip out the potentially infringing code paths.

> 'works' for all devices, except that any Linux users copying a file
> with a long name to the device get an error. That is not my idea of
> 'works'.

It fails in a controlled manner and always produces valid output as
defined by the existing devices. At the end of the day it guarantees that
I can get my file back off the USB device on any system.

What is the fundamental purpose of a USB stick - to store and *transfer*
files. Long names are a (useful) luxury. Absolute certainty of
compatibility and reliability matter more for a file system.

> functionality that it would be a very painful solution for Linux
> vendors.

How about the users - is crashing XP, confusing Win98 and other suprises
on MP3 players not painful ?

> The dualnames patch achieves a much higher degree of functionality for
> a much wider number of users. It isn't perfect, but I think it is much
> better.

If it had controlled failure cases I would agree - but it doesn't. We are
still seeing bizarre failure cases and incompatibilities with the tiny
number of people currently testing it. Who knows what it does on some
random chinese market only mp3 player ?

> again, this is validity, not non-infringment. I am not advocating a
> "you're patent is invalid" argument, as that is not certain enough. I
> am advocating a "we don't implement that" approach.

Ok - that is important and I accept that.

> The great thing about this is that it works even better with patent
> trolls. Their sole purpose in life is to derive revenue from their
> patents. If we become known as the guys who threaten that income then
> the trolls will give us a wide berth. 

Agreed

>  > - if you limit functionality silently or in an unreliable way the blame
>  >   falls on the software supplier not the patent holder or the governments
>  >   who made the bad laws (or the judges of course as software patents
>  >   in many states aren't really of political origin but judicial
>  >   over-reach)
> 
> And if we make it so that copying files to a FAT filesystem return
> -1/ENAMETOOLONG then what will that do to users? You really think
> users will have sympathy with the situation then?

You'll get a discussion "Why can't I" "Because" "Gee that sucks how do I"

Users may not be great fans of it but they do understand whose fault it
is.

"You crashed my XP server" isn't a good basis for enlightenment nor is
"Where has my thesis gone"

> and how is your preffered 'return -1/ENAMETOOLONG' for valid long
> names 'vfat'? A new filesystem name could be used, but I think that is

I didn't say it was. It isn't vfat either.

> largely cosmetic. How many Linux users, other than developers,
> actually type:
> 
>   mount -t vfat .....
> 
> I think nearly all users just rely on the auto-detection of the fs
> type. 

Fine then giving it an accurate name won't trouble them too much.

> It is the 'some naming limits' bit which is the problem. As was
> pointed out when I posted the patch that did this in May, those limits
> impact a whole lot of normal use cases.

As clearly does this patch. But the May patch at least impacted them in a
controlled defined and predictable manner. We don't know the failure
cases and we can't predict them for this newer approach.

