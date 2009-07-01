Return-Path: <linux-kernel-owner+w=401wt.eu-S1755792AbZGAOFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792AbZGAOFf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 10:05:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753595AbZGAOF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 10:05:26 -0400
Received: from thunk.org ([69.25.196.29]:42449 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752936AbZGAOFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 10:05:25 -0400
Date: Wed, 1 Jul 2009 10:05:03 -0400
From: Theodore Tso <tytso@mit.edu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Pavel Machek <pavel@ucw.cz>,
       tridge@samba.org, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       john.lanza@linux.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] Added CONFIG_VFAT_FS_DUALNAMES option
Message-ID: <20090701140503.GA21185@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Rusty Russell <rusty@rustcorp.com.au>, Pavel Machek <pavel@ucw.cz>,
	tridge@samba.org, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	john.lanza@linux.com, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
	Paul McKenney <paulmck@linux.vnet.ibm.com>
References: <19013.8005.541836.436991@samba.org> <20090630063102.GB1351@ucw.cz> <200907012019.53932.rusty@rustcorp.com.au> <20090701122558.3a7c80d3@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090701122558.3a7c80d3@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 01, 2009 at 12:25:58PM +0100, Alan Cox wrote:
> 
> Also please stop calling it VFAT. With the changes made it isn't VFAT and
> it's misleading to an end user to advertise it as vfat and users
> shouldn't accidentally be able to specify -o vfat and get non-vfat. Thats
> asking for incompatibility, data loss and unpleasant unwarned of suprises.

There really was no such thing as "vfat" anyway.  VFAT in the Windows
world names a specific implementation (the "V" stands for virtual)
back in the days when Windows 3.1 was primarily a 16-bit OS, and there
were two instances of the "fat" filesystem code; one for the 16 bit
implementation, and one for 32-bit applications.  As it happened the
32-bit implementation under Windows 3.1 happened to contain support
for the Long File Names extension, and due to this confusion of
implementation vs. specification, in Linux is misnamed something as
"vfat" when most of the rest of the world simply just calls it "FAT".

Arguably what we should have done is kept it as a single filesystem,
with a mount options "lfn" and "nolfn", but that's water under the
bridge now.

> (most *FAT using products don't use Microsofts
> implementation). Testing it versus Windows and saying it works is
> not really adequate. Thats what ACPI and BIOS people do that *we*
> moan about all the time.

This *is* a legitimate concern.  I'll note that many of the modern-day
products actually use Linux (i.e., the Sony eReader, the Kindle,
etc. --- and so as much as you might kvetch about the rest of the
"Free World" not having the same broken patent system as the US, the
economic realities of these products losing access to the US market
would be quite devastating to most of these products' manufacturers
even if some of them are developed and manufactured outside of the
US), and so doing compatibility testing with Linux is relatively easy.

The other big user I can think of are digital cameras, but (a)
normally most users read from them and then delete the pictures, and
rarely write to media meant for a digital camera, and (b) the DCIM
standard for digital cameras explicitly only supports 8.3 filenames
and so digital camera manufacturers explicitly don't need to deal with
Long File Names at all.  (Hmm.... I wonder why....)  

This suggests that some userspace mechanism for detecting media cards
used for cameras and explicitly mounting them with FAT might be useful
--- since the camera isn't going to be able to recognize LFN's anyway.
It also suggests that some testing to make sure there aren't bugs in
various non-Linux FAT using devices would probably be useful, and that
a config option might be a good way to enable people to do such
testing and fall back if it turns out to be problems with such
devices.

Ultimately, though, requiring that every single possible device be
tested is probably not reasonable, so the best way to do this testing
is the way do most of our testing; we do basic due diligence, but then
we merge it into mainline and let our huge user community try it out.
If there are regressions we can work through those issues if and when
they arise.

						- Ted

