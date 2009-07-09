Return-Path: <linux-kernel-owner+w=401wt.eu-S1752713AbZGIENb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713AbZGIENb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 00:13:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750846AbZGIENU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 00:13:20 -0400
Received: from mail.samba.org ([66.70.73.150]:43547 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750737AbZGIENT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 00:13:19 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19029.28240.995268.850038@samba.org>
Date: Thu, 9 Jul 2009 14:13:04 +1000
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
In-Reply-To: <200907081339.59815.Martin@lichtvoll.de>
References: <19013.8005.541836.436991@samba.org>
	<200907072356.51553.Martin@lichtvoll.de>
	<19028.3736.892828.352905@samba.org>
	<200907081339.59815.Martin@lichtvoll.de>
X-Mailer: VM 8.0.12 under 22.2.1 (x86_64-pc-linux-gnu)
Reply-To: tridge@samba.org
From: tridge@samba.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Martin,

 > The question before that would be whether anyone has a comprehensive list 
 > of those tools, cause I think there are quite many. Well at least those 
 > from bigger vendors should be tested I think. Paragon, Symantec, ...

Do you happen to have any of those handy to test with?

 > And has it been tested with Linux tools such as fsck.msdos, fsck.vfat, 
 > parted and partimage? I think it probably has not much effect on parted and 
 > partimage, but what about the fscks?

I tested it with dosfstools (which provides the fsck.vfat on Linux
distros) and with mtools. Both required patches to work correctly. I
have submitted both patches to the maintainers of those packages.

The patch to dosfstools makes it skip the invalid 8.3 entries, just as
windows chkdsk does. The patch is here:

  http://samba.org/tridge/dosfstools.patch1

The patch to mtools is partly cosmetic, and partly to fix a bug in the
VFAT checksum routine. The code in mtools incorrectly treated a nul
byte as special in 8.3 directory entries. The patch is here:

  http://samba.org/tridge/mtools.patch1

 > Thus even when the patch only changes the values stored for new - or 
 > rewritten? - files it actively corrupts the meta consistency of the whole 
 > filesystem. To me it is like inserting a defective inode into a consistent 
 > Linux filesystem.

If the windows implementation is taken as the reference implementation
then the files are not considered defective. The windows chkdsk will
(with a small probability) complain of duplicates, but it doesn't
complain about the entries being defective in any other way.

 > I don't believe that Microsoft is still providing updates for Win98. But I 
 > think Windows 2000 might still be in use - I for example have a Win 2000 
 > installation on my ThinkPad T23, although I didn't boot it for about a 
 > year or so. Has it been tested against Windows 2000? I digged for the mail 
 > where you said something about against which Windows versions you tested, 
 > but I didn't find it anymore.

I haven't tested against w2k yet. I'll need to dig through my old MSDN
CD stack and see if I can find a w2k CD to test with. It's no longer
offered on current MSDN subscriptions.

Cheers, Tridge
