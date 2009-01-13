Return-Path: <linux-kernel-owner+w=401wt.eu-S1759918AbZAMGYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759918AbZAMGYn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 01:24:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753846AbZAMGYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 01:24:30 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:52428 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752662AbZAMGY3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 01:24:29 -0500
Date: Tue, 13 Jan 2009 17:24:22 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus <torvalds@linux-foundation.org>
Cc: Samuel Ortiz <sameo@openedhand.com>, linux-next@vger.kernel.org,
       Balaji Rao <balajirrao@openmoko.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: mfd tree build failure
Message-Id: <20090113172422.fdde0d69.sfr@canb.auug.org.au>
In-Reply-To: <20090112100753.GA21301@fedora.yogi>
References: <20090112140318.e25cd2bf.sfr@canb.auug.org.au>
	<20090112100753.GA21301@fedora.yogi>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Mon, 12 Jan 2009 15:37:55 +0530 Balaji Rao <balajirrao@openmoko.org> wrote:
>
> On Mon, Jan 12, 2009 at 02:03:18PM +1100, Stephen Rothwell wrote:
> > 
> > Today's linux-next build (x86_64 allmodconfig) failed like this:
> > 
> > ERROR: "__set_irq_handler" [drivers/mfd/pcf50633-core.ko] undefined!
> > ERROR: "handle_level_irq" [drivers/mfd/pcf50633-core.ko] undefined!
> > 
> > Immediate cause is clearly commit
> > f52046b14b1e1a8a02ae48d0c69d39c5e204644f ("mfd: PCF50633 core driver")
> > which introduces this code.  The above functions don't appear to be
> > exported to modules.
> > 
> > I have dropped the mfd tree for today.
> 
> Oh, sorry about this. I can actually do without this. Here's the patch.
> Sameo, can you please apply it ?

This is now in the upstream kernel tree ...

---------------------------------------------------------------------------
From: Balaji Rao <balajirrao@openmoko.org>

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
 

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
