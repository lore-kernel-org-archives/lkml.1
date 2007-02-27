Return-Path: <linux-kernel-owner+w=401wt.eu-S1751134AbXB0HrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751134AbXB0HrT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 02:47:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751359AbXB0HrT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 02:47:19 -0500
Received: from pumice.cs.wisc.edu ([128.105.6.29]:47841 "EHLO
	pumice.cs.wisc.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbXB0HrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 02:47:18 -0500
X-Greylist: delayed 504 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Feb 2007 02:47:18 EST
Message-ID: <45E3E009.4050503@cs.wisc.edu>
Date: Tue, 27 Feb 2007 01:38:49 -0600
From: Swetha Krishnan <swetha@cs.wisc.edu>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Removing request from I/O scheduler queue
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-CSL-MailScanner-Information: Please contact lab@cs.wisc.edu for more information
X-CSL-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm using linux 2.6.12 within user-mode linux. I need to remove a 
specific I/O request (that I have means to identify) from the I/O 
scheduler queues instead of moving it to the driver dispatch queue.
To remove a request from the anticipatory scheduler's sort/fifo queues , 
I'm making a call to as_remove_queued_request(), from within 
as_move_to_dispatch(). Before removing it, I invoke the 
as_find_next_arq() function so that the scheduler can pick the next 
request once this one is removed.
Everything works fine as far as the remove is concerned, but after 
returning from the remove function and the end_io function that I call 
on the request's bio field(a dummy end_io), the scheduler fails to 
proceed with the next request chosen. I do check that if the next req 
chosen is NULL, I exit from the as_move_to_dispatch() function but even 
if I do this, the kernel panics after exiting from that function.

The chief points of panic from the (larger) dump, seems to be
a02277d0:  [<a005eec3>] handle_IRQ_event+0x37/0x8c
a0227800:  [<a005efaf>] __do_IRQ+0x97/0xe0
a0227820:  [<a000defc>] do_IRQ+0x30/0x3c

Could you give me any pointers as to why this is happening? Is there any 
additional cleanup that I need to do when I remove a request from the 
scheduler's queues that as_remove_queued_request() does not already do?

I am rather new to linux I/O scheduling, so would be great if you could 
let me know if there something basic I'm missing here.

Thanks,
Swetha.


