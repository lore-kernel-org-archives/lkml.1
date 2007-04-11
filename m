Return-Path: <linux-kernel-owner+w=401wt.eu-S1753180AbXDKSE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180AbXDKSE3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 14:04:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753490AbXDKSE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 14:04:29 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:6365 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180AbXDKSE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 14:04:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=qq99q2c0km9XWPGez4RUmTVoXLNYuMM7j/tUW1pQQoR5ALcQEVYphyWxbMSlzDDltJbX0ZJMDV8wk4MpWhFqFmkZEbRlIBg1SCIWGrHGl5AruRWETcQW4E2v8YT5m6aC7BdauG8kFgiYifVyXRL3bYH5oBe0ob/QreOFer06emg=
Message-ID: <461D22E5.9030705@googlemail.com>
Date: Wed, 11 Apr 2007 20:03:17 +0200
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: xfs-masters@oss.sgi.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: mm snapshot broken-out-2007-04-11-02-24.tar.gz uploaded
References: <200704110926.l3B9Qe3D000895@shell0.pdx.osdl.net>
In-Reply-To: <200704110926.l3B9Qe3D000895@shell0.pdx.osdl.net>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

akpm@linux-foundation.org napisa³(a):
> The mm snapshot broken-out-2007-04-11-02-24.tar.gz has been uploaded to
> 
>    ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-2007-04-11-02-24.tar.gz
> 
> It contains the following patches against 2.6.21-rc6:
> 

After a few seconds of running test_mount_fs.sh
http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/broken-out-2007-04-11-02-24/test_mount_fs.sh
I get this

[11083.747512] Filesystem "loop4": Disabling barriers, not supported by the underlying device
[11083.759050] XFS mounting filesystem loop4
[11083.763769] Slab corruption: xfs_buf start=cce14938, len=272
[11083.769986] Redzone: 0x5a2cf071/0x5a2cf071.
[11083.774575] Last user: [<fddaacde>](xfs_buf_free+0x77/0x7b [xfs])
[11083.781146] 0b0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6c 6b 6b 6b
[11083.787988] Prev obj: start=cce1481c, len=272
[11083.792488] Redzone: 0x5a2cf071/0x5a2cf071.
[11083.796828] Last user: [<fddaacde>](xfs_buf_free+0x77/0x7b [xfs])
[11083.803131] 000: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
[11083.810392] 010: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
[11083.817677] Next obj: start=cce14a54, len=272
[11083.822146] Redzone: 0x5a2cf071/0x5a2cf071.
[11083.826415] Last user: [<fddaacde>](xfs_buf_free+0x77/0x7b [xfs])
[11083.832784] 000: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
[11083.839403] 010: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
[11083.852797] Ending clean XFS mount for filesystem: loop4
[11083.865789] SELinux: initialized (dev loop4, type xfs), uses xattr


http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/broken-out-2007-04-11-02-24/serialconsole.log
http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/broken-out-2007-04-11-02-24/mm-config

BTW. I wonder when this bug will be fixed
[11050.534896] =============================================
[11050.541883] [ INFO: possible recursive locking detected ]
[11050.547425] 2.6.21-rc6-mm1-1 #1
[11050.550630] ---------------------------------------------
[11050.556142] umount/3359 is trying to acquire lock:
[11050.561060]  (&(&ip->i_lock)->mr_lock){----}, at: [<fdd8729a>] xfs_ilock+0x4d/0x6e [xfs]
[11050.569565] 
[11050.569567] but task is already holding lock:
[11050.575487]  (&(&ip->i_lock)->mr_lock){----}, at: [<fdd8729a>] xfs_ilock+0x4d/0x6e [xfs]

Otherwise, for me it's another stable kernel

boot - ok
aio_dio_bugs - ok
aiostress - ok
bash_shared_mapping - ok
cat_proc - ok
cat_sys - ok
cpu_hotplug - ok
cyclictest - ok
fio - ok
fsfuzzer - ok
fsx - ok
isic - ok
linus_stress - ok
ltp - ok
rmaptest - ok
rttester - ok
scrashme - ok
spew - ok
stress - ok

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
