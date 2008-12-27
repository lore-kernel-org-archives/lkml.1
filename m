Return-Path: <linux-kernel-owner+w=401wt.eu-S1754250AbYL0SBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250AbYL0SBq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 13:01:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753211AbYL0SBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 13:01:38 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:17829 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186AbYL0SBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 13:01:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=P+qOTTsw+uOVv3MCZAdMFORwL2lpAWuUgm82a+PKHe41gg9ahSXXJ1iikA7zmirNp2
         C6bYwv882vFuCtgLnbsm5D/qUUcZBXBRvDOvogJZPcfMbWqbjwyrVKXg+yjOhbabneGc
         nyitZbgQIZVrXVo45gn0nTe2Mw0WVkEkECXi8=
Date: Sat, 27 Dec 2008 21:01:34 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Mauro Carvalho Chehab <mchehab@redhat.com>,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org,
       Patrick Boettcher <patrick.boettcher@desy.de>
Subject: Re: [GIT PATCHES for 2.6.28] V4L/DVB fixes, crash in
	af9005_usb_module_init()
Message-ID: <20081227180134.GA32430@localhost>
References: <20081224121252.7560391e@caramujo.chehab.org> <20081225081907.GA4628@elte.hu> <20081225212459.4c7e31b4@caramujo.chehab.org> <20081226090220.GF755@elte.hu> <20081226111324.3fbb804b@caramujo.chehab.org> <20081226132426.GA26953@elte.hu> <20081227164020.GA9726@elte.hu> <20081227171122.GA20147@localhost> <20081227171933.GB20147@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081227171933.GB20147@localhost>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cyrill Gorcunov - Sat, Dec 27, 2008 at 08:19:33PM +0300]
...
| | | config attached. Can test any fix patch.
| | | 
| | | 	Ingo
| | |
| | 
| | Something like that?
| |  
| | 		- Cyrill -
| | 
| | ---
| |  drivers/media/dvb/frontends/cx24116.h |    3 ++-
| |  1 file changed, 2 insertions(+), 1 deletion(-)
| | 
| | Index: linux-2.6.git/drivers/media/dvb/frontends/cx24116.h
| | ===================================================================
| | --- linux-2.6.git.orig/drivers/media/dvb/frontends/cx24116.h
| | +++ linux-2.6.git/drivers/media/dvb/frontends/cx24116.h
| | @@ -37,7 +37,8 @@ struct cx24116_config {
| |  	u8 mpg_clk_pos_pol:0x02;
| |  };
| |  
| | -#if defined(CONFIG_DVB_CX24116) || defined(CONFIG_DVB_CX24116_MODULE)
| | +#if defined(CONFIG_DVB_CX24116) || \
| | +	(defined(CONFIG_DVB_CX24116_MODULE) && defined(MODULE))
| |  extern struct dvb_frontend *cx24116_attach(
| |  	const struct cx24116_config *config,
| |  	struct i2c_adapter *i2c);
| 
| hmm... don't think it will help, please ignore the patch.
| 
| 		- Cyrill -

Heh, actually it should help I believe (i don't know how it possible
but I forgot about -D gcc option and was searching for MODULE
definition, need some coffee :)

		- Cyrill -
