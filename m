Return-Path: <linux-kernel-owner+w=401wt.eu-S1755179AbYKBUf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755179AbYKBUf7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 15:35:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754430AbYKBUfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 15:35:47 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:55693 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754390AbYKBUfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 15:35:46 -0500
Date: Sun, 2 Nov 2008 12:35:42 -0800
From: Mike Anderson <andmike@linux.vnet.ibm.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Jens Axboe <axboe@kernel.dk>,
       SCSI development list <linux-scsi@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Problems with the block-layer timeouts
Message-ID: <20081102203542.GA16507@linux.vnet.ibm.com>
References: <Pine.LNX.4.44L0.0811011214470.21703-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0811011214470.21703-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern <stern@rowland.harvard.edu> wrote:
> I spent most of the day yesterday debugging some tricky problems in the
> new block-layer timeout scheme.  Clearly it is in need of more work.
> 
> A major reason for these problems was that there doesn't seem to be a 
> clear a idea of when the timeout period should begin.  In 
> blk_add_timer() a comment says:

> How should this be fixed?  It would help to call scsi_dev_queue_ready()  
> before elv_next_request(), but that's not sufficient.  
> scsi_times_out() needs to recognize that a timeout for a non-running
> request can be handled by directly returning BLK_EH_HANDLED.  Right?
> 
> 

Tejun described a similar issue here.
http://thread.gmane.org/gmane.linux.ide/35603

And a fix to address the issue here.
http://thread.gmane.org/gmane.linux.ide/35725

Does the patch posted by Tejun address your issue?

> While I'm on the subject, there are a few related items that could be 
> improved.  In my tests, I was generating I/O requests simply by doing
> 
> 	dd if=/dev/sda ...
> 
> I don't know where the timeouts for these requests are determined, but
> they were set to 60 seconds.  That seems much too long.
> 

It is set by a udev rule and the value is historical.
http://thread.gmane.org/gmane.linux.scsi/45631/focus=45646


-andmike
--
Michael Anderson
andmike@linux.vnet.ibm.com
