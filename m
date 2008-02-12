Return-Path: <linux-kernel-owner+w=401wt.eu-S1759290AbYBLPV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759290AbYBLPV4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 10:21:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755675AbYBLPVs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 10:21:48 -0500
Received: from lazybastard.de ([212.112.238.170]:41856 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbYBLPVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 10:21:48 -0500
Date: Tue, 12 Feb 2008 16:21:24 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Stephane Chazelas <stephane.chazelas@emerson.com>
Cc: linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org
Subject: Re: [PATCH 2.6.24] block2mtd: removing a device and typo fixes
Message-ID: <20080212152124.GA21878@lazybastard.org>
References: <chaz20080212134751.GI30304@artesyncp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <chaz20080212134751.GI30304@artesyncp.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 February 2008 13:47:51 +0000, Stephane Chazelas wrote:
> 
> this patch addresses a number of small issues mainly regarding
> the output made by this driver to dmesg:
>   - Some of the "blkmtd"'s had not been changed to "block2mtd"
>     which caused display problem
>   - the parse_err() macro was displaying "block2mtd: " twice

Fairly obvious fixes.

> Also, one can add a block2mtd mtd device with things like:
> 
> echo /dev/loop3,$((256*1024)) |
>   sudo tee /sys/module/block2mtd/parameters/block2mtd
> 
> but individual mtds cannot be removed. You can only do a
> modprobe -r block2mtd to remove *all* the block2mtd mtds.
> 
> This patch proposes to add the cabability with:
> 
> echo /dev/loop3,remove |
>   sudo tee /sys/module/block2mtd/parameters/block2mtd

Sounds sane enough.  But I do have some reservations about the
implementation.  It would be best if you split the patch in two.  One
with the obvious stuff above and one for this.

The core of remove_device_by_name() is shared with block2mtd_exit(),
so a common helper would be good.  Your error handling is better, so
let's keep that version.

And independently of your patch a mutex protecting the device list from
simultaneous modifications would be good to have.

Side note: I may not have internet access until 19th or so.

Jörn

-- 
Rules of Optimization:
Rule 1: Don't do it.
Rule 2 (for experts only): Don't do it yet.
-- M.A. Jackson
