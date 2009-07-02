Return-Path: <linux-kernel-owner+w=401wt.eu-S1756834AbZGBWXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756834AbZGBWXv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 18:23:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754850AbZGBWXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 18:23:45 -0400
Received: from mail.samba.org ([66.70.73.150]:41197 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754511AbZGBWXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 18:23:44 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19021.13158.80030.713099@samba.org>
Date: Fri, 3 Jul 2009 08:23:34 +1000
To: Pavel Machek <pavel@ucw.cz>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, john.lanza@linux.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] Added CONFIG_VFAT_FS_DUALNAMES option
In-Reply-To: <20090702220004.GF1485@ucw.cz>
References: <19013.8005.541836.436991@samba.org>
	<20090630063102.GB1351@ucw.cz>
	<19019.16217.291678.588673@samba.org>
	<20090702220004.GF1485@ucw.cz>
X-Mailer: VM 8.0.12 under 22.2.1 (x86_64-pc-linux-gnu)
Reply-To: tridge@samba.org
From: tridge@samba.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

 > You already know that it breaks XP and older linuxes. So... what are
 > you arguing about?! Chkdsk marks it as invalid filesystem... not a
 > vfat.

no, wrong on all 3 counts.

For the "breaks XP", see my previous message where I point out that I
have never been able to crash XP with this patch, only with other
varients on the patch that reduce the number of random bits we use.

The "breaks older linuxes" claim is also wrong. The patch I have
posted works fine with all older versions of the Linux kernel that I
have tested. If you know of a old version of the Linux kernel that
doesn't work with a filesystem written when this patch is enabled then
please let me know. I think you may be getting confused by the
discussion I had with Eric where I explained about the reasons for the
change in fat/dir.c. I won't repeat that long discussion again here,
but please re-read the reply I sent to Eric and if you still have
questions about it then please ask.

Finally, saying that "chkdsk marks it as an invalid filesystem" is not
correct. It only complains if there happens (with a very low
probability!) to be two files with the same 11 bytes in their
respective 8.3 entries. When it complains it renames one of the two
files.

That rename would not in itself be a problem at all, as changing the
8.3 entry would not affect the long filename, except that chkdsk has a
bug where it doesn't follow the Microsoft FAT specification. When you
rename a file on a FAT filesystem you are supposed to also update the
8 bit checksum field in the corresponding long filename entries. If
you don't do that update then you effectively strip off the long
filename. Current versions of Microsoft chkdsk neglect to update the
long filename checksum when renaming after detecting a duplicate 8.3
entry.

So it is Microsoft's chkdsk, not the patched Linux kernel, that is in
violation of the FAT spec. Luckily the probability of this bug
cropping up is quite small in practice.

Cheers, Tridge
