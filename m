Return-Path: <linux-kernel-owner+w=401wt.eu-S1755925AbYLWEv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925AbYLWEv5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 23:51:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754638AbYLWEvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 23:51:49 -0500
Received: from main.gmane.org ([80.91.229.2]:46071 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754561AbYLWEvs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 23:51:48 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Checking a USB drive's capacity
Date: Mon, 22 Dec 2008 22:51:39 -0600
Message-ID: <49506E5B.5090604@shaw.ca>
References: <Pine.LNX.4.44L0.0812181641540.2217-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
Cc: Jens Axboe <axboe@kernel.dk>
X-Gmane-NNTP-Posting-Host: s0106000c41bb86e1.ss.shawcable.net
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
In-Reply-To: <Pine.LNX.4.44L0.0812181641540.2217-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> Jens:
> 
> As you may know, there are plenty of USB mass-storage devices that
> respond incorrectly to READ CAPACITY: They report the total number of
> blocks instead of the highest block number.  As a result, the kernel 
> thinks the drive has one more sector than it really does.
> 
> So far we have dealt with this problem by means of a blacklist, but
> this gets more and more unsatisfactory all the time.  We haven't been
> able to find any other way to cope, since a few devices are so badly
> behaved that they crash hard when you try to access the nonexistent
> "last" sector, requiring a replug or power cycle.
> 
> My new idea is to keep in the blacklist only those devices which do
> crash -- a relatively small number.  Everything else we should be able
> to detect safely at runtime, by testing if it's possible to read the
> last sector.
> 
> The question is, how and where?  The logical place for testing the
> capacity is near the end of sd_read_capacity().  However this code runs
> before any media accesses have occurred; the drive might not even be
> spun up yet.  Not to mention that it seems strange to read the last
> sector before reading the first!

It seems to me that the safest solution would be to mark USB storage 
devices as unsafe for last-sector partition table probing, like some 
kind of CAPACITY_DUBIOUS flag, causing it to be skipped on these 
devices, at least by default. After all, it would seem quite unusual to 
see anything other than a DOS-style partition table on a USB storage 
device (or else no partition table at all).

