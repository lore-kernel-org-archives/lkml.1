Return-Path: <linux-kernel-owner+w=401wt.eu-S1758729AbYFXI5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758729AbYFXI5Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 04:57:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752867AbYFXI47
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 04:56:59 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:58063 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbYFXI46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 04:56:58 -0400
Message-ID: <4860B651.9090104@s5r6.in-berlin.de>
Date: Tue, 24 Jun 2008 10:54:41 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.13) Gecko/20080313 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Jonathan Steinert <hachi@kuiki.net>
CC: linux-kernel@vger.kernel.org, Johannes Niess <linux@johannes-niess.de>,
       linux-usb@vger.kernel.org
Subject: Re: USB attached SATA disk idle spindown
References: <20080624045953.GA24600@miyako.sixapart.com>
In-Reply-To: <20080624045953.GA24600@miyako.sixapart.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(adding Cc: linux-usb and Johannes Niess)

On 6/24/2008 6:59 AM, Jonathan Steinert wrote at LKML:
> Dear list,
> 
> I am looking for what the current state of USB SATA timed spindown of-
> disks is ata this time. I've been reading documents and mailing lists-
> for every possible search I can dream up on the subject. Suggested-
> workable solutions include (but are probably not limited to):
> 
> $ hdparm -S
>     This seems to be the ATA way of telling a disk to spin down, and it
>     works in some situations, but doesn't appear to work on USB attached
>     disks under 2.6.25
> 
> $ sdparm
>     This is suggested in a small number of locations. Most of which have
>     examples on how to disable STANDBY on a handful of devices. I am
>     unable to find any evidence that it can actually be used to enable
>     power saving.

I think either of these depend on specific support by the USB to SATA
bridge firmware.

I hear some newer bridges and their firmwares implement ATA
pass-through.  Would that help?

> $ scsi_spin
>     Requires the disk to be unmounted, and I can't find anything saying
>     that this is how the world is supposed to be.-

Johannes recently informed me that he wrote a script which is used like
a background daemon to stop idle USB disks.  The script uses
  - "cat /sys/block/${device}/stat" to watch disk activity,
  - "sdparm -q -C stop /dev/${device}" to stop the motor after
    longer inactivity.

> I'm hoping that perhaps I'm missing something from this list.
> 
> I don't really know whether this is a topic for the scsi people, or the-
> SATA people, or the USB people. So I'm asking here instead to try and
> get my first hints from the parent group.
> 
> Thanks in advance,
> 
> hachi

IMO it is firstly an USB topic because it depends on the features and
behaviour of the bridge and its firmware.

(PS:  Don't have too high expectations of $15 devices.)
-- 
Stefan Richter
-=====-==--- -==- ==---
http://arcgraph.de/sr/
