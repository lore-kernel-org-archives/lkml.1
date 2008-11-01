Return-Path: <linux-kernel-owner+w=401wt.eu-S1753354AbYKAL6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354AbYKAL6a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 07:58:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751473AbYKAL6E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 07:58:04 -0400
Received: from vitalin.sorra.shikadi.net ([64.71.152.201]:3197 "EHLO
	vitalin.sorra.shikadi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430AbYKAL6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 07:58:02 -0400
Message-ID: <490C40C2.8040506@shikadi.net>
Date: Sat, 01 Nov 2008 21:42:58 +1000
From: Adam Nielsen <a.nielsen@shikadi.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-GB; rv:1.8.1.16) Gecko/20080727 Thunderbird/2.0.0.16 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Kasper Sandberg <lkml@metanurb.dk>
CC: Robert Hancock <hancockr@shaw.ca>,
       LKML Mailinglist <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.27.2 USB reset/IO Error problem when high load on ICH9 USB
References: <fa.PPRUdlhLAQMsAcsErf8qHTGwTPQ@ifi.uio.no>	 <490A5977.8090705@shaw.ca> <1225537637.17253.53.camel@localhost>
In-Reply-To: <1225537637.17253.53.camel@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I am absolutely positive it was plugged in properly, and i am also sure
> the usb port isnt broken, i have tested all of them, though, this is
> first time i have had so many in use concurrently, maybe its a power
> issue? (which would be weird though, as flash devices shouldnt be using
> so much power)

FWIW I've found that on my ICH9 based PC, whenever I copy a fairly large 
(>50MB) amount of data onto a USB flash drive, my USB keyboard plays up 
for up to half an hour after the transfer, generating random keypresses 
all over the place.

The first time it happened I thought I had some sort of spyware/virus on 
my PC, but it reliably happens whenever I copy lots of data onto the 
flash.  After about half an hour or so it settles down and everything 
goes back to normal.

I thought it was a problem with the keyboard driver, as it doesn't 
affect the whole keyboard (the base keyboard is handled by the Linux USB 
keyboard driver and that works fine, but the userspace program 
"g15daemon" handles the extra non-standard keys, and these are the ones 
that randomly get pressed after a large data transfer.)

Last time this happened I checked the data coming in over evdev, and the 
extra keypresses were generated entirely in software - no evdev data was 
coming in unless I was physically pressing the key.  But still Linux was 
receiving spurious keypress events.  (Which is why I suspected the 
userspace program.)

Perhaps it's not g15daemon (nobody else has reported this behaviour), 
but something USB related instead?

This is with 2.6.23.9, though.

Cheers,
Adam.

