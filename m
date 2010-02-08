Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573Ab0BHKhp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 05:37:45 -0500
Received: from mail-in-11.arcor-online.net ([151.189.21.51]:46611 "EHLO
	mail-in-11.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755423Ab0BHKhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 05:37:43 -0500
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-06.arcor-online.net 0E11E39A7A8
Date: Mon, 8 Feb 2010 11:37:37 +0100 (CET)
From: Bodo Eggert <7eggert@gmx.de>
To: Miklos Szeredi <miklos@szeredi.hu>
cc: 7eggert@gmx.de, viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, eugene@redhat.com, mtk.manpages@gmail.com
Subject: Re: [RFC PATCH] vfs: add MNT_NOFOLLOW flag to umount(2)
In-Reply-To: <E1NdJKL-0003K8-S1@pomaz-ex.szeredi.hu>
Message-ID: <alpine.LNX.1.10.1002081131170.26981@be10.lrz>
References: <eae9I-mz-1@gated-at.bofh.it> <E1Nd6kb-000458-Ne@be1.7eggert.dyndns.org> <E1NdJKL-0003K8-S1@pomaz-ex.szeredi.hu>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463758335-457837453-1265625458=:26981"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463758335-457837453-1265625458=:26981
Content-Type: TEXT/PLAIN; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Fri, 5 Feb 2010, Miklos Szeredi wrote:

> On Thu, 04 Feb 2010, Bodo Eggert wrote:
>> Miklos Szeredi <miklos@szeredi.hu> wrote:
>>
>>> Additionally, return -EINVAL if an unknown flag is encountered.  This
>>> makes it possible for the caller to determine if a flag is supported
>>> or not (at least on kernels with this patch).
>>
>> There should be a guaranteed-to-be-invalid flag or flag-combination in
>> order to safely detect this feature.
>
> It's difficult though, because the app would have to make sure the
> detection itself would reliably fail, and with a different error.
>
> Simply checking the kernel version might be easier.

Yes, that's exactly what I intend to make possible:

| ret =3D umount("/tmp/mkstmp", UMOUNT_IMPOSSIBLE_FLAG);
| if (ret !=3D -1 || errno !=3D -EINVAL)
|     goto extended_mount_flags_are_not_supported;

Checking the kernel version is a bad idea, because the application might=20
be portable, or features might be backported. =A2=A2
---1463758335-457837453-1265625458=:26981--
