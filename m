Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934098Ab0CNVg0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 17:36:26 -0400
Received: from drutsystem.com ([80.72.38.138]:2350 "EHLO drutsystem.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933710Ab0CNVgU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 17:36:20 -0400
X-Greylist: delayed 1634 seconds by postgrey-1.27 at vger.kernel.org; Sun, 14 Mar 2010 17:36:20 EDT
Message-ID: <4B9D506D.3000609@ziu.info>
Date: Sun, 14 Mar 2010 22:09:01 +0100
From: Michal Soltys <soltys@ziu.info>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
Cc: Mikael Abrahamsson <swmike@swm.pp.se>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Daniel Taylor <Daniel.Taylor@wdc.com>, Jeff Garzik <jeff@garzik.org>,
       Mark Lord <kernel@teksavvy.com>, tytso@mit.edu,
       "H. Peter Anvin" <hpa@zytor.com>, hirofumi@mail.parknet.co.jp,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, irtiger@gmail.com,
       Matthew Wilcox <matthew@wil.cx>, aschnell@suse.de, knikanth@suse.de,
       jdelvare@suse.de
Subject: Re: ATA 4 KiB sector issues.
References: <4B947393.2050002@kernel.org> <alpine.DEB.1.10.1003090733330.9819@uplift.swm.pp.se> <4B961D8F.3010500@ziu.info> <4B96E397.1040005@kernel.org>
In-Reply-To: <4B96E397.1040005@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Checked: ClamAV on drutsystem.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> 
> I was thinking about testing XP booting this weekend but really want
> to avoid it, so thanks a lot for the info.  I'll update the doc
> accordingly but can you please enlighten me on how it works and what's
> broken in detail?  So, XP should be fine with any alignment?
> 
> Thanks.
> 

Sorry for late reply.

s/sp2/sp3 - although it shouldn't make a difference from sp2 onwards.

Anyway - the tests I did were because of weird laptop, where I shrinked 
whole win7 stuff and having no primary partitions left to use, I tested 
my usual windows xp installation I deploy with ntfsclone. Originally 
that XP were installed from installation disk merged with sp3 (or how 
it's usually called in windows world - slipstreamed). Of course, 
windows xp itself will not present any options to install itself into 
logical partition in the usual way - but during later deployment it's not 
a problem to put it where one's want.

It's possible that this wouldn't work, if windows were installed first 
from pre-sp2 media, and then service pack was installed (in such case, 
ntldr in C:\ is not updated afaik). It's also possible, that "brute-force" 
copied pre-sp2 or win2k to a partition made with either - a) xp sp2+'s disk 
manager or b) mkfs.ntfs and with updated most recent ntldr -  would boot as 
well (the partition requirement is due to potential differences between the code 
in bootsector, or more precisely - $Boot - first 8KiB of ntfs partition).

Obvious requirements besides the above (ntldr, perhaps $Boot as well) are:

- mentioned "hidden sectors" (must be manually adjusted, recent syslinux's 
chain.c32 has option to do it automatically)
- adjusted boot.ini (to point to new partition, eventually other windowish 
stuff as necessary)

As you can see, there're many "if"s and combinations here that I didn't test.

On a related note - ironically, while I had 0 problems making it work 
through syslinux (both regular chaining and through direct ntldr loading) - 
I couldn't make win7's bootmgr (bcd, bcdedit ....) do it properly. Oh well.

