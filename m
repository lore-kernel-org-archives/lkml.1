Return-Path: <linux-kernel-owner+w=401wt.eu-S1754777AbZHCTwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777AbZHCTwW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 15:52:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754717AbZHCTwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 15:52:21 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:40252 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754686AbZHCTwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 15:52:20 -0400
Date: Mon, 3 Aug 2009 15:52:21 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Lev A. Melnikovsky" <melnikovsky@mail.ru>
cc: Artur Skawina <art.08.09@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       <linux-usb@vger.kernel.org>
Subject: Re: reading errors on JMicron JM20337 USB-SATA
In-Reply-To: <alpine.LFD.2.00.0908032046010.31015@nev.ubzr>
Message-ID: <Pine.LNX.4.44L0.0908031539161.2888-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Aug 2009, Lev A. Melnikovsky wrote:

>   On Mon, 3 Aug 2009 at 6:25pm, Alan Stern wrote:
> 
> AS> You are correct except for the term "indefinitely".  The retries _will_
> AS> stop if you wait long enough.  Unfortunately, because of all the nested
> AS> retry loops in the SCSI drivers and at the application level, you may
> AS> have to wait as long as half an hour.
> It was a simple test, I've plugged the USB cable off after two hours, this 
> is apparently not long enough:
> 
> [root ~]# time dd if=/dev/sdf of=/dev/null skip=61395120 count=1 bs=512
> dd: reading `/dev/sdf': Input/output error
> 0+0 records in
> 0+0 records out
> 0 bytes (0 B) copied, 7550.12 s, 0.0 kB/s
> dd: closing input file `/dev/sdf': Bad file descriptor
> 
> real    125m50.119s
> user    0m0.000s
> sys     0m0.000s

Okay, it looks like I was wrong and this particular kind of error will
indeed cause unending retries.

Either way, like I said before, you should complain about this to the
SCSI people.  They are the ones who can fix it.  (You can CC: linux-usb
too, just to keep us in the loop.)

Tell them that scsi_end_request() mustn't call scsi_requeue_command() 
if bytes == 0.

Alan Stern

