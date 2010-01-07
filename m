Return-Path: <linux-kernel-owner+w=401wt.eu-S1756331Ab0AGAly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756331Ab0AGAly (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 19:41:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756086Ab0AGAlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 19:41:53 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:45375 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755888Ab0AGAlw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 19:41:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=wgtvwVLY/ROOAhiDzVi+d59Zvehtf8/9NlAZz4Loo3QleMaHkoXpkjlb4QXjjAt3VQ
         mL5yRZNRM9MjWjaLCAdB3R6iz7QX7wdcxvggdH4wjNUOFvCWvtyn2HBAsjpNxV5tvFmR
         bfzxi8ZI7UHP6J4hGAW243wVpUnW7fAw1RyVI=
MIME-Version: 1.0
Date: Wed, 6 Jan 2010 19:41:50 -0500
Message-ID: <806dafc21001061641g4d4538c6n9c42d58dad7f394@mail.gmail.com>
Subject: [PATCH] eMagic emi26 and emi62m new firmware versions
From: Monty Montgomery <xiphmont@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>,
       linux-audio-user@lists.linuxaudio.org
Cc: Clemens Ladisch <clemens@ladisch.de>,
       Linux kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Der Mickster <retroeffective@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In addition to the patches from earlier that restore the emi62m
firmware loader to function (and reinstates the correct bitstream.HEX
file for the device), I've extracted updated firmware from the last
(to my knowledge) free (beer) software update provided by eMagic.  The
update was labelled firmware 2.2 and the updater was for MacOSX 10.2.3
PPC.

I noticed that the previous round of firmware loader fixes hasn't made
it into any of the test kernels yet (or has it and I missed it?) So
I've included the loader fixes to date and the firmware update into a
single patch that works on stable kernel releases 2.6.27 up to at
least 2.6.32.2.  That said---

The licensing boilerplate included with this 'free software update'
from eMagic may or may not allow eventual kernel inclusion; I've
always been a little surprised the original 1.0 firmware as used in
the current in-kernel driver was acceptably licensed.  Even if not,
this update is undeniably useful to anyone who has one of these
devices and so I've made it into one big patch that can perhaps be
unofficially 'helped along' to those folks wo could use it.

The firmware update information includes various vague statements of
'improves latency and performance', but the biggest thing I notice is
that it has cured several minor but annoying bugs in the 6|2m, like
the fact that sampling always starts with neither analog nor digital
input actually internally selected/working and you have to flip the
physical switch on the front of the unit to wake it up every time you
begin recording...

The all-in-one patch is large and so stored here:

http://web.mit.edu/xiphmont/Public/emi/emi-firmware-update.patch

...and also wrote a longer blog post featuring both patches here:

http://xiphmont.livejournal.com/46858.html

If you prefer just the new .HEX files, let me know.

Cheers,
Monty





On Tue, Nov 24, 2009 at 5:14 AM, Monty Montgomery <xiphmont@gmail.com> wrote:
>> Where did the new firmware come from?
>
> It is the firmware as originally appeared in in Tapio's original out
> of tree driver in 2002-ish, was committed to the tree in 2.6.12, and
> remained unchanged until it was removed in the firmware cleanup in
> 2.6.27.  The firmware header at that time held the bitstream, loader
> and SPIDF/MIDI firmware images all in one header file.  In 2.6.27,
> they were all split back out into their original ihex sources but this
> operation seems to have been botched.  I wrote a quick script to
> redump the data from the original header back into ihex format as I
> couldn't locate the original ihex files Tapio apparently originally
> worked from (the comments and partial original ihex inclusion in
> Tapio's header are admittedly confusing and apparently led the
> cleaner-upper astray).
>
> Monty
>
