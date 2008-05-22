Return-Path: <linux-kernel-owner+w=401wt.eu-S1752436AbYEVOWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752436AbYEVOWX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 10:22:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751141AbYEVOWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 10:22:13 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:44231 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbYEVOWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 10:22:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=rzz08hAf+PfiXraqxlQQRKjnhwvHHt7+3dtUR8WSvK/5B8mNeX+oOOBFVBoK7/YeF3EAJm0MFE6MkEU6eue4HGK14O99m9qF3MtGKo+3Qa244p+ziJ55Qy/rDHqZDlybuVRl+Dn0/zqLNIugX4HopLhR+Wl6yM+KvIMkV99qwT8=
Message-ID: <524f69650805220722x3e1178cdsa8035aab0828ab7d@mail.gmail.com>
Date: Thu, 22 May 2008 09:22:10 -0500
From: "Steve French" <smfrench@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>, davej@redhat.com
Subject: Re: [CIFS] Fix reversed memset arguments.
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones <davej@redhat.com> wrote on 05/22/2008 08:07:22 AM:
Merged into cifs-2.6.git

Thanks for spotting this.

> size is the 3rd argument.
>
> Signed-off-by: Dave Jones <davej@redhat.com>
>
> --- linux-2.6/fs/cifs/inode.c~   2008-05-22 09:05:31.000000000 -0400
> +++ linux-2.6/fs/cifs/inode.c   2008-05-22 09:05:58.000000000 -0400
> @@ -172,7 +172,7 @@ static void fill_fake_finddataunix(FILE_
>  {
>     struct inode *pinode = NULL;
>
> -   memset(pfnd_dat, sizeof(FILE_UNIX_BASIC_INFO), 0);
> +   memset(pfnd_dat, 0, sizeof(FILE_UNIX_BASIC_INFO));
>
>  /*   __le64 pfnd_dat->EndOfFile = cpu_to_le64(0);
>     __le64 pfnd_dat->NumOfBytes = cpu_to_le64(0);
> @@ -384,7 +384,7 @@ static int get_sfu_mode(struct inode *in
>  static void fill_fake_finddata(FILE_ALL_INFO *pfnd_dat,
>                  struct super_block *sb)
>  {
> -   memset(pfnd_dat, sizeof(FILE_ALL_INFO), 0);
> +   memset(pfnd_dat, 0, sizeof(FILE_ALL_INFO));
>
>  /*   __le64 pfnd_dat->AllocationSize = cpu_to_le64(0);
>     __le64 pfnd_dat->EndOfFile = cpu_to_le64(0);
> --
> http://www.codemonkey.org.uk

-- 
Thanks,

Steve
