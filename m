Return-Path: <linux-kernel-owner+w=401wt.eu-S1754044AbYL0RLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044AbYL0RLr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 12:11:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752730AbYL0RLi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 12:11:38 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:15394 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724AbYL0RLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 12:11:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Z8FGB0FL4DeCo5m5Wga/iuu8a0mMDdvYTed752bWklM8ntYOiTeHaJo1OYsUm0M+jc
         A2ubXeVOuwaN3RARigiW83oe8RXew7SbDRscAphWJpMLCNBCdgfgez2uW9eW/Tg+jiQo
         clMZnPPDgru/fENvJ+BRdok+yg50M08WRcYMs=
Date: Sat, 27 Dec 2008 20:11:22 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org,
       Patrick Boettcher <patrick.boettcher@desy.de>
Subject: Re: [GIT PATCHES for 2.6.28] V4L/DVB fixes, crash in
	af9005_usb_module_init()
Message-ID: <20081227171122.GA20147@localhost>
References: <20081224121252.7560391e@caramujo.chehab.org> <20081225081907.GA4628@elte.hu> <20081225212459.4c7e31b4@caramujo.chehab.org> <20081226090220.GF755@elte.hu> <20081226111324.3fbb804b@caramujo.chehab.org> <20081226132426.GA26953@elte.hu> <20081227164020.GA9726@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081227164020.GA9726@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Sat, Dec 27, 2008 at 05:40:20PM +0100]
| 
| * Ingo Molnar <mingo@elte.hu> wrote:
| 
| > [...] I have re-enabled the driver in tip/master [...]
| 
| ok, just got this build failure:
| 
|  drivers/built-in.o: In function `dm1105_probe':
|  dm1105.c:(.devinit.text+0x2298b): undefined reference to `cx24116_attach'
|  make: *** [.tmp_vmlinux1] Error 1
| 
| config attached. Can test any fix patch.
| 
| 	Ingo
|

Something like that?
 
		- Cyrill -

---
 drivers/media/dvb/frontends/cx24116.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6.git/drivers/media/dvb/frontends/cx24116.h
===================================================================
--- linux-2.6.git.orig/drivers/media/dvb/frontends/cx24116.h
+++ linux-2.6.git/drivers/media/dvb/frontends/cx24116.h
@@ -37,7 +37,8 @@ struct cx24116_config {
 	u8 mpg_clk_pos_pol:0x02;
 };
 
-#if defined(CONFIG_DVB_CX24116) || defined(CONFIG_DVB_CX24116_MODULE)
+#if defined(CONFIG_DVB_CX24116) || \
+	(defined(CONFIG_DVB_CX24116_MODULE) && defined(MODULE))
 extern struct dvb_frontend *cx24116_attach(
 	const struct cx24116_config *config,
 	struct i2c_adapter *i2c);
