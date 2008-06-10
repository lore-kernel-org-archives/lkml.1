Return-Path: <linux-kernel-owner+w=401wt.eu-S1758760AbYFJWTo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758760AbYFJWTo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 18:19:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754732AbYFJWTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 18:19:34 -0400
Received: from netrider.rowland.org ([192.131.102.5]:4463 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754545AbYFJWTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 18:19:33 -0400
Date: Tue, 10 Jun 2008 18:19:32 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Chris Clayton <chris2553@googlemail.com>
cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
       Hannes Reinecke <hare@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       <linux-usb@vger.kernel.org>, Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: 2,6.26-rc4-git2 - long pause during boot
In-Reply-To: <200806102206.26818.chris2553@googlemail.com>
Message-ID: <Pine.LNX.4.44L0.0806101816290.20539-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jun 2008, Chris Clayton wrote:

> What this has shown is that, when I plug in a usb-storage device, there seems 
> to be a delay between the usb/scsi/usb-storage drivers setting up the device 
> and my icon-showing script being run. Here is the snippet from the kernel log 
> file:

...
> Jun 10 20:27:45 upstairs kernel: [ 3200.815772] usb-storage: waiting for device 
> to settle before scanning
> Jun 10 20:27:50 upstairs kernel: [ 3205.817115] scsi 10:0:0:0: Direct-Access              
> USB Flash Memory 5.00 PQ: 0 ANSI: 0 CCS
...

You can eliminate this 5-second delay by adding

	options usb-storage delay_use=0

to /etc/modprobe.conf.  Of course, this will make the other delays just 
stand out that much more sharply...

Alan Stern

