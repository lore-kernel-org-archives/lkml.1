Return-Path: <linux-kernel-owner+w=401wt.eu-S1758045AbZDSCIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758045AbZDSCIg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 22:08:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753772AbZDSCIZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 22:08:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57701 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516AbZDSCIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 22:08:24 -0400
Message-ID: <49EA8766.9070605@zytor.com>
Date: Sat, 18 Apr 2009 19:07:34 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Matti Aarnio <matti.aarnio@zmailer.org>
CC: Jesper Juhl <jj@chaosbits.net>, Prakash Punnoor <prakash@punnoor.de>,
       Michael Tokarev <mjt@tls.msk.ru>, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org, neilb@suse.de
Subject: Re: Proposal: make RAID6 code optional
References: <200904180946.27722.prakash@punnoor.de> <49E98AD2.8060601@msgid.tls.msk.ru> <200904181117.03418.prakash@punnoor.de> <alpine.LNX.2.00.0904181551320.16493@swampdragon.chaosbits.net> <20090418145850.GD28512@mea-ext.zmailer.org>
In-Reply-To: <20090418145850.GD28512@mea-ext.zmailer.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matti Aarnio wrote:
> 
> I did quick "sum of symbol sizes" lookup of the   raid.ko, and got
> it like this:
> 
> nm -t d -n -S /lib/modules/2.6.27.21-170.2.56.fc10.x86_64/kernel/drivers/md/raid456.ko | grep raid4|awk '{print $2}'|sed -e 's/^0*//g'|awk '{sum+=$1}END{print sum}'
>   ...
> 
> raid4:   152
> raid5:  7165
> raid6: 75558
> 
> Entire 64kB of that raid6 is single pre-initialized r/o datablock:  raid6_gfmul
> 
> So yes, having RAID6 personality as separate module would be appropriate for
> systems that are only interested in RAID4 or RAID5.  Separating the RAID4
> personality wastes space, separating RAID5 ...  barely 2 of 4k memory pages.
> 

RAID 4 is really just another layout scheme for RAID 5.  But yes, moving
RAID 6 to a separate module makes sense.  The amount of RAID 5 code not
used by RAID 6 is fairly trivial, so the right way to do this is to have
 the raid6 module depend on the raid5 module.

There used to be a raid6 module which was forked from raid5, with a lot
of duplicate code.  That really made really no sense.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

