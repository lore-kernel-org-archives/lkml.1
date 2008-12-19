Return-Path: <linux-kernel-owner+w=401wt.eu-S1753772AbYLSEdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772AbYLSEdU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 23:33:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752532AbYLSEdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 23:33:11 -0500
Received: from netrider.rowland.org ([192.131.102.5]:4197 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752231AbYLSEdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 23:33:11 -0500
Date: Thu, 18 Dec 2008 23:33:09 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Jens Axboe <axboe@kernel.dk>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Checking a USB drive's capacity
In-Reply-To: <20081218224418.01fc26a4@lxorguk.ukuu.org.uk>
Message-ID: <Pine.LNX.4.44L0.0812182326100.31272-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Dec 2008, Alan Cox wrote:

> > spun up yet.  Not to mention that it seems strange to read the last
> > sector before reading the first!
> 
> The SCSI CD code deals with this by spotting the error is close to the
> end and of particular types then interpreting it and adjusting the volume
> size. This is done because the size value for a CD-R/RW is imprecise.

Although it may be okay for CDs, I suspect that approach won't work for 
disks.

For one thing, this would cause the volume size to change after the 
partition table had been read and interpreted, which doesn't seem like 
a good idea.

For another, it would cause the location of the "last" sector to change 
in mid-flight, which might well cause problems for programs like vol_id 
and hald_probe_storage -- they need to read the last sector to 
determine if the volume is part of a RAID array.

Now maybe these objections won't matter; the code in each case might be 
resilient enough to handle such changes.  Do you think it could work?

Alan Stern

