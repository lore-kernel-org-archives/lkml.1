Return-Path: <linux-kernel-owner+w=401wt.eu-S1755878AbYHPIHP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878AbYHPIHP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 04:07:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752119AbYHPIG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 04:06:58 -0400
Received: from mail.ukfsn.org ([77.75.108.10]:53175 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751961AbYHPIG4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 04:06:56 -0400
Date: Sat, 16 Aug 2008 09:06:54 +0100
From: Nick Warne <nick@ukfsn.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] Fixup KERN_INFO in tmscsim.c
Message-ID: <20080816090654.4a5188e2@sauron.linicks.net>
In-Reply-To: <Pine.LNX.4.64.0808152202440.7852@axis700.grange>
References: <20080815121045.48ca37e4@sauron.linicks.net>
 <Pine.LNX.4.64.0808152202440.7852@axis700.grange>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Aug 2008 22:17:57 +0200 (CEST)
Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:

> On Fri, 15 Aug 2008, Nick Warne wrote:
> Wow, are you sure you need the tmscsim driver on your new amd64
> system?:-)

I don't know :-)  A new distro (Slackware 12.1) has almost everything
set as modules, so I am currently building new kernel removing them as I
go - just the first couple of log scans revealed this...

> I do not know why your
> syslogd / klogd converts a TAB to "^I". 

Mystery to me too...

> So, please, redo as above, create with "-p1" format, fix your Sob line

Thanks.

Nick

New patch attached.

Signed off by: Nick Warne nick@ukfsn.org

--- linux-2.6.26.y/drivers/scsi/tmscsim.cORIG	2008-08-15 10:30:47.000000000 +0100
+++ linux-2.6.26.y/drivers/scsi/tmscsim.c	2008-08-16 08:45:43.000000000 +0100
@@ -2573,8 +2573,8 @@
 static int __init dc390_module_init(void)
 {
 	if (!disable_clustering)
-		printk(KERN_INFO "DC390: clustering now enabled by default. If you get problems load\n"
-		       "\twith \"disable_clustering=1\" and report to maintainers\n");
+		printk(KERN_INFO "DC390: clustering now enabled by default. If you get problems load\n");
+		printk(KERN_INFO "	with \"disable_clustering=1\" and report to maintainers\n");
 
 	if (tmscsim[0] == -1 || tmscsim[0] > 15) {
 		tmscsim[0] = 7;


-- 
Free Software Foundation Associate Member 5508
