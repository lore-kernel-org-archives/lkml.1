Return-Path: <linux-kernel-owner+w=401wt.eu-S1757786AbZFCIOG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757786AbZFCIOG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 04:14:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755779AbZFCINw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 04:13:52 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:38204 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755088AbZFCINv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 04:13:51 -0400
Date: Wed, 3 Jun 2009 18:13:45 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Mark Adamson <mark.adamson@ftdichip.com>
Subject: linux-next: manual merge of the usb tree with the ttydev tree
Message-Id: <20090603181345.0e6ae020.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Today's linux-next merge of the usb tree got a conflict in
drivers/usb/serial/ftdi_sio.c between commit
436d74ab8174ba48ad97c3de80c8de6aaff6c931 ("tty-usb-ft232-latency") from
the ttydev tree and commit ac0ceefdc8cdf4bbe6cdaf6d2175e0dfdbfd6700
("USB: ftdi_sio: fix hi-speed device packet size calculation") from the
usb tree.

Overlapping additions.  I fixed it up (see below), but have no idea if
there are higher level interactions (or the ordering is right) i.e.
please check this.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/usb/serial/ftdi_sio.c
index 59c7501,ec20993..0000000
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@@ -1417,7 -1500,7 +1524,8 @@@ static int ftdi_sio_port_probe(struct u
  	usb_set_serial_port_data(port, priv);
  
  	ftdi_determine_type(port);
 +	read_latency_timer(port);
+ 	ftdi_set_max_packet_size(port);
  	create_sysfs_attrs(port);
  	return 0;
  }
