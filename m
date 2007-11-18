Return-Path: <linux-kernel-owner+w=401wt.eu-S1754959AbXKRWef@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959AbXKRWef (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 17:34:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752692AbXKRWe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 17:34:27 -0500
Received: from b73.evanzo-server.de ([87.238.198.73]:47299 "EHLO
	s8073.evanzo-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671AbXKRWe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 17:34:26 -0500
From: Tobias <kaminsky@finswimmer.de>
To: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [REQUEST] Option for skipping unreadable blocks on Video DVD
Date: Sun, 18 Nov 2007 23:34:52 +0100
User-Agent: KMail/1.9.7
References: <fa.DNZjDdh1eNcFR2zDRKzQ6G2bIVU@ifi.uio.no> <473FC662.7020901@shaw.ca>
In-Reply-To: <473FC662.7020901@shaw.ca>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200711182334.52703.kaminsky@finswimmer.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sunday 18 November 2007 schrieben Sie:
> Tobias wrote:
> > If you are accessing a scratched Video DVD and the device cannot read it,
> > the process ends.
> > What about a more tolerant way to handle unreadable blocks.
> > Especially on Video DVDs single blocks are not that important than on
> > data dvds.
>
> If the DVD player process ends from this, I'd say that's the fault of
> the player software not handling errors properly.
>
> I think that if they are using the normal block layer accesses on the
> DVD device, there may be some retries that occur which are likely
> undesirable in this case since they will just stall playback. If they
> are using SG_IO to feed raw requests into the drive (which I imagine
> they need to do for CSS authentication, etc. anyway), then all error
> handling is passed up to the user application.

Normal apps like cp are ending because of Input/Output error. 
I did some researches and 
dd if=/dev/hdc of=image.iso conv=noerror,sync bs=1M 
does everything I want for whole Video Dvds. It skips unreadable blocks.
But I get recorded tv shows from friends and there is the same as with 
scratched dvds. Now the problem is that there are several .avi files on it. 
So I cannot use dd. 

> > So is there a way that the kernel tells the device to skip these bad
> > blocks?
>
> We don't know they're bad until we try and read them. 
> How long the drive will stall trying to read that sector before giving up 
>and returning an error is up to the drive. 

It would be enough that the drive does not report it as a error. If it would 
be a warning it may be skipped.

> I'm not sure if the MMC command set allows any 
> way to tell the drive to give up more quickly or not..

How can I figure this out? The best way would be a special command that all 
user apps can use which tells the drive to skip all of these bad blocks. With 
this you could turn it on if you want to watch movies where single bytes are 
not that important or turn it off if you want to have a identical copy of the 
dvd.

By the way, I am surprised that I am the only one who has problems with this.

Tobi
