Return-Path: <linux-kernel-owner+w=401wt.eu-S1756090AbXL2Cc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090AbXL2Cc5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 21:32:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754240AbXL2Cct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 21:32:49 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:49779 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753274AbXL2Cct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 21:32:49 -0500
Date: Sat, 29 Dec 2007 02:23:29 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Jiri Slaby <jirislaby@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Adrian Bunk <bunk@kernel.org>, Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: [PATCH 1/1] mxser, remove it
Message-ID: <20071229022329.39f6162a@the-village.bc.nu>
In-Reply-To: <Pine.LNX.4.64.0712290211240.29013@fbirervta.pbzchgretzou.qr>
References: <1198836540-8042-1-git-send-email-jirislaby@gmail.com>
	<Pine.LNX.4.64.0712290211240.29013@fbirervta.pbzchgretzou.qr>
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> >+static int mxvar_baud_table[] = {
> >+	0, 50, 75, 110, 134, 150, 200, 300, 600, 1200, 1800, 2400,
> >+	4800, 9600, 19200, 38400, 57600, 115200, 230400, 460800, 921600
> >+};
> >+static unsigned int mxvar_baud_table1[] = {
> >+	0, B50, B75, B110, B134, B150, B200, B300, B600, B1200, B1800, B2400,
> >+	B4800, B9600, B19200, B38400, B57600, B115200, B230400, B460800, B921600
> >+};
> 
> Constify both, if possible?

These are not portable - baud rate tables vary for some platforms. No
driver should be touching Bxxx coding itself any more. Use the tty_
functions to decode and encode baud rates.

