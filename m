Return-Path: <linux-kernel-owner+w=401wt.eu-S1765420AbXLQQl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765420AbXLQQl3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 11:41:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752301AbXLQQlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 11:41:21 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:56726 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122AbXLQQlT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 11:41:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RC/M12ODhQR5xEUJZUzkgp+crhqo/wwZqf+8BFMpyd/Sciv3fetHMoKiwXTSAbWE4tRt9xLFbl7/UmGz/D4IZfLKc1EhNhJ0cDYTiAWsN0GINkPN4YFvRLKuesQ3y32Lci3fnivHfR33g+QfwOPbA1tOEcdrXPNdk8OB1Sx8EpE=
Message-ID: <e9aeeef80712170841u6c908f0cg3b008b995ecd63f4@mail.gmail.com>
Date: Mon, 17 Dec 2007 14:41:18 -0200
From: Denis <denismpa@gmail.com>
To: "Jan Kara" <jack@suse.cz>
Subject: Re: Fwd: NFS , Kjournald - status D (uninterruptible sleep) - maquina lenta.
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20071217153228.GC6979@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <e9aeeef80712141011i139e6ec2pe04250bd56f338d8@mail.gmail.com>
	 <e9aeeef80712141211v7cec29fdt7e2ec76bf877053f@mail.gmail.com>
	 <e9aeeef80712141333n557325e3v11231b8bbe1b0963@mail.gmail.com>
	 <20071217153228.GC6979@atrey.karlin.mff.cuni.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2007/12/17, Jan Kara <jack@suse.cz>:
> > Dears, I've got a double dual xeon wich sometimes is getting too slow.
> >
> >
> > While i was observing one of these slowly times, I realized the time
> > wait of processors come close to 100% and nfsd and kjournald process
> > become to D status (uniterruptible sleep) .Does someone know why this
> > can be happening or how can I troubleshoot it?
> >
> > Below is a 'draw' of my top at one of these moments.
> >
> > [root@cromo src]# top
> > top - 10:59:02 up 6 days, 19:30, 17 users,  load average: 14.77, 13.46, 13.00
> > Tasks: 189 total,   1 running, 188 sleeping,   0 stopped,   0 zombie
> > Cpu0  :  0.0% us,  0.4% sy,  0.0% ni,  0.2% id, 98.5% wa,  0.0% hi,  0.9% si
> > Cpu1  :  0.0% us,  0.4% sy,  0.0% ni,  0.0% id, 99.6% wa,  0.0% hi,  0.0% si
> > Cpu2  :  0.0% us,  0.2% sy,  0.0% ni,  7.8% id, 92.0% wa,  0.0% hi,  0.0% si
> > Cpu3  :  0.2% us,  0.8% sy,  0.0% ni,  0.0% id, 98.7% wa,  0.2% hi,  0.0% si
>  All processors are in iowait - i.e. waiting for IO.
>
> > Mem:   4025540k total,  4018264k used,     7276k free,     7908k buffers
> > Swap:  4096564k total,     3288k used,  4093276k free,  3553252k cached
> >
> >  3941 root      15   0     0    0    0 D    2  0.0  80:29.30 nfsd
> >  3938 root      15   0     0    0    0 D    1  0.0  81:02.02 nfsd
> >  2459 root      15   0     0    0    0 D    1  0.0  30:57.04 kjournald
> >  3937 root      15   0     0    0    0 D    1  0.0  82:07.99 nfsd
> >    96 root      15   0     0    0    0 S    0  0.0  34:12.48 kswapd0
> >  3940 root      15   0     0    0    0 D    0  0.0  80:22.55 nfsd
> >  3942 root      15   0     0    0    0 D    0  0.0  80:23.66 nfsd
> >  3939 root      15   0     0    0    0 D    0  0.0  82:22.55 nfsd
>  It seems like heavy disk/network activity. You can try running
> vmstat 1
>  It will print every second the situation of your memory / IO
> subsystem. You should especially see the ---io--- column ('bi' means
> blocks in, 'bo' blocks outputted). I guess they'd contain some
> non-trivial values...

>
>                                                                Honza
> --
> Jan Kara <jack@suse.cz>
> SuSE CR Labs
>

Hello, Jan.

The output of my vmstat look like this:

procs -----------memory---------- ---swap-- -----io---- --system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in    cs us sy id wa
 0  1   3612 239600   2828 3364300    0    0  1494  1300   10     4  0  3 80 17
 0  1   3612 187756   2872 3413420    0    0    44 24608 4274 10679  0 12 72 17
 0  1   3612 153196   2900 3446100    0    0    28 17248 3349  6018  0  7 72 20
 0  4   3612 134804   2908 3453980    0    0     8 61140 1795  4528  0  3 31 65
 1  0   3612 144592   2920 3458796    0    0     4 18972 1689  2102  0  2 37 62
 0  2   3612  86936   2980 3512048    0    0    56 26656 4554 14563  0 13 69 18
 0  2   3612  45424   3024 3552532    0    0    40 19076 3774  8148  0  9 71 20
 0  1   3612  15792   3048 3579368    0    0    44 25696 4430 11954  0 12 72 16
 0  4   3612   7892   3064 3576972    0    0    16 74808 2430 12205  0  6 57 37
 0  1   3612  17828   3080 3581512    0    0     8 18832 2423  6117  0  5 50 45
 1  0   3612  16944   3068 3581048    0    0    40 26816 4126 15803  0 12 66 22
 0  0   3612  16032   3128 3578200    0    0    60 32640 5137 23987  0 15 68 17
 1  0   3612  15664   3144 3576620    0    0    56 33200 5178 17395  0 15 71 14
 0  5   3612   7956   3160 3573272    0    0    20 74092 2077  5504  0  4 54 41
 0  6   3612  12212   3168 3578568    0    0     8 30936 1964  3848  0  3 42 55
 1  1   3612  15752   3200 3579760    0    0    24 22352 2975  9692  0  8 60 32
 0  1   3612  16696   3240 3577340    0    0    40 22496 3954 15224  0 12 71 17
 2  0   3612  15472   3212 3576824    0    0    40 26624 4466 14382  0 13 71 16
 1  3   3612   5908   3228 3575924    0    0    16 72304 2328  8965  0  5 39 55
 0  1   3612  14188   3244 3579512    0    0     8 17892 2169  4147  0  4 57 39
 0  2   3612  17136   3292 3575520    0    0    56 28100 4672 16158  0 15 69 16


So, the bo, appears to be the problem.

>  BTW: I guess the processes wake up eventually, don't they?
Yes, they eventually wake up for a while and then get in
initerruptible sleep again

Considering that the BO is the problem, what can I try to fix it?

Thanks,
-- 
Denis Anjos.
Cisco Certified Network Associate.
Universidade Federal do ABC
Santo André - SP - BR
