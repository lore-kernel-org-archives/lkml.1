Return-Path: <linux-kernel-owner+w=401wt.eu-S1753378AbYI3MBg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378AbYI3MBg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 08:01:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752265AbYI3MB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 08:01:28 -0400
Received: from cpsmtpo-eml04.kpnxchange.com ([213.75.38.153]:46130 "EHLO
	cpsmtpo-eml04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751873AbYI3MB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 08:01:27 -0400
From: Frans Pop <elendil@planet.nl>
To: Tony Vroon <tony@vroon.org>
Subject: Re: CD tray closes spontaneously after opening it
Date: Tue, 30 Sep 2008 14:01:22 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
References: <200809301247.05367.elendil@planet.nl> <1222773491.4003.2.camel@localhost>
In-Reply-To: <1222773491.4003.2.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809301401.23160.elendil@planet.nl>
X-OriginalArrivalTime: 30 Sep 2008 12:01:25.0632 (UTC) FILETIME=[437BC800:01C922F4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 September 2008, Tony Vroon wrote:
> On Tue, 2008-09-30 at 12:47 +0200, Frans Pop wrote:
> > Since 2.6.27 I've had several times, but not always, that after I
> > open the CD tray by pressing the eject button it spontaneously closes
> > after a short delay. The delay varies between ~0 and ~2 seconds.
>
> For the record, I had this on my Gentoo system. It turned out that HAL
> was responsible. (So it may not be a kernel bug at all)
>
> Do see this report:
> http://bugs.gentoo.org/show_bug.cgi?id=230886

Thanks for the link.

It cannot be hal in my case as I've disabled polling by hal for both
drives using the 'hal-disable-polling' command.

The bug report also mentions udev, but I'm not sure if that's it either
as the bit in the report is about sr* devices, which is SCSI/SATA and
the patch linked there is in Debian's udev.
The udev changelog for Debian has:
udev (0.125-4) unstable; urgency=medium
  * 60-persistent-storage.rules: do not run vol_id on media tray open
    events or the kernel will close the tray again.

Hmm, in Debian unstable /etc/udev/rules.d/60-persistent-storage.rules
also has:
# skip removable ide devices, because open(2) on them causes an events loop
KERNEL=="hd*[!0-9]", ATTR{removable}=="1", DRIVERS=="ide-cs|ide-floppy", \
                                        GOTO="persistent_storage_end"

I wonder if we've got a simple case of a typo here: ide-cs instead of
ide-cd? However, there is such a thing as an ide-cs driver (legacy driver
for PCMCIA IDE/ATA disk cards).
But it does seem logical that rule should also cover IDE CDs...

Cheers,
FJP
