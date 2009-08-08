Return-Path: <linux-kernel-owner+w=401wt.eu-S934075AbZHHMTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934075AbZHHMTb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 08:19:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934057AbZHHMTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 08:19:30 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38286 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932357AbZHHMT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 08:19:29 -0400
Date: Sat, 8 Aug 2009 14:19:22 +0200
From: Pavel Machek <pavel@ucw.cz>
To: tridge@samba.org
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Martin Steigerwald <Martin@lichtvoll.de>,
       Jan Engelhardt <jengelh@medozas.de>, Theodore Tso <tytso@mit.edu>,
       Rusty Russell <rusty@rustcorp.com.au>, john.lanza@linux.com,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, corbet@lwn.net,
       jcm@jonmasters.org, torvalds@linux-foundation.org
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regressions
Message-ID: <20090808121922.GC11163@elf.ucw.cz>
References: <20090708110451.1092afa7@lxorguk.ukuu.org.uk> <1247066878.4159.153.camel@mulgrave.site> <20090708163736.0f98e7e0@lxorguk.ukuu.org.uk> <1247069202.4159.212.camel@mulgrave.site> <20090708171848.21633768@lxorguk.ukuu.org.uk> <873a96a23x.fsf@devron.myhome.or.jp> <87hbxhwv0j.fsf@devron.myhome.or.jp> <19045.14307.658887.752950@samba.org> <20090721103100.GF4133@elf.ucw.cz> <19045.49265.255525.260784@samba.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19045.49265.255525.260784@samba.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

>  > >   - Similarly, there is a small chance that chkdsk on Windows will
>  > >     rename one file in a directory if they happen to have the same 11
>  > >     byte dummy values. The probability of this happening is
>  > >     approximately 80x lower than with the previous patch.
>  > 
>  > The "small chance" seems to be 90% for 30000 files in directory. And
>  > no, it is probably not 80x lower. Do the math.
> 
> Perhaps you could double check my math? 
> 
> The number of combinations available with the current patch is 
> 35^6 * 7 * 8 for files (for directories there are more combinations, 
> but lets ignore that for now).
> 
> That comes to 102942875000 combinations.
> 
> Now we can do the exponential birthday approximation, which is:
> 
>   p = 1.0 - exp(-(n * (n-1)) / (2 * m))
> 
> where n is the number of entries in the directory, and m is the total
> number of combinations.
> 
> That comes to about 0.0052 for 32767 files in a directory
> (ie. maximully full), or about 0.5%.
> 
> With the previous patch we had 2^30 combinations, which came to 0.393,
> or about 39%. So the new patch has about 75x lower chance of a single
> collision than the old one.
> 
> Similarly for 100 files, the old patch gave a probability of
> 4.6*10^-6, whereas the new one gives 4.8x10^-8, which is about 96x
> lower chance of a single collision. 

I guess I should apologize here. I did not do the math. It just seemed
to me that from the paradox of twins, difference should be
greater. Sorry for confusion.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
