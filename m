Return-Path: <linux-kernel-owner+w=401wt.eu-S1753547AbXJFEeG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547AbXJFEeG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 00:34:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751284AbXJFEd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 00:33:56 -0400
Received: from defg500.nifty.com ([202.248.238.127]:27326 "EHLO
	defg500.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251AbXJFEdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 00:33:55 -0400
X-Greylist: delayed 385 seconds by postgrey-1.27 at vger.kernel.org; Sat, 06 Oct 2007 00:33:55 EDT
DomainKey-Signature: a=rsa-sha1; s=userg502; d=nifty.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:x-mailer:mime-version:
	content-type:content-transfer-encoding;
	b=WFpxqDzmHoL63JA9zYYVoujzYL9enuAg7ZdFQL+o84EggX0ip2WX+t5enxtq9U15e
	cDLRyi5oks5J6hToneP/g==
X-Nifty-SrcIP: [220.145.30.228]
Date: Sat, 6 Oct 2007 13:26:01 +0900
From: Komuro <komurojun@nifty.com>
To: linux-kernel@vger.kernel.org
Cc: linas@austin.ibm.com
Subject: RE: [PATCH] Simplify yenta code
Message-Id: <20071006132601.f944f461.komurojun@nifty.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Unfortunately, your patch is wrong,
and does not results in the same run-time behaviour.

You broke the code of "if (type & IORESOURCE_IO)"
 

Best Regards
Komuro


>Simplify some of the resource detection logic in yenta_socket.
>This patch results in the same run-time behaviour as the 
>current code, but does so with fewer lines of code. This
>makes the logical flow of the code a bit easier to understand.
>
>Signed-off-by: Linas Vepstas <linas@austin.ibm.com>
>Cc: Dominik Brodowski <linux@brodo.de>
>
>----
> drivers/pcmcia/yenta_socket.c |   22 ++++++++--------------
> 1 file changed, 8 insertions(+), 14 deletions(-)
>
>Index: linux-2.6.23-rc8-mm1/drivers/pcmcia/yenta_socket.c
>===================================================================
>--- linux-2.6.23-rc8-mm1.orig/drivers/pcmcia/yenta_socket.c	2007-10-01 >12:17:02.000000000 -0500
>+++ linux-2.6.23-rc8-mm1/drivers/pcmcia/yenta_socket.c	2007-10-01 12:37:36.000000000 >-0500
>@@ -654,20 +654,14 @@ static int yenta_allocate_res(struct yen
> 				pci_name(socket->dev), nr);
> 	}
> 
>-	if (type & IORESOURCE_IO) {
>-		if ((yenta_search_res(socket, res, BRIDGE_IO_MAX)) ||
>-		    (yenta_search_res(socket, res, BRIDGE_IO_ACC)) ||
>-		    (yenta_search_res(socket, res, BRIDGE_IO_MIN)))
>-			return 1;
>-	} else {
>-		if (type & IORESOURCE_PREFETCH) {
>-			if ((yenta_search_res(socket, res, BRIDGE_MEM_MAX)) ||
>-			    (yenta_search_res(socket, res, BRIDGE_MEM_ACC)) ||
>-			    (yenta_search_res(socket, res, BRIDGE_MEM_MIN)))
>-				return 1;
>-			/* Approximating prefetchable by non-prefetchable */
>-			res->flags = IORESOURCE_MEM;
>-		}
>+	if ((yenta_search_res(socket, res, BRIDGE_MEM_MAX)) ||
>+	    (yenta_search_res(socket, res, BRIDGE_MEM_ACC)) ||
>+	    (yenta_search_res(socket, res, BRIDGE_MEM_MIN)))
>+		return 1;
>+
>+	if (type & IORESOURCE_PREFETCH) {
>+		/* Approximating prefetchable by non-prefetchable */
>+		res->flags = IORESOURCE_MEM;
> 		if ((yenta_search_res(socket, res, BRIDGE_MEM_MAX)) ||
> 		    (yenta_search_res(socket, res, BRIDGE_MEM_ACC)) ||
> 		    (yenta_search_res(socket, res, BRIDGE_MEM_MIN)))
>-
