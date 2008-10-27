Return-Path: <linux-kernel-owner+w=401wt.eu-S1753650AbYJ0UgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753650AbYJ0UgV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 16:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752310AbYJ0UgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 16:36:06 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:40151 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752147AbYJ0UgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 16:36:04 -0400
Date: Mon, 27 Oct 2008 16:36:01 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Luciano Rocha <luciano@eurotux.com>
cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>,
       SCSI development list <linux-scsi@vger.kernel.org>
Subject: Re: usb hdd problems with 2.6.27.2
In-Reply-To: <20081027165306.GA3875@bit.office.eurotux.com>
Message-ID: <Pine.LNX.4.44L0.0810271625420.2190-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Oct 2008, Luciano Rocha wrote:

> On Mon, Oct 27, 2008 at 11:38:13AM -0400, Alan Stern wrote:
> > On Mon, 27 Oct 2008, Luciano Rocha wrote:
> > 
> > > Hm, where in the code can I change it to return less that what it thinks
> > > is the last sector?
> > 
> > I can write a patch to do that for you.  However I'm more interested in 
> > solving the "infinite-retry" problem first.

Here's the promised patch.

Alan Stern



Index: usb-2.6/drivers/usb/storage/unusual_devs.h
===================================================================
--- usb-2.6.orig/drivers/usb/storage/unusual_devs.h
+++ usb-2.6/drivers/usb/storage/unusual_devs.h
@@ -1251,6 +1251,13 @@ UNUSUAL_DEV( 0x0839, 0x000a, 0x0001, 0x0
 		US_SC_DEVICE, US_PR_DEVICE, NULL,
 		US_FL_FIX_INQUIRY),
 
+/* Reported by Luciano Rocha <luciano@eurotux.com> */
+UNUSUAL_DEV( 0x0840, 0x0082, 0x0001, 0x0001,
+		"Argosy",
+		"Storage",
+		US_SC_DEVICE, US_PR_DEVICE, NULL,
+		US_FL_FIX_CAPACITY),
+
 /* Entry and supporting patch by Theodore Kilgore <kilgota@auburn.edu>.
  * Flag will support Bulk devices which use a standards-violating 32-byte
  * Command Block Wrapper. Here, the "DC2MEGA" cameras (several brands) with

