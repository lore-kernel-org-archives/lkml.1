Return-Path: <linux-kernel-owner+w=401wt.eu-S932811AbXA1UN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932811AbXA1UN0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 15:13:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932815AbXA1UN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 15:13:26 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:59817 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932811AbXA1UNZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 15:13:25 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: nigel@nigel.suspend2.net
Subject: Re: [Q] Prefered suspend to ram or disk method ?
Date: Sun, 28 Jan 2007 21:14:02 +0100
User-Agent: KMail/1.9.1
Cc: Xavier Maillard <zedek@gnu.org>, linux-kernel@vger.kernel.org
References: <23972.1169975356@localhost> <200701282047.39997.rjw@sisk.pl> <1170014258.25406.10.camel@nigel.suspend2.net>
In-Reply-To: <1170014258.25406.10.camel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701282114.02539.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sunday, 28 January 2007 20:57, Nigel Cunningham wrote:
> Hi.
> 
> On Sun, 2007-01-28 at 20:47 +0100, Rafael J. Wysocki wrote:
> > > How does suspend compare to ususpend/suspend2 ?
> > 
> > swsusp and ususpend use the same low-level kernel code, so if one of them
> > works for you, the other should as well.  The difference is mainly that with
> > swsusp the kernel saves the image into a swap, while with usupend the image
> > is saved (and loaded on resume) by a userland process.  Additionally, ususpend
> > can compress and/or encrypt the image, supports suspend-to-disk-and-RAM,
> > splash-based progress meters and some such.  Gerenally, it adds the features
> > that, in the opinion of its authors, are better implemented in the userland.
> > Plus IMHO ususpend's resume is a bit more convenient for calling from within
> > initrd images.
> > 
> > suspend2 uses some different low-level code, but as far as the stopping of
> > tasks and handling devices are concerned, it should be equivalent to swsusp
> > and ususpend.  It generally allows you to create bigger suspend images (the
> > images created by swsusp and ususpend are at most as large as 50% of RAM),
> > but it makes some strong assumptions regarding memory management which are
> > not proven to be always satisfied, although there's no evidence showing
> > otherwise.  It also implements approximately the same set of additional
> > features as ususpend, but in the kernel.
> 
> That's not true anymore. Suspend2 uses exactly the same lowlevel code.
> It just modifies the C that runs around the lowlevel code slightly so
> that suspend2 instead of swsusp code is executed before and afterwards.

Okay, I stand corrected.

> Regarding the assumptions (about LRU pages not changing), I have that in
> progress. The content of the LRU list definitely doesn't change, but by
> calculating MD5 checksums of the changes before and after saving those
> pages, we've seen some (up to 20) pages change on a few computers. I
> need (obviously) to put time into finding the cause of those changes.

Do I understand correctly that you:
- save the LRU,
- copy data into them,
- compute MD5 checksums of their contents,
- save the image,
- suspend,
- resume,
- load the image,
- compute MD5 checksums of the loaded data,
and the sums computed before saving the image and after loading it may differ
for up to 20 pages?

Rafael


-- 
If you don't have the time to read,
you don't have the time or the tools to write.
		- Stephen King
