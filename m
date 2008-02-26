Return-Path: <linux-kernel-owner+w=401wt.eu-S1760701AbYBZACj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760701AbYBZACj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 19:02:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757582AbYBZACb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 19:02:31 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:46761 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757531AbYBZACa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 19:02:30 -0500
Message-ID: <47C35714.4090604@garzik.org>
Date: Mon, 25 Feb 2008 19:02:28 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC] Disk shock protection (revisited)
References: <87skzgd1zk.fsf@denkblock.local>
In-Reply-To: <87skzgd1zk.fsf@denkblock.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Elias Oltmanns wrote:
> The general idea: A daemon running in user space monitors input data
> from an accelerometer. When the daemon detects a critical condition,
> i.e., a sudden acceleration (for instance, laptop slides off the desk),
> it signals the kernel so the hard disk may be put into a (more) safe
> state. To this end, the kernel has to issue an idle immediate command
> with unload feature and stop the block layer queue afterwards. Once the
> daemon tells us that the imminent danger is over, the most important
> task for the kernel is to restart the block layer queue. See below for
> more details.

Speaking specifically to that problem, it seems to me that you either 
want an mlock'd daemon, or just simply to keep everything in the kernel, 
for this specific solution.

You don't want, for example, to swap out other apps, swap in the daemon, 
in order to handle a sudden acceleration.

	Jeff


