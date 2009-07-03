Return-Path: <linux-kernel-owner+w=401wt.eu-S1756316AbZGCAZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756316AbZGCAZb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 20:25:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755760AbZGCAZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 20:25:21 -0400
Received: from mail.samba.org ([66.70.73.150]:47665 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754004AbZGCAZU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 20:25:20 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19021.20449.732095.210252@samba.org>
Date: Fri, 3 Jul 2009 10:25:05 +1000
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Theodore Tso <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Rusty Russell <rusty@rustcorp.com.au>, Pavel Machek <pavel@ucw.cz>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, john.lanza@linux.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, corbet@lwn.net,
       jcm@jonmasters.org
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regression
In-Reply-To: <alpine.LSU.2.00.0907030149020.17183@fbirervta.pbzchgretzou.qr>
References: <19013.8005.541836.436991@samba.org>
	<20090630063102.GB1351@ucw.cz>
	<200907012019.53932.rusty@rustcorp.com.au>
	<20090701122558.3a7c80d3@lxorguk.ukuu.org.uk>
	<20090701140503.GA21185@mit.edu>
	<alpine.LSU.2.00.0907030056210.17183@fbirervta.pbzchgretzou.qr>
	<19021.17576.808138.476600@samba.org>
	<alpine.LSU.2.00.0907030149020.17183@fbirervta.pbzchgretzou.qr>
X-Mailer: VM 8.0.12 under 22.2.1 (x86_64-pc-linux-gnu)
Reply-To: tridge@samba.org
From: tridge@samba.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jan,

 > Then, I just tried everything to get an overview:

thanks!

 >  (All with DUALNAMES=n)
 >  # mount /dev/sdc1 /mnt -o iocharset=utf8,shortnames=lower
 >  # cp /mnt/dcim/100_fuji/dscf{4160,3004}.jpg
 >  # umount /mnt
 >  # mount /dev/sdc1 /mnt -o iocharset=utf8,shortnames=win95
 >  # cp /mnt/dcim/100_fuji/dscf{4160,3005}.jpg
 >  # umount /mnt
 >  # mount /dev/sdc1 /mnt -o iocharset=utf8,shortnames=winnt
 >  # cp /mnt/dcim/100_fuji/dscf{4160,3006}.jpg
 >  # umount /mnt
 >  # mount /dev/sdc1 /mnt -o iocharset=utf8,shortnames=mixed
 >  # cp /mnt/dcim/100_fuji/dscf{4160,3007}.jpg
 >  # umount /mnt
 > 
 > Result? The camera only displays 3006.
 > 
 > The dualnames patch's filling filenames with random illegal
 > chars does seems to have a really foul side-effect after 

actually, you've just proved the patch works as intended on your
device!

Only the shortname=winnt would create a 8.3 name when you use the
filename dscfNNNN.jpg. That is why my first patch in May forced 

   shortname_flags = VFAT_SFN_CREATE_WINNT;

when the patch triggered. I think this is the only sane behaviour for
a VFAT filesystem on Linux. Unfortunately it isn't the default, and at
least on my Ubuntu system the automatic mounting doesn't get this
right.

I'd love to change the default or do an override, at least when
dualnames is diabled. Hirofumi-san, what do you think?

Cheers, Tridge

PS: I'm assuming you actually typed "shortname=" not
"shortnames=". The option is not plural.
