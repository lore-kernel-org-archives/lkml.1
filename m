Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753313AbYLRNJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313AbYLRNJU (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 08:09:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751671AbYLRNJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 08:09:00 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:56899 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762AbYLRNJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 08:09:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=KUMsLcn3JzmWae36tAQbdJ4uVDcM34ZllIfd1+oaxATm+nyq/xz6u09k+KHyxNYaOQ
         QJ1gxmTHZt1X/A88c2Tn7yxbxC5vpJbeHmvrdgvFG1T1Ygs3LN2/elLPRcamq8ebWhlf
         F9ZV2W3e4cIKCmnJL5rCFRq5m6DvqMP1091uY=
Message-ID: <47ed01bd0812180508t89d1aecr13d2b9e8402ed885@mail.gmail.com>
Date: Thu, 18 Dec 2008 08:08:58 -0500
From: "Dylan Taft" <d13f00l@gmail.com>
To: "Nick Andrew" <nick@nick-andrew.net>
Subject: Re: MDADM Software Raid Woes
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20081218065603.GA21265@mail.local.tull.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47ed01bd0812172033p1065b472t62491e4f2eed901@mail.gmail.com>
	 <20081218065603.GA21265@mail.local.tull.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I may give that a shot.

But it also looks like my major numbers are wrong on the actual device nodes?
brw-r-----  1 root disk   9, 0 Dec 17 19:13 0
brw-r-----  1 root disk 259, 0 Dec 17 19:13 1
brw-r-----  1 root disk 259, 1 Dec 17 19:13 2
brw-r-----  1 root disk 259, 2 Dec 17 19:13 3

Shouldn't this be 9,something, not 259?

If I change the partition type from fd to something else, and don't
allow the kernel to auto assemble, then assemble manually via mdadm,
things work right.
Any idea what could cause thee major numbers to be wrong?

On Thu, Dec 18, 2008 at 1:56 AM, Nick Andrew <nick@nick-andrew.net> wrote:
> On Wed, Dec 17, 2008 at 11:33:31PM -0500, Dylan Taft wrote:
>> I created the raids with the mdadm tool, originally configured manually
>> /dev/md0 for sdb1/sdc1 raid1 to be mounted as /boot
>> /dev/md1 for sdb2/sdc2 raid0
>>
>> I created 3 partitions on md1, one for future /, one for swap, one for
>> future /home.
>> So I had /dev/md0, md1, and /dev/md1p1,/dev/md1p2/dev/md1p3
>
> Why not use LVM for /dev/md1 ?
>
>        pvcreate /dev/md1
>        vgcreate myvg /dev/md1
>        lvcreate -L 10G -n root myvg
>        lvcreate -L 2G -n swap myvg
>        lvcreate -L 20G -n home myvg
>
> Also since you have specified raid0 for /dev/md1 you could
> use striping under LVM instead of RAID:
>
>        pvcreate /dev/sdb2 /dev/sdc2
>        vgcreate myvg /dev/sdb2 /dev/sdc2
>        lvcreate -L 10G -n root -i 2 -I 32 myvg
>        lvcreate -L 2G -n swap -i 2 -I 32 myvg
>        lvcreate -L 20G -n home -i 2 -I 32 myvg
>
> That way you have some flexibility in your use of sdb2
> and sdc2, e.g. you can move your LVs off sdc2 if you want
> to replace or extend it later.
>
> Nick.
>
