Return-Path: <linux-kernel-owner+w=401wt.eu-S1752784AbZKJHy7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784AbZKJHy7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 02:54:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752603AbZKJHy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 02:54:58 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57682 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870AbZKJHy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 02:54:58 -0500
Date: Tue, 10 Nov 2009 08:54:11 +0100
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>, gregkh@suse.de,
       KMoorman@transy.edu, w.sang@pengutronix.de,
       ken_kawasaki@spring.nifty.jp, davem@davemloft.net,
       Andrew Morton <akpm@osdl.org>, alan@lxorguk.ukuu.org.uk
Subject: serial_cs: oxsemi quirk breaks resume
Message-ID: <20091110075410.GA6157@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Quirk is applied on all cards with given manfid (is it that
correct?). Unfortunately, that quirk breaks resume on zaurus with
billionton bluetooth card inserted: c950ctrl is 0 and outb() faults.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

--- a/drivers/serial/serial_cs.c	2009-10-06 13:51:46.000000000 +0200
+++ b/drivers/serial/serial_cs.c	2009-11-09 14:43:25.000000000 +0100
@@ -158,7 +158,8 @@
 {
 	struct serial_info *info = link->priv;
 
-	outb(12, info->c950ctrl + 1);
+	if (info->c950ctrl)
+		outb(12, info->c950ctrl + 1);
 }
 
 /* request_region? oxsemi branch does no request_region too... */


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
