Return-Path: <linux-kernel-owner+w=401wt.eu-S1756019AbZGHNZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019AbZGHNZf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 09:25:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754896AbZGHNZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 09:25:29 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43412 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754691AbZGHNZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 09:25:28 -0400
Date: Wed, 8 Jul 2009 14:25:10 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: tridge@samba.org
Cc: Martin Steigerwald <Martin@lichtvoll.de>,
       Jan Engelhardt <jengelh@medozas.de>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Theodore Tso <tytso@mit.edu>, Rusty Russell <rusty@rustcorp.com.au>,
       Pavel Machek <pavel@ucw.cz>, john.lanza@linux.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, corbet@lwn.net,
       jcm@jonmasters.org, James.Bottomley@hansenpartnership.com
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regressions
Message-ID: <20090708142510.5068b4c3@lxorguk.ukuu.org.uk>
In-Reply-To: <19028.39145.180869.603673@samba.org>
References: <19013.8005.541836.436991@samba.org>
	<alpine.LSU.2.00.0907062221520.27775@fbirervta.pbzchgretzou.qr>
	<19026.38137.63807.427511@samba.org>
	<200907072356.51553.Martin@lichtvoll.de>
	<19028.3736.892828.352905@samba.org>
	<20090708110451.1092afa7@lxorguk.ukuu.org.uk>
	<19028.31088.400461.939917@samba.org>
	<20090708130256.40957c3f@lxorguk.ukuu.org.uk>
	<19028.39145.180869.603673@samba.org>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You keep talking about what is done about patents in other parts of
> the free software world as though it is a good model to follow. It
> isn't - it is a complete disaster.

Its been a very successful disaster for many years then.

> The only weapon we have to fight patents right now is our collective
> ability to find smart solutions to problems. The "every vendor for
> themselves" approach that you seem to be so keen on makes that
> collective approach pretty much impossible.

The vendors can only talk to one another with lawyers present, so this is
an irrelevant argument to the public kernel. We've proved that already in
the fact you can't even discuss implementation details with the list.

> You talk about media players and other software being crippled in the
> US and other countries as though this is a good thing. You talk about
> vendors ripping out large slabs of functionality as though you want it
> to happen.

It is what the vendors will do regardless.

> to make it work despite the patents. It has been so disheartening over
> the years to see people say things like "oh, the XYZ codec is
> patented, we can't use that". Patents don't work like that. They
> patent very specific steps, and if you learn to read them properly
> then you can find ways to get the functionality you need without just
> applying an axe to a whole slab of useful features.

This misses the fact that if the vendor thinks sueing you is a business
opprtunity they will do so anyway. Why should they care if the patent is
valid - its not relevant to most of the legal process so it still has the
desired slowdown and expend money approach

> Let's stop whining about the unfair patent system and start fighting
> back!

How is shipping something labelled as vfat that doesn't work properly
"fighting back". It's "trying to make the users think our code is crap".

If you wanted reliable working approach surely tridgefat should read long
names but only create new short names ? That keeps you in spec, as I
understand it avoids the alleged possible patent infringement and works
for all devices ?

> oh yes, I've seen it, but unlike you I didn't jump with joy at the
> sight of Linux users losing features because of the patent system. I

I find the assumption that losing features to patents makes me "jump for
joy" rather offensive.

> fumed at the fact that the vendors and projects involved did not have
> the knowledge and skills to apply a more subtle, and much more
> effective, approach to beating patents. 

Many of the things removed are not patent related. Patents are only one
issue. Stuff gets removed for many reasons including a few cases of "they
sue everyone who does this regardless of validity so we don't XYZ"

> Then join me in trying to fight the patent system for real.

I've spent over ten years doing that. Those ten years have taught me

- if you give in to a patent thug they will simply try to bully you
  further
- if you limit functionality silently or in an unreliable way the blame
  falls on the software supplier not the patent holder or the governments
  who made the bad laws (or the judges of course as software patents
  in many states aren't really of political origin but judicial
  over-reach)
- if you delete stuff from base packages you hurt people in the rest of
  the world unneccessarily
- patents are a tiny part of the process anyone shipping any software
  commercially on a scale worth lawsuits goes through reviewing.

That is why I want to avoid any process which cripples the base kernel,
and anything which gives users broken software without them knowing it is
feature limited and why.

The patches you've proposed break stuff. It's mildly funny that MS is
trying to force us into a workaround that randomly crashes MS boxes but
that doesn't make it a good idea to merge such a change. Nor is it a good
idea to call something vfat which is not vfat.

This isn't about pain either - it is about users knowing what they are
getting.

So instead of regressions can we be a little bit less clever and a little
bit more reliable and do "FAT which reads and honours existing longnames"
and give it a name other than vfat.

That would give us absolute on media compatibility, accessibility from
all devices (which is the important bit) but some naming limits for new
file creation.

