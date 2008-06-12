Return-Path: <linux-kernel-owner+w=401wt.eu-S1758936AbYFLLNz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758936AbYFLLNz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 07:13:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750786AbYFLLNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 07:13:45 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:56466 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbYFLLNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 07:13:44 -0400
Message-ID: <4851046E.907@s5r6.in-berlin.de>
Date: Thu, 12 Jun 2008 13:11:42 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.13) Gecko/20080313 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Tomasz Chmielewski <mangoo@wpkg.org>, shawnxjin@gmail.com
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Force a usb drive to be /dev/sda?
References: <4850DFB4.5020205@wpkg.org>
In-Reply-To: <4850DFB4.5020205@wpkg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tomasz Chmielewski wrote:
>> Is it possible to force a usb drive to be /dev/sda? I put an entire
>> linux system to a usb drive and want it boot a system with variable
>> sata disks. However the usb drive is always scanned as a last scsi
>> drive.
> 
> Is there a reason why you can't use filesystem labels or UUIDs?

Indeed.  Shawn, I see these options:

 1. Mount filesystems by UUID or by label.
    Doesn't work with some filesystems.

 2. Refer to devices by device ID or by device path.
    Requires a minimal udev environment which gives you
    /dev/disk/by-id or /dev/disk/by-path, or something
    similar to udev.  People had things like this already
    working under Linux 2.4, using programs like devlabel
    IIRC.  Requires you to set up an initrd with respective
    scripts in it.
    By-path only works if you never alter the USB topology
    and PCI topology.  I.e. prefer by-id.

 3. Influence the order of disk probing so that your USB
    disk is the first one.  Works only if there is at most
    one disk on the USB bus and requires you to wait with
    insertion or probing of the SATA controller driver (PCI
    driver) until after the USB disk was probed by sd_mod.

    There may or may not be very simple ways to do this.
    Simplest would be to configure the SATA controller driver
    as module and load that module in an rc script after the
    root filesystem was mounted.  That would actually be much
    simpler than option 2, so maybe you want to try this
    before 2.

 4. Last resort:  Hack sd_mod to defer any probes until after
    the first probe of an USB attached disk.  Requires some
    experience in kernel driver programming.
-- 
Stefan Richter
-=====-==--- -==- -==--
http://arcgraph.de/sr/
