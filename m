Return-Path: <linux-kernel-owner+w=401wt.eu-S1753421AbXLDKd5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421AbXLDKd5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 05:33:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752392AbXLDKdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 05:33:50 -0500
Received: from twin.jikos.cz ([213.151.79.26]:51838 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752246AbXLDKdt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 05:33:49 -0500
Date: Tue, 4 Dec 2007 11:32:53 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Patrick Boettcher <pb@linuxtv.org>,
       Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [build bug] undefined reference to `dib3000mc_get_tuner_i2c_master'
In-Reply-To: <20071204083904.GA15694@elte.hu>
Message-ID: <Pine.LNX.4.64.0712041130310.16564@twin.jikos.cz>
References: <20071204083904.GA15694@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Dec 2007, Ingo Molnar wrote:

> with the attached config i get this build failure:
>  drivers/built-in.o: In function `dibusb_dib3000mc_tuner_attach':
>  : undefined reference to `dib3000mc_get_tuner_i2c_master'
>  drivers/built-in.o: In function `dibusb_dib3000mc_tuner_attach':
>  : undefined reference to `dib3000mc_set_config'
> on 2.6.24-rc-latest.

Hmm, seems like -common part contains also code that is not completely 
common to all the modules.

How about this?



From: Jiri Kosina <jkosina@suse.cz>

DVB: Compile 3000MC-specific DIB code only for CONFIG_DVB_DIB3000MC

Signed-off-by: Jiri Kosina <jkosina@suse.cz>

diff --git a/drivers/media/dvb/dvb-usb/dibusb-common.c b/drivers/media/dvb/dvb-usb/dibusb-common.c
index 9a184da..b95b1eb 100644
--- a/drivers/media/dvb/dvb-usb/dibusb-common.c
+++ b/drivers/media/dvb/dvb-usb/dibusb-common.c
@@ -223,6 +223,7 @@ static struct dibx000_agc_config dib3000p_panasonic_agc_config = {
 	.agc2_slope2 = 0x1e,
 };
 
+#ifdef CONFIG_DVB_DIB3000MC
 static struct dib3000mc_config mod3000p_dib3000p_config = {
 	&dib3000p_panasonic_agc_config,
 
@@ -305,6 +306,7 @@ int dibusb_dib3000mc_tuner_attach(struct dvb_usb_adapter *adap)
 	return 0;
 }
 EXPORT_SYMBOL(dibusb_dib3000mc_tuner_attach);
+#endif
 
 /*
  * common remote control stuff
