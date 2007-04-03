Return-Path: <linux-kernel-owner+w=401wt.eu-S1753106AbXDCFtu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106AbXDCFtu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 01:49:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753112AbXDCFtt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 01:49:49 -0400
Received: from jericho.provo.novell.com ([137.65.248.124]:52032 "EHLO
	jericho.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106AbXDCFts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 01:49:48 -0400
Message-ID: <4611EADC.3000306@suse.de>
Date: Tue, 03 Apr 2007 14:49:16 +0900
From: Tejun Heo <teheo@suse.de>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: linux@horizon.com
CC: dan.j.williams@intel.com, linux-ide@vger.kernel.org, neilb@suse.de,
       cebbert@redhat.com, jens.axboe@oracle.com, linux-kernel@dale.us,
       linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: 2.6.20.3 AMD64 oops in CFQ code
References: <20070323174630.31051.qmail@science.horizon.com>
In-Reply-To: <20070323174630.31051.qmail@science.horizon.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[resending.  my mail service was down for more than a week and this
message didn't get delivered.]

linux@horizon.com wrote:
> > Anyway, what's annoying is that I can't figure out how to bring the
> > drive back on line without resetting the box.  It's in a hot-swap
enclosure,
> > but power cycling the drive doesn't seem to help.  I thought libata
hotplug
> > was working?  (SiI3132 card, using the sil24 driver.)

Yeah, it's working but failing resets are considered highly dangerous
(in that the controller status is unknown and may cause something
dangerous like screaming interrupts) and port is muted after that.  The
plan is to handle this with polling hotplug such that libata tries to
revive the port if PHY status change is detected by polling.  Patches
are available but they need other things to resolved to get integrated.
 I think it'll happen before the summer.

Anyways, you can tell libata to retry the port by manually telling it to
rescan the port (echo - - - > /sys/class/scsi_host/hostX/scan).

> > (H'm... after rebooting, reallocated sectors jumped from 26 to 39.
> > Something is up with that drive.)

Yeap, seems like a broken drive to me.

Thanks.

-- 
tejun
