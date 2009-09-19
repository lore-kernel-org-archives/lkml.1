Return-Path: <linux-kernel-owner+w=401wt.eu-S1753360AbZISWym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360AbZISWym (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 18:54:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752831AbZISWym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 18:54:42 -0400
Received: from mail-fx0-f216.google.com ([209.85.220.216]:36032 "EHLO
	mail-fx0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695AbZISWyl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 18:54:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=Kj1RTB3KbesH2sI/TtD0MNGJm1blSsAUzdN0ereeI8Zr2HG7l7nE6Tut6NNY/CA0Nx
         GB102EkyM1xbTAyFzInnAi60NyYXg88yO8GXu1vWtQ0BzEYffqUVFKHBU5u2rM9+Snt3
         Uyj8lPraHu2/2HKANktUASPEa2n+4xXdWw+Mk=
MIME-Version: 1.0
In-Reply-To: <a769871e0909191112t3adb852cn93d72dc5fd94b9fd@mail.gmail.com>
References: <a769871e0909191112t3adb852cn93d72dc5fd94b9fd@mail.gmail.com>
Date: Sun, 20 Sep 2009 00:54:43 +0200
Message-ID: <a769871e0909191554hf15150fiae155d71b47a3313@mail.gmail.com>
Subject: Re: EXT4 RAID read performance
From: wbrana@gmail.com
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

creating tar of compiled kernel takes much longer with ext4

time tar c linux-2.6.31 | cat >/dev/null

reiser3:
real    0m11.425s
user    0m0.229s
sys     0m1.586s

ext4:
real    0m23.942s
user    0m0.183s
sys     0m1.440s

partition was remounted before test

>
> RAID details:
>
> md8 : active raid10 sda7[0] sdd7[3] sdc7[2] sdb7[1]
>      62925824 blocks 256K chunks 2 far-copies [4/4] [UUUU]
>
> Ext4:
> mkfs.ext4 -E stride=64,stripe-width=128 /dev/md8
> mount -t ext4 -o noatime,auto_da_alloc,commit=600 /dev/md8 /mnt/md8
>
> Reiser3:
> mkfs.reiserfs /dev/md8
> mount -t reiserfs -o noatime,notail /dev/md8 /mnt/md8
>
