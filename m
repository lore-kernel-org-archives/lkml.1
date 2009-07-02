Return-Path: <linux-kernel-owner+w=401wt.eu-S1757173AbZGBWmI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757173AbZGBWmI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 18:42:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754215AbZGBWmB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 18:42:01 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53570 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257AbZGBWmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 18:42:00 -0400
Date: Fri, 3 Jul 2009 00:41:54 +0200
From: Pavel Machek <pavel@ucw.cz>
To: tridge@samba.org
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, john.lanza@linux.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] Added CONFIG_VFAT_FS_DUALNAMES option
Message-ID: <20090702224154.GC30840@elf.ucw.cz>
References: <19013.8005.541836.436991@samba.org> <20090630063102.GB1351@ucw.cz> <19019.16217.291678.588673@samba.org> <20090702220004.GF1485@ucw.cz> <19021.13158.80030.713099@samba.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19021.13158.80030.713099@samba.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-07-03 08:23:34, tridge@samba.org wrote:
> Hi Pavel,
> 
>  > You already know that it breaks XP and older linuxes. So... what are
>  > you arguing about?! Chkdsk marks it as invalid filesystem... not a
>  > vfat.
> 
> no, wrong on all 3 counts.
> 
> For the "breaks XP", see my previous message where I point out that I
> have never been able to crash XP with this patch, only with other
> varients on the patch that reduce the number of random bits we use.

...where you point out that probability of breakage is not too
high. But ammount of XP machines out there _is_ quite high, so someone
will hit it. You are deliberately breaking XP.

> The "breaks older linuxes" claim is also wrong. The patch I have
> posted works fine with all older versions of the Linux kernel that I
> have tested. If you know of a old version of the Linux kernel that
> doesn't work with a filesystem written when this patch is enabled then
> please let me know. I think you may be getting confused by the
> discussion I had with Eric where I explained about the reasons for the
> change in fat/dir.c. I won't repeat that long discussion again here,
> but please re-read the reply I sent to Eric and if you still have
> questions about it then please ask.

Ok, I guess I misunderstood. So what is the reason for pushing stable patch?

> Finally, saying that "chkdsk marks it as an invalid filesystem" is not
> correct. It only complains if there happens (with a very low
> probability!) to be two files with the same 11 bytes in their
> respective 8.3 entries. When it complains it renames one of the two
> files.

The "very low probability" is 50% for 30000 entries in directory,
AFAICT.

> That rename would not in itself be a problem at all, as changing the
> 8.3 entry would not affect the long filename, except that chkdsk has a
> bug where it doesn't follow the Microsoft FAT specification. When

Yeah, when map and reality disagree, trust the map. Not.

I don't care what M$ spec says, and you should not care, either. It is
M$ chkdsk that matters, and M$ VFAT implementation that matters.

> So it is Microsoft's chkdsk, not the patched Linux kernel, that is in
> violation of the FAT spec. Luckily the probability of this bug
> cropping up is quite small in practice.

Yes, explain that to the people. Actually, write it to the Kconfig.
"Turn this option ON to show bugs in M$ chkdsk". 

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
