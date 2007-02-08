Return-Path: <linux-kernel-owner+w=401wt.eu-S1423456AbXBHWq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423456AbXBHWq5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 17:46:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423459AbXBHWq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 17:46:57 -0500
Received: from twin.jikos.cz ([213.151.79.26]:37933 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423456AbXBHWq5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 17:46:57 -0500
Date: Thu, 8 Feb 2007 23:45:43 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: Jeff Garzik <jeff@garzik.org>
cc: Greg KH <greg@kroah.com>, hjlipp@web.de, tilman@imap.cc,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: gigaset build broken on current linux-2.6.git
In-Reply-To: <45CBA41D.3000406@garzik.org>
Message-ID: <Pine.LNX.4.64.0702082344100.25686@twin.jikos.cz>
References: <45CBA41D.3000406@garzik.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Feb 2007, Jeff Garzik wrote:

> [jgarzik@pretzel linux-2.6]$ make -sj4
>   CHK     include/linux/version.h
>   CHK     include/linux/utsrelease.h
>   CHK     include/linux/compile.h
> drivers/isdn/gigaset/bas-gigaset.c: In function 'dump_urb':
> drivers/isdn/gigaset/bas-gigaset.c:258: error: 'struct urb' has no member
> named 'bandwidth'

ISDN: gigaset - remove forgotten urb->bandwidth reference

Recent changes in usbcore removed the bandwidth field from struct urb.
Remove the forgotten occurence in bas-gigaset.c

Signed-off-by: Jiri Kosina <jkosina@suse.cz>

---

 drivers/isdn/gigaset/bas-gigaset.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/isdn/gigaset/bas-gigaset.c b/drivers/isdn/gigaset/bas-gigaset.c
index b5e7f9c..63e51dd 100644
--- a/drivers/isdn/gigaset/bas-gigaset.c
+++ b/drivers/isdn/gigaset/bas-gigaset.c
@@ -257,10 +257,10 @@ static inline void dump_urb(enum debuglevel level, const char *tag,
 			urb->transfer_flags);
 		gig_dbg(level,
 			"  transfer_buffer=0x%08lx[%d], actual_length=%d, "
-			"bandwidth=%d, setup_packet=0x%08lx,",
+			"setup_packet=0x%08lx,",
 			(unsigned long) urb->transfer_buffer,
 			urb->transfer_buffer_length, urb->actual_length,
-			urb->bandwidth, (unsigned long) urb->setup_packet);
+			(unsigned long) urb->setup_packet);
 		gig_dbg(level,
 			"  start_frame=%d, number_of_packets=%d, interval=%d, "
 			"error_count=%d,",

-- 
Jiri Kosina
