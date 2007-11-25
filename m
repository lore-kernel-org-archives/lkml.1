Return-Path: <linux-kernel-owner+w=401wt.eu-S1755318AbXKYLRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318AbXKYLRS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 06:17:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752508AbXKYLRF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 06:17:05 -0500
Received: from hancock.steeleye.com ([71.30.118.248]:38661 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752237AbXKYLRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 06:17:04 -0500
Subject: Re: [PATCH] zfcp: add some internal zfcp adapter statistics
From: James Bottomley <James.Bottomley@SteelEye.com>
To: Swen Schillig <swen@vnet.ibm.com>
Cc: Christof Schmitt <christof.schmitt@de.ibm.com>, linux-scsi@vger.kernel.org,
       Linux on 390 Port <LINUX-390@vm.marist.edu>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <200710311133.52090.swen@vnet.ibm.com>
References: <200710311133.52090.swen@vnet.ibm.com>
Content-Type: text/plain
Date: Sun, 25 Nov 2007 13:16:59 +0200
Message-Id: <1195989419.3427.11.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 (2.12.1-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2007-10-31 at 11:33 +0100, Swen Schillig wrote:
> From: Swen Schillig <swen@vnet.ibm.com>
> 
> add some statistics provided by the zFCP adapter to the sysfs
> 
> The new zFCP adapter statistics provide a variety of information
> about the virtual adapter (subchannel). In order to collect this information
> the zFCP driver is extended on one side to query the adapter and
> on the other side summarize certain values which can then be fetched on demand.
> This information is made available via files(attributes) in the sysfs filesystem.
> 
> The information provided by the new zFCP adapter statistics can be fetched
> by reading from the following files in the sysfs filesystem
> 
>  /sys/class/scsi_host/host<n>/seconds_active
>  /sys/class/scsi_host/host<n>/requests
>  /sys/class/scsi_host/host<n>/megabytes
>  /sys/class/scsi_host/host<n>/utilization

This lot all look like they belong in the FC transport class statistics
(some even already exist there).

> These are the statistics on a virtual adapter (subchannel) level.
> In addition latency information is provided on a SCSI device level (LUN) which
> can be found at the following location
> 
>  /sys/class/scsi_device/<H:C:T:L>/device/cmd_latency
>  /sys/class/scsi_device/<H:C:T:L>/device/read_latency
>  /sys/class/scsi_device/<H:C:T:L>/device/write_latency

These look to duplicate to some degree the figures
in /sys/block/<dev>/stat.  Isn't the block device the best place to
gather these, if they're useful?  Since user latencies should probably
include elevator times.

James


