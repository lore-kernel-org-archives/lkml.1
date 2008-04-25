Return-Path: <linux-kernel-owner+w=401wt.eu-S1755753AbYDYCSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755753AbYDYCSU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 22:18:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755664AbYDYCSG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 22:18:06 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33294 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755489AbYDYCSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 22:18:04 -0400
Date: Thu, 24 Apr 2008 23:16:40 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Brandon Philips <bphilips@suse.de>
Cc: Adrian Bunk <bunk@kernel.org>, Matthias Schwarzott <zzam@gentoo.org>,
       v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org,
       Patrick Boettcher <pb@linuxtv.org>
Subject: Re: [v4l-dvb-maintainer] no help text for DVB_TUNER_ITD1000
Message-ID: <20080424231640.3f8f2d9a@gaivota>
In-Reply-To: <20080425002351.GA19764@plankton>
References: <20080424202257.GC18854@cs181133002.pp.htv.fi>
	<20080424172838.5df1da67@gaivota>
	<20080424210821.GA14416@plankton>
	<20080424203937.0c21093b@gaivota>
	<20080425002351.GA19764@plankton>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Apr 2008 17:23:51 -0700
Brandon Philips <bphilips@suse.de> wrote:

> On 20:39 Thu 24 Apr 2008, Mauro Carvalho Chehab wrote:
> > I've did a diff between the applied patch and the original ones. It is
> > not easy to compare the diffs manually, since file order changes, but
> > it seems that the other patches are ok.
> 
> interdiff can help find identical patches that just change file order.

Very useful. 

It confirmed that the only two patches with problems are:

v4l_dvb_hg_7571_mt312_cleanup_buffer_variables_of_read_write_functions.patch:
--- b/drivers/media/dvb/frontends/Kconfig
+++ a/drivers/media/dvb/frontends/Kconfig

-config DVB_TUNER_ITD1000
-       tristate "Integrant ITD1000 Zero IF tuner for DVB-S/DSS"
-       depends on DVB_CORE && I2C
-       default m if DVB_FE_CUSTOMISE
-
 comment "Miscellaneous devices"
--- b/drivers/media/dvb/frontends/Makefile
+++ a/drivers/media/dvb/frontends/Makefile
 obj-$(CONFIG_DVB_TUNER_XC5000) += xc5000.o
-obj-$(CONFIG_DVB_TUNER_ITD1000) += itd1000.o

and v4l_dvb_hg_7569_added_support_for_skystar2_rev2_7_and_itd1000_dvb_s_tuner.patch:

only in patch2:
--- oldtree/drivers/media/dvb/frontends/Kconfig 2008-04-14 22:19:41.000000000 -0300
+++ linux/drivers/media/dvb/frontends/Kconfig   2008-04-14 22:19:38.000000000 -0300

+config DVB_TUNER_ITD1000
+       tristate "Integrant ITD1000 Zero IF tuner for DVB-S/DSS"
+       depends on DVB_CORE && I2C
+       default m if DVB_FE_CUSTOMISE
+
 comment "Miscellaneous devices"
only in patch2:
--- oldtree/drivers/media/dvb/frontends/Makefile        2008-04-14 22:19:41.000000000 -0300
+++ linux/drivers/media/dvb/frontends/Makefile  2008-04-14 22:19:38.000000000 -0300
 obj-$(CONFIG_DVB_TUNER_XC5000) += xc5000.o
+obj-$(CONFIG_DVB_TUNER_ITD1000) += itd1000.o

I can't understand what happened by looking on my procedure. It really seems to
be some corruption on -git, maybe due to stgit porcelain.


Cheers,
Mauro
