Return-Path: <linux-kernel-owner+w=401wt.eu-S1758563AbYFFFSQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758563AbYFFFSQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 01:18:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752523AbYFFFSC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 01:18:02 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35162 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752459AbYFFFSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 01:18:00 -0400
Date: Thu, 5 Jun 2008 22:17:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: chris2553@googlemail.com
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
       Hannes Reinecke <hare@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2,6.26-rc4-git2 - long pause during boot
Message-Id: <20080605221709.f248eb90.akpm@linux-foundation.org>
In-Reply-To: <200806010415.05290.chris2553@googlemail.com>
References: <200806010415.05290.chris2553@googlemail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Jun 2008 04:15:05 +0000 Chris Clayton <chris2553@googlemail.com> wrote:

> Hi,
> 
> I've just started testing 2.6.26 on my desktop machine and have found that I get 
> a long pause (20 seconds or so) as the system boots. By pause I mean that the 
> boot messages that normally scroll by stop doing so for, as I say, about 20 
> seconds.
> 
> I've done a bisect and arrived at:
> 
> b0ed43360fdca227048d88a08290365cb681c1a8 is first bad commit
> commit b0ed43360fdca227048d88a08290365cb681c1a8
> Author: Hannes Reinecke <hare@suse.de>
> Date:   Tue Mar 18 14:32:28 2008 +0100
> 
>     [SCSI] add scsi_host and scsi_target to scsi_bus
> 
>     This patch implements scsi_host and scsi_target device types
>     and adds both to the scsi_bus.
> 
>     Signed-off-by: Hannes Reinecke <hare@suse.de>
>     Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
>     Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> 
> :040000 040000 4e3140909966b4c9aa987d34ee4078d283fe0351 
> 46e4fd28cc537ba700eb4f5652abf043fed4d76d M      drivers
> 
> The config file for that kernel is attached as are the kernel log for booting 
> that kernel and the bisect log.
> 
> I've also noticed that it takes much longer for icons to appear on my desktop 
> when I plug a usb storage device in. (The icons are shown/hidden by a simple 
> sctript that is run via udev when the device is attached/detached.)

Do you believe that this is the same period?  20 seconds?

> Let me know of any way I can help solve this.
> 
> Please cc me to any reply as I'm not subscribed.

cc's added.

Rafael, we might need to track this as a post-2.6.26 regression.

