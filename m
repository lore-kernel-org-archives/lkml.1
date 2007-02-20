Return-Path: <linux-kernel-owner+w=401wt.eu-S965109AbXBTEs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965109AbXBTEs2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 23:48:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965111AbXBTEs2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 23:48:28 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:60149 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965109AbXBTEsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 23:48:22 -0500
Message-ID: <45DA7D77.9020709@torque.net>
Date: Mon, 19 Feb 2007 23:47:51 -0500
From: Douglas Gilbert <dougg@torque.net>
Reply-To: dougg@torque.net
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>,
       linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       James.Bottomley@steeleye.com
Subject: Re: [PATCH] Block layer: separate out queue-oriented ioctls
References: <Pine.LNX.4.44L0.0702192238110.4237-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0702192238110.4237-100000@netrider.rowland.org>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> On Mon, 19 Feb 2007, Douglas Gilbert wrote:
> 
>> Alan,
>> The SG_GET_RESERVED_SIZE ioctl is also defined in
>> the block layer, see block/scsi_ioctl.c .
> 
> Ah, I didn't know that.  (Or more likely, I used to know and have since 
> forgotten.)  Thanks for pointing it out.
> 
>> I suspect it is just a kludge to fool cdrecord that it
>> is talking to a sg device. [One of many kludges in the
>> block SG_IO ioctl implementation to that end.]
>> So perhaps the block layer versions of SG_SET_RESERVED_SIZE
>> and SG_GET_RESERVED_SIZE need to be similarly capped.
> 
> Yes.  In fact one of them already is, but the other should be too.
> 
>> Actually I think that I would default SG_GET_RESERVED_SIZE to
>> request_queue->max_sectors * 512 in the block layer
>> implementation (as there is no "reserve buffer" associated
>> with a block device).
> 
> Okay.
> 
> Come to think of it, the reserved_size value used when a new sg device is
> created should also be capped at max_sectors * 512.  Agreed?  I can't see
> any reason for ever having a larger buffer -- it would be impossible to
> make use of the extra space.

Alan,
That depends whether or not max_sectors can be changed
(via sysfs) subsequent to a sg device being created.
And I think it can.

# ls -l /sys/block/sdc/queue/
total 0
drwxr-xr-x 2 root root    0 Feb 19 18:29 iosched
-r--r--r-- 1 root root 4096 Feb 19 23:41 max_hw_sectors_kb
-rw-r--r-- 1 root root 4096 Feb 19 23:41 max_sectors_kb
-rw-r--r-- 1 root root 4096 Feb 19 23:41 nr_requests
-rw-r--r-- 1 root root 4096 Feb 19 23:41 read_ahead_kb
-rw-r--r-- 1 root root 4096 Feb 19 23:41 scheduler


# cat max_hw_sectors_kb > max_sectors_kb

... is the real maximum if the LLD that set max_hw_sectors_kb
is to be believed (actually it is often a finger in
the wind).

Doug Gilbert


