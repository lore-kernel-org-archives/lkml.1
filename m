Return-Path: <linux-kernel-owner+w=401wt.eu-S1752450AbYJ0PJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752450AbYJ0PJV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 11:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751518AbYJ0PJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 11:09:04 -0400
Received: from gw-ca.panasas.com ([66.104.249.162]:9740 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751480AbYJ0PJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 11:09:02 -0400
Message-ID: <4905D986.6050001@panasas.com>
Date: Mon, 27 Oct 2008 17:08:54 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 3.0a1 (X11/2008050714)
MIME-Version: 1.0
To: dgilbert@interlog.com
CC: Alan Stern <stern@rowland.harvard.edu>,
       Luciano Rocha <luciano@eurotux.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>,
       SCSI development list <linux-scsi@vger.kernel.org>
Subject: Re: usb hdd problems with 2.6.27.2
References: <Pine.LNX.4.44L0.0810271007030.4059-100000@iolanthe.rowland.org> <4905D68D.7030407@interlog.com>
In-Reply-To: <4905D68D.7030407@interlog.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Oct 2008 15:07:44.0324 (UTC) FILETIME=[C3A81040:01C93845]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Douglas Gilbert wrote:
> 
> Since the READ CAPACITY "off by one" error is so common,
> perhaps drivers such as usb-storage could have a hook to
> do a pseudo READ CAPACITY. Then if the capacity value
> looked odd (in both senses) the driver could do an IO to
> the suspect block and if that failed decrement the capacity
> value passed back to the mid level.
> Put another way, why don't these defective devices trip up
> another OS?
> 

Window$ never reads the last sector unless it is actually written
to. I had such a device it got stuck when I wrote to the
last sector.

> BTW a single disk in RAID 0 (seen on a HP E200 controller)
> has a shortened capacity value seen in the midlevel on the
> corresponding logical drive. That missing chunk is probably
> where the RAID controller puts its control information.
> Anyway, playing with the capacity value returned by READ
> CAPACITY certainly has a precedent.
> 
>> Later on the system tries to read the contents of what it thinks is the 
>> last sector:
> 
> I know that happens but it seems strange that upper levels
> are reading a block that has never been written to. Read ahead?
> 

That would be udev or hald, I can't remember which. It is a special Linux
fixture. ;)

> Doug Gilbert
> 
> 

Boaz
