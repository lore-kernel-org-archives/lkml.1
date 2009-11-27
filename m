Return-Path: <linux-kernel-owner+w=401wt.eu-S1752628AbZK0R6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbZK0R6S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 12:58:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752070AbZK0R6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 12:58:18 -0500
Received: from netrider.rowland.org ([192.131.102.5]:55816 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751947AbZK0R6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 12:58:17 -0500
Date: Fri, 27 Nov 2009 12:58:23 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: tmhikaru@gmail.com
cc: Jan Kara <jack@suse.cz>, Boaz Harrosh <bharrosh@panasas.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
       SCSI development list <linux-scsi@vger.kernel.org>,
       <linux-ext4@vger.kernel.org>
Subject: Re: Weird I/O errors with USB hard drive not remounting filesystem
 readonly
In-Reply-To: <20091127094339.GA9047@roll>
Message-ID: <Pine.LNX.4.44L0.0911271248210.30903-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Nov 2009 tmhikaru@gmail.com wrote:

> It is important to me to know exactly how the failure path operates. Please
> explain to me what I will see happen. - Not knowing is driving me nuts.

It goes like this.  The computer sends a lot of READ commands to the
drive.  (For all we know the same thing might happen with WRITEs, but
you didn't do any writing in the test data you sent.)  Every now and
then the drive fails to carry out a READ, for no apparent reason.

Normally the computer then retries, and the READ succeeds the second
time.  But of course, success isn't guaranteed.  When the retry does
succeed, no error messages are printed in the log and everything
continues normally.

Occasionally the computer does not retry the READ -- in circumstances
where it doesn't really need the data (optimistic readahead).  When 
this happens, the failed READ does cause an error message to appear.  
The same thing would happen if the attempted retries were to fail.

Whether or not this would result in lost or corrupted data, or
remounted readonly filesystems, depends on the kind of data being read.

Alan Stern

