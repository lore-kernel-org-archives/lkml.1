Return-Path: <linux-kernel-owner+w=401wt.eu-S1761506AbYFFPNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761506AbYFFPNy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 11:13:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758174AbYFFPNb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 11:13:31 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:42195 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757736AbYFFPN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 11:13:29 -0400
Subject: Re: [regression/bisected] corrupt CD data after media change and
	delay
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: David Martin <tasio@hierro.tasio.net>, Maarten Bressers <mbres@gentoo.org>,
       Daniel Drake <dsd@gentoo.org>, linux-scsi@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Cell Broadband Engine OSS Development 
	<cbe-oss-dev@ozlabs.org>
In-Reply-To: <Pine.LNX.4.64.0806061458300.6228@vixen.sonytel.be>
References: <Pine.LNX.4.64.0806061458300.6228@vixen.sonytel.be>
Content-Type: text/plain
Date: Fri, 06 Jun 2008 10:13:22 -0500
Message-Id: <1212765202.16182.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-06-06 at 16:06 +0200, Geert Uytterhoeven wrote:
> 	Hi all,
> 
> When mounting a CD/DVD more than 30 seconds after inserting it, and reading
> from it, we get:
> 
>     attempt to access beyond end of device
>     sr0: rw=0, want=371932, limit=371928
>     Buffer I/O error on device sr0, logical block 92982
>     attempt to access beyond end of device
>     sr0: rw=0, want=371936, limit=371928
>     Buffer I/O error on device sr0, logical block 92983
>     attempt to access beyond end of device
>     sr0: rw=0, want=371940, limit=371928
>     Buffer I/O error on device sr0, logical block 92984
>     attempt to access beyond end of device
>     sr0: rw=0, want=371944, limit=371928
>     Buffer I/O error on device sr0, logical block 92985
>     attempt to access beyond end of device
>     sr0: rw=0, want=371948, limit=371928
>     Buffer I/O error on device sr0, logical block 92986
>     ...
> 
> It can be reproduced on a PS3 with busybox userland using:
> 
>     # Insert first CD
>     $ mount /dev/sr0 /mnt
>     $ ls -R /mnt
>     $ umount /mnt
>     $ eject
>     # Remove first CD
> 
>     # Insert second CD
>     # Wait at least 30 seconds
>     $ mount /dev/sr0 /mnt
>     $ tar cf /dev/null /mnt
> 
> It does not happen when mounting the second CD within 30 seconds after
> inserting it, which is consistent with
> 
>     #define SR_TIMEOUT     (30 * HZ)
> 
> I can't seem to reproduce it with a Debian or Fedora Core 6 userland.
> 
> The problem is present in 2.6.25.
> 2.6.24 is OK.

Hmm ... how are you preventing HAL from automatically mounting the CD?

Also, in the two different situations, what does

cat /sys/block/sr0/size

(assuming your cd is sr0) give you?  My first theory is an incorrect
size propagating from something.

James


