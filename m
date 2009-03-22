Return-Path: <linux-kernel-owner+w=401wt.eu-S1754088AbZCVKZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088AbZCVKZc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 06:25:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752102AbZCVKZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 06:25:23 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:56852 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbZCVKZW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 06:25:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=kveb55NzKE3CZEOfPQElJ8b124OVuZPd4qonEutHFVOw//JjJ+z6LqnfrD2HV9RWJ5
         8gpmjy/P9gw4LOGJqkdyQNqP8+yTs8bVk5v0Vzift8tZwD2Z8SVmg99dBnjEQ5Gcs7US
         8oNecQqEU8Yygd5tzYU/SgGGob94JpBG+mosg=
From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
To: David Newall <davidn@davidnewall.com>
Subject: Re: df -h shows ~10 times bigger size when umounting pendrive
Date: Sun, 22 Mar 2009 11:25:16 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.29-rc8; KDE/4.2.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <200903220150.16004.a.miskiewicz@gmail.com> <49C5DEE5.6090205@davidnewall.com>
In-Reply-To: <49C5DEE5.6090205@davidnewall.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903221125.16860.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 22 of March 2009, David Newall wrote:
> Arkadiusz Miskiewicz wrote:
> > While umount was running and data were synced on the
> > pendrive df -h showed:
> >
> > [arekm@t400 ~]$ df -h
> > System plik�w         rozm. u�yte dost. %u�. zamont. na
> > /dev/sda3             9,6G  4,2G  5,5G  44% /
> > /dev/sdb1             9,6G  4,2G  5,5G  44% /media/floppy
>
> This looks to me like a race between umount and df.  By the time df had
> read mtab (to find the mounted filesystem), the pen drive had already
> been unmounted; but umount hadn't yet updated mtab.  It's a pretty
> trivial sort of fault, and not worth worrying about.

It's not that. umounting takes more than 15 seconds (syncing 650MB of data 
takes some time) and in that ~15 seconds I reliably get such results:

/etc/mtab contains:

/dev/sdb1 /media/floppy vfat rw 0 0

statfs() returns:

statfs("/media/floppy", {f_type=0x58465342, f_bsize=4096, f_blocks=2497555, 
f_bfree=1410716, f_bavail=1410716, f_files=10000448, f_ffree=9842679, 
f_fsid={2051, 0}, f_namelen=255, f_frsize=4096}) = 0

which is:

/dev/sdb1             9,6G  4,2G  5,4G  44% /media/floppy

So why statfs() lies on a being unmounted filesystem?

-- 
Arkadiusz Miśkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/

