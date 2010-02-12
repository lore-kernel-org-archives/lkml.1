Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867Ab0BLH4V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 02:56:21 -0500
Received: from www84.your-server.de ([213.133.104.84]:54464 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688Ab0BLH4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 02:56:20 -0500
Subject: Re: [PATCH 1/4] fix kfifo miss use of nozami.c
From: Stefani Seibold <stefani@seibold.net>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       "Ira W. Snyder" <iws@ovro.caltech.edu>
In-Reply-To: <1265961158.32651.9.camel@wall-e>
References: <1265961158.32651.9.camel@wall-e>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 12 Feb 2010 08:56:20 +0100
Message-ID: <1265961380.32651.13.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

User of the kernel fifo should never bypass the API and directly access
the fifo structure. Otherwise it will be very hard to maintain the API.

Signed-off-by: Stefani Seibold <stefani@seibold.net>
---
 drivers/char/nozomi.c                 |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -u -N -r -p linux-2.6.33-rc7.dummy/drivers/char/nozomi.c linux-2.6.33-rc7.new/drivers/char/nozomi.c
--- linux-2.6.33-rc7.dummy/drivers/char/nozomi.c	2010-02-11 17:05:50.670990421 +0100
+++ linux-2.6.33-rc7.new/drivers/char/nozomi.c	2010-02-11 17:11:20.350865181 +0100
@@ -1743,7 +1743,7 @@ static int ntty_write_room(struct tty_st
 	if (!port->port.count)
 		goto exit;
 
-	room = port->fifo_ul.size - kfifo_len(&port->fifo_ul);
+	room = kfifo_avail(&port->fifo_ul);
 
 exit:
 	mutex_unlock(&port->tty_sem);


