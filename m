Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640Ab0B1RwZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 12:52:25 -0500
Received: from mail-iw0-f182.google.com ([209.85.223.182]:49535 "EHLO
	mail-iw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722Ab0B1RwY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 12:52:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=V6fUB+t56PvgWGMwn0Zq2nlzqmN6mlR/WyfikyvRWeClifZT0bu1OrYr8gj5B25+qF
         MAMCX3sMAPU9vZ0ggp5Ko8Y4GLS0faieG49htPxUWnqzc1Fr3JH0b8H6JibKd2S0YD0a
         6E/HZjTHIfg00wow7YbUrHTJccOultl2Jjs4U=
MIME-Version: 1.0
In-Reply-To: <201002281531.45149.bzolnier@gmail.com>
References: <201002281531.45149.bzolnier@gmail.com>
Date: Sun, 28 Feb 2010 11:52:23 -0600
Message-ID: <51f3faa71002280952p479dd795ue6a4e4a06b67e6f8@mail.gmail.com>
Subject: Re: [git patch] atang tree: make SATA Asynchronous Notification work
From: Robert Hancock <hancockrwd@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 28, 2010 at 8:31 AM, Bartlomiej Zolnierkiewicz
<bzolnier@gmail.com> wrote:
> DISCLAIMER: the fact of getting patches merged into atang tree means
> that from now on they will be getting updates for changes happening
> in atang tree and it should not be treated as an indication regarding
> decisions taken by 'upstream' kernel trees
>
>
> Fix Asynchronous Notification (AN) support for SATA ATAPI devices
> (drives which support this feature will send a notification when new
> media is inserted and removed, preventing the need for user space to
> poll for new media needlessly consuming energy and CPU resources).
>
> Originally AN support was added to kernel in 2007, unfortunately some
> relevant bits were lost in the merge process and the feature remains
> non-functional in modern Linux distributions.  Lets fix it by adding
> kernel patch by Robert Hancock (from Oct 2009) addressing the issue.
>
> User-space part (HAL daemon in particular) still won't automatically
> disable media polling but it can be done manually by executing:
>
>  hal-disable-polling --device /dev/sr0
>
> command as root.
>
> [ To check if your ATAPI device supports AN:
>  # hdparm -I /dev/sr0|grep "Asynchronous notification"
>
>  To check if it is properly recognized by kernel & user-space:
>  $ lshal|grep support_async_notification ]
>
>
> PS1 if you have PLDS DS-8A3S drive in your laptop (like me) you may
> need to update the drive's firmware to the one containing AN support
> (HA28 for Asus' OEM drives and HD52 for Dell's ones)
>
> PS2 I will be rebasing atang on top of 2.6.33 in the near future
>
>
> The following changes since commit cad2f21db052f21beafd44d3396a565d9a485073:
>  Bartlomiej Zolnierkiewicz (1):
>        block: fix SSD performance regression
>
> are available in the git repository at:
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/bart/misc.git atang-v4.9
>
> Robert Hancock (1):
>      scsi: properly export media change notification capability in block device flags
>
>  drivers/scsi/sd.c |    2 ++
>  drivers/scsi/sr.c |    2 ++
>  2 files changed, 4 insertions(+), 0 deletions(-)

I think that patch is still applicable, but as you noted it doesn't
really have much effect on HAL by itself other than reporting the
"supports asynchronous notification" flag, there's nothing in HAL that
automatically stops polling when that's detected (at least last I
checked).

As I recall the new HAL replacement (DeviceKit-disks I believe)
doesn't depend on that particular flag to detect AN support.
