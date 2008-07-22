Return-Path: <linux-kernel-owner+w=401wt.eu-S1758781AbYGVX0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758781AbYGVX0m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 19:26:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757058AbYGVXTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 19:19:40 -0400
Received: from ns2.suse.de ([195.135.220.15]:57792 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757047AbYGVXTj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 19:19:39 -0400
Date: Tue, 22 Jul 2008 16:16:19 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Will Newton <will.newton@gmail.com>
Subject: [patch 25/47] sisusbvga: Fix oops on disconnect.
Message-ID: <20080722231619.GZ8282@suse.de>
References: <20080722230208.148102983@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sisusbvga-fix-oops-on-disconnect.patch"
In-Reply-To: <20080722231342.GA8282@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Will Newton <will.newton@gmail.com>

commit f15e39739a1d7dfaa2173a91707a74c11a246648 upstream

Remove dev_info call on disconnect. The sisusb_dev pointer may have been
set to zero by sisusb_delete at this point causing an oops.

The message does not provide any extra information over the standard USB
subsystem output so removing it does not affect functionality.

Signed-off-by: Will Newton <will.newton@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/misc/sisusbvga/sisusb.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/usb/misc/sisusbvga/sisusb.c
+++ b/drivers/usb/misc/sisusbvga/sisusb.c
@@ -3264,8 +3264,6 @@ static void sisusb_disconnect(struct usb
 
 	/* decrement our usage count */
 	kref_put(&sisusb->kref, sisusb_delete);
-
-	dev_info(&sisusb->sisusb_dev->dev, "Disconnected\n");
 }
 
 static struct usb_device_id sisusb_table [] = {

-- 
