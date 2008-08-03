Return-Path: <linux-kernel-owner+w=401wt.eu-S1754481AbYHCJHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481AbYHCJHs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 05:07:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751794AbYHCJHj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 05:07:39 -0400
Received: from sh-spam-4.gradwell.net ([193.84.87.110]:46482 "EHLO
	sh-spam-4.gradwell.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbYHCJHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 05:07:38 -0400
Date: Sun, 3 Aug 2008 10:07:06 +0100
From: Alex Buell <alex.buell@munted.org.uk>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-kernel@vger.kernel.org, Robert Hancock <hancockr@shaw.ca>,
       Tomas Styblo <tripie@cpan.org>, <linux-usb@vger.kernel.org>,
       <usb-storage@lists.one-eyed-alien.net>
Subject: Re: [PATCH] JMicron JM20337 USB-SATA data corruption bugfix -
 device 152d:2338
Message-Id: <20080803100706.5e52ce90.alex.buell@munted.org.uk>
In-Reply-To: <Pine.LNX.4.44L0.0808021948240.18555-100000@netrider.rowland.org>
References: <20080801232240.d24166de.alex.buell@munted.org.uk>
	<Pine.LNX.4.44L0.0808021948240.18555-100000@netrider.rowland.org>
Organization: One tortoiseshell cat, very high maintenance
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; i686-pc-linux-gnu)
X-Face: "wUuhsy:X)M;>-dA\j"&y@*\$91]iX10Iv1WG_oNbGYpo,eqc06O?"VSeRTx]xM\LiITUh01z}<|GF/4Gzz(MAU~;p4AS,%TB69M:vB-9+i'#W7$UQCW&UP#zt{VdLlzEiw8k~jL<
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 Aug 2008 19:49:22 -0400 (EDT), I waved a wand and this
message magically appears in front of Alan Stern:

> > > I've done a lot of mkfs and fsck, haven't seen any problems so
> > > far. Fingers crossed that this patch works. 
> > 
> > Spoke too soon, that patch that was posted doesn't work for me.
> > Here's my log:
> 
> Which patch?  Several different ones have been posted.

This is the one that I applied:
Index: usb-2.6/drivers/usb/storage/transport.c
===================================================================
--- usb-2.6.orig/drivers/usb/storage/transport.c
+++ usb-2.6/drivers/usb/storage/transport.c
@@ -663,7 +663,7 @@ void usb_stor_invoke_transport(struct sc
 	}
 
 	/* Did we transfer less than the minimum amount required? */
-	if (srb->result == SAM_STAT_GOOD &&
+	if ((srb->result == SAM_STAT_GOOD || srb->sense_buffer[2] == 0) && scsi_bufflen(srb) - scsi_get_resid(srb) < srb->underflow)
 		srb->result = (DID_ERROR << 16) | (SUGGEST_RETRY << 24); 

> The log doesn't provide much help.  We need to see a log with 
> CONFIG_USB_STORAGE_DEBUG enabled.

Which patch should I be trying out? 

Thanks,
Alex
-- 
http://www.munted.org.uk

Fearsome grindings.
