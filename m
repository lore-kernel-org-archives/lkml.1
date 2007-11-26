Return-Path: <linux-kernel-owner+w=401wt.eu-S1754569AbXKZKXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569AbXKZKXv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 05:23:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753300AbXKZKXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 05:23:40 -0500
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:32501 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267AbXKZKXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 05:23:39 -0500
From: Swen Schillig <swen@vnet.ibm.com>
Organization: IBM
To: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] zfcp: add some internal zfcp adapter statistics
Date: Mon, 26 Nov 2007 11:23:04 +0100
User-Agent: KMail/1.9.5
Cc: Christof Schmitt <christof.schmitt@de.ibm.com>, linux-scsi@vger.kernel.org,
       Linux on 390 Port <LINUX-390@vm.marist.edu>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <200710311133.52090.swen@vnet.ibm.com> <1195989419.3427.11.camel@localhost.localdomain>
In-Reply-To: <1195989419.3427.11.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711261123.05253.swen@vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 25 November 2007 12:16, James Bottomley wrote:
> 
> On Wed, 2007-10-31 at 11:33 +0100, Swen Schillig wrote:
> > From: Swen Schillig <swen@vnet.ibm.com>
> > 
> > add some statistics provided by the zFCP adapter to the sysfs
> > 
> > The new zFCP adapter statistics provide a variety of information
> > about the virtual adapter (subchannel). In order to collect this information
> > the zFCP driver is extended on one side to query the adapter and
> > on the other side summarize certain values which can then be fetched on demand.
> > This information is made available via files(attributes) in the sysfs filesystem.
> > 
> > The information provided by the new zFCP adapter statistics can be fetched
> > by reading from the following files in the sysfs filesystem
> > 
> >  /sys/class/scsi_host/host<n>/seconds_active
> >  /sys/class/scsi_host/host<n>/requests
> >  /sys/class/scsi_host/host<n>/megabytes
> >  /sys/class/scsi_host/host<n>/utilization
> 
> This lot all look like they belong in the FC transport class statistics
> (some even already exist there).

They might look alike but they are not the same. The values provided through the FC transport
class always refer to the physical port whereas the new values here refer to a virtual adapter or subchannel.
The attributes provided here are all new and not covered or displayed anywhere else !

> 
> > These are the statistics on a virtual adapter (subchannel) level.
> > In addition latency information is provided on a SCSI device level (LUN) which
> > can be found at the following location
> > 
> >  /sys/class/scsi_device/<H:C:T:L>/device/cmd_latency
> >  /sys/class/scsi_device/<H:C:T:L>/device/read_latency
> >  /sys/class/scsi_device/<H:C:T:L>/device/write_latency
> 
> These look to duplicate to some degree the figures
> in /sys/block/<dev>/stat.  Isn't the block device the best place to
> gather these, if they're useful?  Since user latencies should probably
> include elevator times.

Actually no, the latencies covered here are channel- and fabric-latencies grouped by scsi-devices
and not device-, scsi- or block-latencies. In contrast to the stats provided by the block-layer structure,
tape devices will be covered here as well .

> 
> James
> 
> 
> 

Cheers Swen
