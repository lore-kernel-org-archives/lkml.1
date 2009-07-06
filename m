Return-Path: <linux-kernel-owner+w=401wt.eu-S1753847AbZGFTeK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847AbZGFTeK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 15:34:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753184AbZGFTd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 15:33:58 -0400
Received: from mail2.shareable.org ([80.68.89.115]:41140 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753062AbZGFTd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 15:33:56 -0400
Date: Mon, 6 Jul 2009 20:33:31 +0100
From: Jamie Lokier <jamie@shareable.org>
To: David Newall <davidn@davidnewall.com>
Cc: tridge@samba.org, Jan Engelhardt <jengelh@medozas.de>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Theodore Tso <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Rusty Russell <rusty@rustcorp.com.au>, Pavel Machek <pavel@ucw.cz>,
       john.lanza@linux.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, corbet@lwn.net,
       jcm@jonmasters.org
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regressions
Message-ID: <20090706193331.GA13638@shareable.org>
References: <19021.23231.213863.726785@samba.org> <alpine.LSU.2.00.0907030347210.24650@fbirervta.pbzchgretzou.qr> <19021.26102.80885.330380@samba.org> <alpine.LSU.2.00.0907030403330.26905@fbirervta.pbzchgretzou.qr> <19021.31291.642416.956966@samba.org> <alpine.LSU.2.00.0907031121250.16093@fbirervta.pbzchgretzou.qr> <19021.63615.450348.192109@samba.org> <alpine.LSU.2.00.0907061337550.9199@fbirervta.pbzchgretzou.qr> <19025.63119.656216.431469@samba.org> <4A5223B6.1010102@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A5223B6.1010102@davidnewall.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Newall wrote:
> tridge@samba.org wrote:
> > Hi Jan,
> >
> >  >  * "cp dscf4160.jpg dscF3011.jpg" does not work - i.e. cam ignores the
> >  >    file without error.
> >  >    Reason for that is that dscF3011 has an illegal 8.3 name
> >
> > yep, that's expected. I suggested a possible way of handling this to
> > Hirofumi-san (ie. change the case of the name), but he prefers to keep
> > things simple for now.
> >   
> 
> Expected or not, it's a serious bug. If it doesn't canonify the
> filename, it should return an error. Lying by returning success is
> horridly wrong. And I might just suggest that as people are now
> accustomed to typing mixed-case filenames, it's a bug that's likely to
> occur more frequently than it might at first seem.

It's no different from writing a long name, though, is it?

"cp dscf4160.jpg dscf3011.jpeg" would also be ignored by the
camera, because there is no corresponding 8.3 file name.

It's a bit clearer when mounted with shortname=winnt or
shortname=mixed, because then I'd expect files created by the camera
to show as upper case in Linux, and it would be obvious that you might
have to create new files for the camera that look the same as the camera's.

The current Linux default shows 8.3 short-name files in lower case
(i.e. pure FAT shows as lower case), but files created in Linux with
8.3 lower case names create a long name.  Which is bound to cause some
confusion.

I agree with tridge, shortname=winnt makes sense when dualnames are off.

Unfortunately it doesn't preserve case when creating in Linux and
reading in Windows 95/98/ME and devices with a similar implementation.

For that reason, shortname=mixed is better when dualnames are on.

-- Jamie
