Return-Path: <linux-kernel-owner+w=401wt.eu-S1753114AbYIUBLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753114AbYIUBLx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 21:11:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751715AbYIUBLo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 21:11:44 -0400
Received: from fk-out-0910.google.com ([209.85.128.184]:31472 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507AbYIUBLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 21:11:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=mQqjFnuh/OMkqjewC/idraCSoXldpPjSbjDQzFtuYOpAYksFQSRK/JpEr6ogJQ3pPO
         7uWB47empOwu6EvHikTQL8ZlEGAJqzBQDeJaWrvV7hp4nM8crf8qaDkJMXik6aQwYYJG
         J2sw3+TSqkCuLwXNodxCE/+tCw/DAoi8UYK4A=
Date: Sun, 21 Sep 2008 05:11:31 +0400
From: Alexander Beregalov <a.beregalov@gmail.com>
To: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
       alan@lxorguk.ukuu.org.uk
Subject: [PATCH] serial_core: fix printk format warnings
Message-ID: <20080921011131.GA16153@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/serial/serial_core.c:2158: warning: format '%x' expects type
'unsigned int', but argument 4 has type 'long unsigned int'
drivers/serial/serial_core.c:2162: warning: format '%x' expects type
'unsigned int', but argument 4 has type 'long unsigned int

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---

 drivers/serial/serial_core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
index effd0bd..d531ae9 100644
--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -2155,11 +2155,11 @@ uart_report_port(struct uart_driver *drv, struct uart_port *port)
 	switch (port->iotype) {
 	case UPIO_PORT:
 		snprintf(address, sizeof(address),
-			 "I/O 0x%x", port->iobase);
+			 "I/O 0x%lx", port->iobase);
 		break;
 	case UPIO_HUB6:
 		snprintf(address, sizeof(address),
-			 "I/O 0x%x offset 0x%x", port->iobase, port->hub6);
+			 "I/O 0x%lx offset 0x%x", port->iobase, port->hub6);
 		break;
 	case UPIO_MEM:
 	case UPIO_MEM32:
