Return-Path: <linux-kernel-owner+w=401wt.eu-S1758872AbYBAF20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758872AbYBAF20 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 00:28:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750761AbYBAF2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 00:28:15 -0500
Received: from smtp107.sbc.mail.mud.yahoo.com ([68.142.198.206]:37955 "HELO
	smtp107.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750763AbYBAF2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 00:28:13 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=1gpzgPkh356uXRMgPNfiArfDH3WEL4w5FVcWvPAsW3T3G1QVeHtsRnKpZROj5aAXjj1KttoSmbPyDoyt/flEvBcSbUfW90X724up90d4uahpz4SX4YLp2lFIn826ymPB7DCq8ndhC1tbPVy+7B5IxcIJ/VW+XcrSepAuQbgtCDs=  ;
X-YMail-OSG: 26ow2koVM1n_JztPBzHhEvlSsCJ5Wko3F3mjYjxup5BvWDYJ0FiVV4ZK6SYFPIpSmKrqHWwmCw--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: linux-kernel@vger.kernel.org
Subject: Removing dev.power.power_state (WAS: Feature Removals for 2.6.25)
Date: Thu, 31 Jan 2008 21:28:09 -0800
User-Agent: KMail/1.9.6
Cc: linux-pm@lists.linux-foundation.org, Harvey.Harrison@gmail.com,
       Alan Stern <stern@rowland.harvard.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801312128.10700.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoth Harvey Harrison:

> Ping?
> What:	dev->power.power_state
> When:	July 2007
> Why:	Broken design for runtime control over driver power states, confusing
> 	driver-internal runtime power management with:  mechanisms to support
> 	system-wide sleep state transitions; event codes that distinguish
> 	different phases of swsusp "sleep" transitions; and userspace policy
> 	inputs.  This framework was never widely used, and most attempts to
> 	use it were broken.  Drivers should instead be exposing domain-specific
> 	interfaces either to kernel or to userspace.
> Who:	Pavel Machek <pavel@suse.cz>

A lot of the infrastructure using that has already been deleted, and
there are some incremental improvements pending for 2.6.25:

 - drivers/input/touchscreen/ads7846.c ... patch fixing this
   should be in either MM or the input queue

 - Documentation/power/devices.txt ... patch fixing this is
   in the suspend tree, due to merge RSN

 - drivers/spi/spi.c ... patch fixing this is in MM, due to
   merge with other SPI patches

 - drivers/pcmcia/ds.c ... at least I *think* that patch got sent

But there are still quite a few users left, and a new one was (sigh)
recently added.

 - drivers/rtc/rtc-sa1100.c ... new usage, merged last week

 - drivers/usb/... has various users, HCDs look easy enough to fix but
   the other bits will take more thought

 - drivers/ata/... has some too

 - drivers/ide/ppc/pmac.c

 - drivers/spi/... some controller drivers use this (look easy to fix)

 - drivers/scsi/mesh.c

 - drivers/input/serio/... has a few users

 - ... more ...

I'll probably send in a few more patches for easy stuff in areas
that I touch semi-frequently, but other folk should fix ATA, IDE,
SCSI, SERIO, and so forth.  It'd be good if Alan would help fix
the USB stuff too.  I'm not sure what Pavel's doing there...

- Dave

