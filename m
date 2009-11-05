Return-Path: <linux-kernel-owner+w=401wt.eu-S1758533AbZKEUXD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758533AbZKEUXD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 15:23:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758371AbZKEUXC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 15:23:02 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:56348 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758255AbZKEUXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 15:23:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=ZT4GJabwarNaDrIG7F+eR6HLAiDaLgsjIuLx+xcufVZUdEphCW3t9NxR/X3vEYJjAg
         wV1yL/UQDik5nU2ODG1JHUbTT2qFe8E4FWnQWylxuawQH/de7Oy4MjN9gxlHfztzkOqp
         N/5O11YWaOHZDx+lj77T2wqSV18ok/7sI58mk=
MIME-Version: 1.0
From: Paolo Giarrusso <p.giarrusso@gmail.com>
Date: Thu, 5 Nov 2009 21:22:45 +0100
Message-ID: <a4d0c86c0911051222q1ec384a2u724e0c8b1432ddb6@mail.gmail.com>
Subject: Daylight saving time & FAT
To: hirofumi@mail.parknet.co.jp
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I'm an ex kernel developer, writing to you because of a problem with
FAT and its Linux driver.

When re-rsync'ing two hard drives (one VFAT, one NTFS mounted with
ntfs-3g) after a Daylight Saving Time change (I was on CEST, +0200,
now I'm on CET, +0100), I discovered a one-hour time difference over
all files (on FAT, they are one hour in future).
My current understanding is that FAT stores times relative to the
current timezone, and that's crappy (see fat_time_fat2unix(), in
fs/fat/misc.c). But with the current code, it gets even more crappy -
the same file will have a different _UTC_ timestamp depending on my
current timezone, since the current offset from UTC is added to the
stored timestamp to get the UTC time (I verified the timezone change
would perfectly explain, even in sign, the time difference I found).
That's why I guess that the FAT timestamps are wrong.
I frankly doubt that Windows is so bad.

On DOS, they could get away without any conversion at all. But on
current Windows systems? Either you find the right time zone at file
saving time (too complicated IMHO) or ignore DST when saving/restoring
time (i.e. pretend DST is not in effect, and add the shift if needed).
I don't know right now what happens.
I wrote this mail to discuss what would be the correct solution (the
second?), and if it is possible to implement it.

Thanks for your attention
Regards
-- 
Paolo Giarrusso
