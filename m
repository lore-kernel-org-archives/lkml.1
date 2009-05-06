Return-Path: <linux-kernel-owner+w=401wt.eu-S1757123AbZEFWPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757123AbZEFWPx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 18:15:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761598AbZEFVzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 17:55:13 -0400
Received: from kroah.org ([198.145.64.141]:57383 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761570AbZEFVzB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 17:55:01 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed May  6 14:48:02 2009
Message-Id: <20090506214801.962120844@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 06 May 2009 14:46:16 -0700
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
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [patch 48/58] cs5536: define dma_sff_read_status() method
References: <20090506214528.660389067@mini.kroah.org>
Content-Disposition: inline; filename=cs5536-define-dma_sff_read_status-method.patch
In-Reply-To: <20090506215017.GA21981@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Sergei Shtylyov <sshtylyov@ru.mvista.com>

commit 15da90b516e9da92cc1d90001e640fd6707d0e27 upstream.

The driver somehow got merged with the initializer for the dma_sff_read_status()
method missing which caused kernel panic on bootup.

This should fix the kernel.org bug #13026...

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Reported-by: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 drivers/ide/cs5536.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/ide/cs5536.c
+++ b/drivers/ide/cs5536.c
@@ -237,6 +237,7 @@ static const struct ide_dma_ops cs5536_d
 	.dma_test_irq		= ide_dma_test_irq,
 	.dma_lost_irq		= ide_dma_lost_irq,
 	.dma_timeout		= ide_dma_timeout,
+	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
 
 static const struct ide_port_info cs5536_info = {


