Return-Path: <linux-kernel-owner+w=401wt.eu-S1752966AbZGKCDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966AbZGKCDv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 22:03:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751125AbZGKCDk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 22:03:40 -0400
Received: from mail2.shareable.org ([80.68.89.115]:57606 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbZGKCDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 22:03:39 -0400
Date: Sat, 11 Jul 2009 03:03:24 +0100
From: Jamie Lokier <jamie@shareable.org>
To: tridge@samba.org
Cc: Martin Steigerwald <Martin@lichtvoll.de>,
       Jan Engelhardt <jengelh@medozas.de>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Theodore Tso <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Rusty Russell <rusty@rustcorp.com.au>, Pavel Machek <pavel@ucw.cz>,
       john.lanza@linux.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, corbet@lwn.net,
       jcm@jonmasters.org, James.Bottomley@hansenpartnership.com
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regressions
Message-ID: <20090711020324.GA6545@shareable.org>
References: <19013.8005.541836.436991@samba.org> <200907072356.51553.Martin@lichtvoll.de> <19028.3736.892828.352905@samba.org> <200907081339.59815.Martin@lichtvoll.de> <19029.28240.995268.850038@samba.org> <20090710212853.GB30322@shareable.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090710212853.GB30322@shareable.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jamie Lokier wrote:
> I don't know what code base is used for Windows CE.  CE is still used,
> on phones, PDAs and media players among other things.  Has there been
> any testing against CE - current versions and old versions?

Found something about Windows CE:

    On WinCE, long filenames do not need to be generated if the filename
    is 8.3 compatible: it must contain all uppercase characters, no
    unicode characters, and be no longer than 8 characters long with no
    more than a 3 character extension. For example, FILENAME.TXT would not
    generate a long filename and uses only one directory
    entry. FileName.Txt, filename.txt, and FILENAME0.TXT would all
    genenerate a long filename.

    From: http://blogs.msdn.com/medmedia/archive/2007/01/04/fat-filesystem-performance-issues.aspx

In other words, Windows CE uses the same algorithm as Windows 9x when
deciding whether to _create_ a long filename, corresponding to
shortname=mixed.

That post is from 2007, so likely to be what goes on recent CE devices.

I don't know if that means it _reads_ FAT the same way as Windows 9x,
or if they decided to do the same as shortname=mixed for maximum
compatibility with everything.  Has anyone ever checked if
shortname=winnt is what NT-derivatives like XP and Vista still do?

Obviously we care about how CE reads FAT, not when it creates long
names.  This is just a little clue that it might be the same as Windows 9x.

-- Jamie
