Return-Path: <linux-kernel-owner+w=401wt.eu-S1754334AbYL0RTp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334AbYL0RTp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 12:19:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753042AbYL0RTh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 12:19:37 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:7495 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010AbYL0RTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 12:19:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=KFXZsErouDHj/IDbbZqL7U1CaEMfOJoSMLZFIkCFR8W5MSejVP3Ti3Bv4tyrviqkLW
         6K2GxSu62D6Q8/sbGsKtDADiTR0PvxC2QbgwighYlwOoaVlqzvjZgvN//9eHzLiVcFUW
         GTjGBfiTb16RcgLUuQsUnZ/jGqd3/LQ7Deq8g=
Date: Sat, 27 Dec 2008 20:19:33 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Mauro Carvalho Chehab <mchehab@redhat.com>,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org,
       Patrick Boettcher <patrick.boettcher@desy.de>
Subject: Re: [GIT PATCHES for 2.6.28] V4L/DVB fixes, crash in
	af9005_usb_module_init()
Message-ID: <20081227171933.GB20147@localhost>
References: <20081224121252.7560391e@caramujo.chehab.org> <20081225081907.GA4628@elte.hu> <20081225212459.4c7e31b4@caramujo.chehab.org> <20081226090220.GF755@elte.hu> <20081226111324.3fbb804b@caramujo.chehab.org> <20081226132426.GA26953@elte.hu> <20081227164020.GA9726@elte.hu> <20081227171122.GA20147@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081227171122.GA20147@localhost>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cyrill Gorcunov - Sat, Dec 27, 2008 at 08:11:22PM +0300]
| [Ingo Molnar - Sat, Dec 27, 2008 at 05:40:20PM +0100]
| | 
| | * Ingo Molnar <mingo@elte.hu> wrote:
| | 
| | > [...] I have re-enabled the driver in tip/master [...]
| | 
| | ok, just got this build failure:
| | 
| |  drivers/built-in.o: In function `dm1105_probe':
| |  dm1105.c:(.devinit.text+0x2298b): undefined reference to `cx24116_attach'
| |  make: *** [.tmp_vmlinux1] Error 1
| | 
| | config attached. Can test any fix patch.
| | 
| | 	Ingo
| |
| 
| Something like that?
|  
| 		- Cyrill -
| 
| ---
|  drivers/media/dvb/frontends/cx24116.h |    3 ++-
|  1 file changed, 2 insertions(+), 1 deletion(-)
| 
| Index: linux-2.6.git/drivers/media/dvb/frontends/cx24116.h
| ===================================================================
| --- linux-2.6.git.orig/drivers/media/dvb/frontends/cx24116.h
| +++ linux-2.6.git/drivers/media/dvb/frontends/cx24116.h
| @@ -37,7 +37,8 @@ struct cx24116_config {
|  	u8 mpg_clk_pos_pol:0x02;
|  };
|  
| -#if defined(CONFIG_DVB_CX24116) || defined(CONFIG_DVB_CX24116_MODULE)
| +#if defined(CONFIG_DVB_CX24116) || \
| +	(defined(CONFIG_DVB_CX24116_MODULE) && defined(MODULE))
|  extern struct dvb_frontend *cx24116_attach(
|  	const struct cx24116_config *config,
|  	struct i2c_adapter *i2c);

hmm... don't think it will help, please ignore the patch.

		- Cyrill -
