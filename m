Return-Path: <linux-kernel-owner+w=401wt.eu-S1757351AbZEPD3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757351AbZEPD3i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 23:29:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755448AbZEPD3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 23:29:30 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:15075 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755390AbZEPD33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 23:29:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=eo4KIAaMJCLjUxYstB92gcwPbNcj6GSFKbjp6B4AFLR1F3DI4o+6Ucq6ZczTjXLtdE
         p9NFX2lrGRrnJVg4ukP41Kjc+/ho3H+WaI3iTiqtj1e0RVjvcXCAct7zMsvCenGMj/MF
         Blcjq0+oPzlre4A78z07/Lbudd0yEnMI7k07Q=
Date: Fri, 15 May 2009 20:29:24 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: linux-kernel@vger.kernel.org,
       Alan Jenkins <sourcejedi.lkml@googlemail.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: EeePC 900 trackpad often not detected at boot in 2.6.30-rc4
Message-ID: <20090516032924.GD12099@dtor-d630.eng.vmware.com>
References: <20090511072135.GA4682@sucs.org> <20090513032053.GA29919@dtor-d630.eng.vmware.com> <20090513185356.GA20140@sucs.org> <20090513191953.GA10629@sucs.org> <20090516032754.GC12099@dtor-d630.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090516032754.GC12099@dtor-d630.eng.vmware.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 15, 2009 at 08:27:55PM -0700, Dmitry Torokhov wrote:
> On Wed, May 13, 2009 at 08:19:53PM +0100, Sitsofe Wheeler wrote:
> > Hi,
> > 
> > > On Tue, May 12, 2009 at 08:20:54PM -0700, Dmitry Torokhov wrote:
> > > > 
> > > > Could you try booting with i8042.debug and send me dmesg of the case
> > 
> > See below:
> > 
> 
> Thanks. I have an idea what is happening... Could you please attach the
> debug patch below and give me debug dmesg of the failure again? Thanks!
> 
> -- 
> Dmitry

And now... *drumroll* ...the patch!

-- 
Dmitry


Input: libps2 - debug patch

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/serio/libps2.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)


diff --git a/drivers/input/serio/libps2.c b/drivers/input/serio/libps2.c
index a0d8968..4938adc 100644
--- a/drivers/input/serio/libps2.c
+++ b/drivers/input/serio/libps2.c
@@ -208,6 +208,9 @@ int __ps2_command(struct ps2dev *ps2dev, unsigned char *param, int command)
 	timeout = wait_event_timeout(ps2dev->wait,
 				     !(ps2dev->flags & PS2_FLAG_CMD1), timeout);
 
+	if (ps2dev->cmdcnt && timeout <= 0 && !(ps2dev->flags & PS2_FLAG_CMD1))
+		printk(KERN_ERR "libps2: errorneously fail %d command\n", command);
+
 	if (ps2dev->cmdcnt && timeout > 0) {
 
 		timeout = ps2_adjust_timeout(ps2dev, command, timeout);
