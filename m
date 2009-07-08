Return-Path: <linux-kernel-owner+w=401wt.eu-S1758223AbZGHDMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758223AbZGHDMt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 23:12:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757506AbZGHDMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 23:12:40 -0400
Received: from mail.samba.org ([66.70.73.150]:47636 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755580AbZGHDMj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 23:12:39 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19028.3736.892828.352905@samba.org>
Date: Wed, 8 Jul 2009 13:12:24 +1000
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: Jan Engelhardt <jengelh@medozas.de>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Theodore Tso <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Rusty Russell <rusty@rustcorp.com.au>, Pavel Machek <pavel@ucw.cz>,
       john.lanza@linux.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, corbet@lwn.net,
       jcm@jonmasters.org, James.Bottomley@hansenpartnership.com
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regressions
In-Reply-To: <200907072356.51553.Martin@lichtvoll.de>
References: <19013.8005.541836.436991@samba.org>
	<alpine.LSU.2.00.0907062221520.27775@fbirervta.pbzchgretzou.qr>
	<19026.38137.63807.427511@samba.org>
	<200907072356.51553.Martin@lichtvoll.de>
X-Mailer: VM 8.0.12 under 22.2.1 (x86_64-pc-linux-gnu)
Reply-To: tridge@samba.org
From: tridge@samba.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Martin,

 > Have low level filesystem check, repair and cloning tools been checked 
 > against the patch at all?

I have tested chkdsk.exe obvious, and I have reported the bug in
chkdsk that this testing has found to Microsoft.

I haven't tested tools like ghost or 3rd party tools. I don't actually
have any of those tools myself, although I guess I could go out and
buy them. Does anyone on this list have those tools and can let me
know if they show any problems?

 > I think the patch actively *corrupts* perfectly fine shortname FAT 
 > filesystems and at least for certain use scenarios even those with long 
 > name support.

The patch only changes the values stored for new files created by
Linux, so I think it is going a bit far to say it "actively corrupts"
filesystems. 

I am looking into the Win9X issued raised by Jan. As I mentioned in my
mail to him, it seems to work better with some different values in the
11 bytes. I'll keep looking at that, although I don't think Win9X
support is a high priority for anyone any more. After installing Win98
in a virtual machine I connected it to the windows update service to
see if there had been updates to the old install images I had, and I
found it couldn't even connect to windows update, it just throws a
page full of html errors:

  http://samba.org/tridge/Win98-update.png

When the vendor of an operating system doesn't even bother to display
a clean "sorry, you don't get updates any more" page for their OS then
I think it is safe to say that the operating system is dead and
buried.

That leaves just the 'IOneIt' MP3 player that Jan tested. I have
ordered a bunch of different cheap MP3 players from Hong Kong on eBay
to see if I can reproduce that.

 > Thus I would certainly not enable it unless forced too - already
 > just for *technical* reasons. I probably would even default to
 > compile my own kernel when I find that the distribution of my
 > choice (Debian) would enable it.

I can't speak for Debian, but I would be not surprised if they do
enable this patch. Your opinion certainly lends weight to the idea
that it should be configurable, but I don't think it leads to the
conclusion that the patch should not be in the upstream kernel at all.

 > Politically spoken I think the patch tries to workaround a problem that 
 > better is fixed properly and causes a precedence for other politically, 
 > juristically motivated patches.

But what is 'fixed properly'? Exactly what should be done beyond the
activism that is already trying to change the patent systems around
the world?

I am a conscientious objector when it comes to patents, so I have
never filed any patents myself. I have also fought patents in other
ways, such as the partial win that I helped with in relation to
patents in the EU anti-trust case, and I have helped quite a few
people with patent workarounds.

It would be great if the Linux community had enough clout to force
through a change in patent law, but as yet we don't. When there was
the possibility of all of the politicians blackberries in the US
getting switched off due to a patent dispute I thought that perhaps we
finally had something that would get the attention of the people who
make these silly laws. That didn't end up resulting in any significant
change, so I don't think it is reasonable to think that the threat of
Linux desktops not being able to share USB keys with Windows will
cause politicians around the world to suddenly take an interest.

 > If the Linux kernel would be changed to avoid any software patent
 > issues I am not sure whether it would even be able to boot
 > anymore.

That argument can be used with pretty much any software (both
proprietary and free), not just the Linux kernel.

The answer is that patents that are being actively litigated, such as
the VFAT patents, fall into an entirely different class than the rest
of the patents out there. 

In the case of the GIF patents the correct answer was a concerted
effort to switch to a new format. That was a fantastic campaign and
largely successful.

We don't, as yet, have any equivalent campaign to get behind for these
VFAT patents. The calls for changing to a different filesystem format
are great, but they fall down in an even worse way than what I have
proposed on exactly the same issues. This hypothetical new format
won't work with cheap MP3 players, won't work with Win9X, and almost
certainly won't work with existing Windows boxes (yes, I know about
UDF, but if you actually try it you'll see it isn't the panacea some
have claimed). So in what way is it a solution, even if the new format
existed?

If you can propose a truly workable alternative then I would be
delighted to never have to think about FAT filesystems again in my
life. 

Meanwhile, I have proposed what I think is the best alternative we
have at the moment. It is certainly unpalatable to have to deal with
patents at all, but I think it is better that we work around them than
to see the problems that TomTom faced spread across the Linux world.

Cheers, Tridge
