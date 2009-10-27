Return-Path: <linux-kernel-owner+w=401wt.eu-S1754918AbZJ0ObF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918AbZJ0ObF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 10:31:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754781AbZJ0ObD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 10:31:03 -0400
Received: from mail.nomovok.com ([83.150.122.238]:44991 "EHLO mail.nomovok.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754689AbZJ0Oa7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 10:30:59 -0400
Subject: [PATCH] hso: fix debug routines
From: Antti =?ISO-8859-1?Q?Kaijanm=E4ki?= <antti.kaijanmaki@nomovok.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Jan Dumon <j.dumon@option.com>
In-Reply-To: <20091026194058.GA25263@kroah.com>
References: <1256200578.3057.113.camel@nomovok.homedomain>
	 <20091026171550.GA24910@kroah.com>
	 <1256585855.3591.52.camel@nomovok.homedomain>
	 <20091026194058.GA25263@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Oct 2009 16:26:55 +0200
Message-ID: <1256653615.3591.113.camel@nomovok.homedomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-26 at 12:40 -0700, Greg KH wrote:
> Yes, that should be a new patch, especially as it would not be needed
> to fix older kernels for the original bug.
> 
> So, care to send 2 patches?  The debug one isn't needed to be sent to
> the stable@kernel.org address.


Signed-off-by: Antti Kaijanmäki <antti.kaijanmaki@nomovok.com>
---
 drivers/net/usb/hso.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index fa4e581..746839b 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -378,7 +378,7 @@ static void dbg_dump(int line_count, const char *func_name, unsigned char *buf,
 }
 
 #define DUMP(buf_, len_)	\
-	dbg_dump(__LINE__, __func__, buf_, len_)
+	dbg_dump(__LINE__, __func__, (unsigned char *)buf_, len_)
 
 #define DUMP1(buf_, len_)			\
 	do {					\
@@ -1527,7 +1527,7 @@ static void tiocmget_intr_callback(struct urb *urb)
 		dev_warn(&usb->dev,
 			 "hso received invalid serial state notification\n");
 		DUMP(serial_state_notification,
-		     sizeof(hso_serial_state_notifation))
+		     sizeof(struct hso_serial_state_notification));
 	} else {
 
 		UART_state_bitmap = le16_to_cpu(serial_state_notification->
-- 
1.6.3.3



