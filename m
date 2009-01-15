Return-Path: <linux-kernel-owner+w=401wt.eu-S1763836AbZAOKbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763836AbZAOKbr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 05:31:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759900AbZAOKbg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 05:31:36 -0500
Received: from mail.openmoko.org ([88.198.124.205]:60156 "EHLO
	mail.openmoko.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759302AbZAOKbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 05:31:36 -0500
Date: Thu, 15 Jan 2009 16:01:13 +0530
From: Balaji Rao <balajirrao@openmoko.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: CONFIG_MFD_PCF50633=m breaks the kernel build
Message-ID: <20090115103112.GC3199@fedora.yogi>
References: <20090115100653.509416fb@hyperion.delvare> <20090115091107.GB3199@fedora.yogi> <20090115110955.4a8e9c5b@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090115110955.4a8e9c5b@hyperion.delvare>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2009 at 11:09:55AM +0100, Jean Delvare wrote:
> On Thu, 15 Jan 2009 14:41:08 +0530, Balaji Rao wrote:
> > On Thu, Jan 15, 2009 at 10:06:53AM +0100, Jean Delvare wrote:
> > > Hi Balaji,
> > > 
> > > Building kernel 2.6.29-rc1-git4 on x86_64 with CONFIG_MFD_PCF50633=m
> > > fails at linking time with:
> > > 
> > > ERROR: "__set_irq_handler" [drivers/mfd/pcf50633-core.ko] undefined!
> > > ERROR: "handle_level_irq" [drivers/mfd/pcf50633-core.ko] undefined!
> > 
> > Yes, I've seen this. The fix is waiting on linux-mfd to be pulled
> > anytime soon.
> 
> Where is linux-mfd? And what is it, a git tree, a mailing list? I
> couldn't find any reference.

It's a git tree at http://git.o-hand.com/cgit.cgi/linux-mfd/

> 
> Can you please send me the patch now, so that I can fix my build
> locally right now?
> 

    pcf50633: Remove references to non-exported functions
    
    Remove references to set_irq_type and handle_level_irq which are not
    exported to modules.
    
    Signed-off-by: Balaji Rao <balajirrao@openmoko.org>

diff --git a/drivers/mfd/pcf50633-core.c b/drivers/mfd/pcf50633-core.c
index 24508e2..ea9488e 100644
--- a/drivers/mfd/pcf50633-core.c
+++ b/drivers/mfd/pcf50633-core.c
@@ -626,7 +626,6 @@ static int __devinit pcf50633_probe(struct i2c_client *client,
 	}
 
 	if (client->irq) {
-		set_irq_handler(client->irq, handle_level_irq);
 		ret = request_irq(client->irq, pcf50633_irq,
 				IRQF_TRIGGER_LOW, "pcf50633", pcf);
 
