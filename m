Return-Path: <linux-kernel-owner+w=401wt.eu-S932178AbXB1MU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932178AbXB1MU4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 07:20:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932183AbXB1MU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 07:20:56 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:60137 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932178AbXB1MUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 07:20:55 -0500
Date: Wed, 28 Feb 2007 13:20:16 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Swetha Krishnan <swetha@cs.wisc.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Removing request from I/O scheduler queue
Message-ID: <20070228122016.GY3733@kernel.dk>
References: <45E3E009.4050503@cs.wisc.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45E3E009.4050503@cs.wisc.edu>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 27 2007, Swetha Krishnan wrote:
> I'm using linux 2.6.12 within user-mode linux. I need to remove a 
> specific I/O request (that I have means to identify) from the I/O 
> scheduler queues instead of moving it to the driver dispatch queue.
> To remove a request from the anticipatory scheduler's sort/fifo queues , 
> I'm making a call to as_remove_queued_request(), from within 
> as_move_to_dispatch(). Before removing it, I invoke the 
> as_find_next_arq() function so that the scheduler can pick the next 
> request once this one is removed.
> Everything works fine as far as the remove is concerned, but after 
> returning from the remove function and the end_io function that I call 
> on the request's bio field(a dummy end_io), the scheduler fails to 
> proceed with the next request chosen. I do check that if the next req 
> chosen is NULL, I exit from the as_move_to_dispatch() function but even 
> if I do this, the kernel panics after exiting from that function.
> 
> The chief points of panic from the (larger) dump, seems to be
> a02277d0:  [<a005eec3>] handle_IRQ_event+0x37/0x8c
> a0227800:  [<a005efaf>] __do_IRQ+0x97/0xe0
> a0227820:  [<a000defc>] do_IRQ+0x30/0x3c
> 
> Could you give me any pointers as to why this is happening? Is there any 
> additional cleanup that I need to do when I remove a request from the 
> scheduler's queues that as_remove_queued_request() does not already do?
> 
> I am rather new to linux I/O scheduling, so would be great if you could 
> let me know if there something basic I'm missing here.

You need to show your code, nobody can help you with such a vague
description of what is going on. Either you are illegally removing a
request, or your removal code is buggy. That is about all that one can
conclude from the above.

-- 
Jens Axboe

