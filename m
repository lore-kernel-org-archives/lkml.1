Return-Path: <linux-kernel-owner+w=401wt.eu-S932168AbXF1XVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932168AbXF1XVi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 19:21:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763473AbXF1XVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 19:21:32 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:33030 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761426AbXF1XVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 19:21:31 -0400
Date: Thu, 28 Jun 2007 17:20:18 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Unable to change sata NCQ depth due to readonly
 /sys/block/sdc/device/queue_depth file
In-reply-to: <fa.5pA6aeQb5Qu4sbwkw3l3yzw2bNQ@ifi.uio.no>
To: Roy Franz <roy.lists@gmail.com>
Cc: linux-kernel@vger.kernel.org
Message-id: <46844232.4070409@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.5pA6aeQb5Qu4sbwkw3l3yzw2bNQ@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roy Franz wrote:
> Hi,
> 
>  I am unable to change the NCQ settings for a sata drive that
> supports it - NCQ is always on.  This is due to the sysfs queue_depth
> file being read-only.  This is on
> vanilla 2.6.21.5 running with Debian Etch.  (Several earlier versions
> of the kernel
> had this same issue.)  The drive (WD Raptor) is hooked up to a Nvidia
> sata controller.
> 
> amd64:/# ls -al /sys/block/sdc/device/queue_depth
> -r--r--r-- 1 root root 4096 2007-06-28 10:04 
> /sys/block/sdc/device/queue_depth
> amd64:/# cat /sys/block/sdc/device/queue_depth
> 31
> amd64:/#
> 
> I searched but did not find any helpful information on this.  Forcing
> a change by changing permissions on the file did not work.

Looks like sata_nv is missing the change_queue_depth function in the 
SCSI host template, resulting in this file showing as read-only. I'll 
cook up a patch when I get a chance.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

