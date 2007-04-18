Return-Path: <linux-kernel-owner+w=401wt.eu-S933068AbXDRXBG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933068AbXDRXBG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 19:01:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933078AbXDRXBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 19:01:06 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:25151 "EHLO
	pd4mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933068AbXDRXBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 19:01:04 -0400
Date: Wed, 18 Apr 2007 17:00:19 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Loud "pop" coming from hard drive on reboot
In-reply-to: <fa.jDn5j5GVDwXXnVYH74vVT3m+Gq8@ifi.uio.no>
To: Tejun Heo <htejun@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: Mark Lord <liml@rtr.ca>
Message-id: <4626A303.80208@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.nTNVZ3bPe8773+gVV7CvcwBT5zY@ifi.uio.no>
 <fa.r8VLu18GDND9EByYV/EX2mH9V88@ifi.uio.no>
 <fa.30Zxf5IYhdVc+I5v0caKmHH3HmE@ifi.uio.no>
 <fa.EFm9zBLufsOlxdviaZmnBDcbYgY@ifi.uio.no>
 <fa.TBFIUvjBaGbwUHy5JUiGJpvOeMI@ifi.uio.no>
 <fa.jDn5j5GVDwXXnVYH74vVT3m+Gq8@ifi.uio.no>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> This really isn't a regression.  It's been always like that with libata.
>  libata doesn't make devices go into standby mode and shutdown(8) does
> it for libata.  The problem here is that libata does issue
> SYNCHRONIZE_CACHE on shutdown.  So, the sequence of event is...
> 
> 1. shutdown(8) issues SYNCHRONIZE_CACHE followed by STANDBY_NOW

This part is presumably distribution dependent. I have never seen Fedora 
or CentOS shut down drives on power down from the shutdown script/utility..

> 2. kernel shutdown starts
> 3. libata shutdown issues SYNCHRONIZE_CACHE
> 4. power goes off
> 
> Some drives seem to spin up at step #3 even when its cache is clean and
> power goes off right after the disk finishes the command.  So, it's
> really bad when it happens - spin down, spin up followed by immediate
> power off.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

