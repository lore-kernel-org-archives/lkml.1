Return-Path: <linux-kernel-owner+w=401wt.eu-S1761021AbXEUIij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761021AbXEUIij (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 04:38:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759629AbXEUIiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 04:38:23 -0400
Received: from [216.16.235.2] ([216.16.235.2]:43362 "EHLO rubicon.netdirect.ca"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758950AbXEUIiW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 04:38:22 -0400
X-Originating-Ip: 72.143.65.211
Date: Mon, 21 May 2007 04:37:29 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Sam Ravnborg <sam@ravnborg.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Factor out common MODULE_INFO content from module*.h
 files.
In-Reply-To: <20070521045249.GA30018@uranus.ravnborg.org>
Message-ID: <Pine.LNX.4.64.0705210436060.7032@localhost.localdomain>
References: <Pine.LNX.4.64.0705201502160.17519@localhost.localdomain>
 <20070520191552.GA25200@uranus.ravnborg.org> <Pine.LNX.4.64.0705201555470.18338@localhost.localdomain>
 <20070520205116.GB25339@uranus.ravnborg.org> <Pine.LNX.4.64.0705201651570.19270@localhost.localdomain>
 <20070521045249.GA30018@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.723, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00, RCVD_IN_SORBS_DUL 20.00,
	TW_VN 0.08)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 May 2007, Sam Ravnborg wrote:

> rday wrote:

> > under the circumstances, is there *any* cleanup worth doing WRT to
> > this issue?  because of the fact that module.h currently includes
> > moduleparam.h, developers have been able to get away with being
> > incredibly sloppy in their includes.
>
> It is wortwhile to make module.h independent of moduleparam.h.
> The MODULE_INFO stuff has nothing to do with module parameters.
>
> But keep the include so you do not break the > 500 drivers.

  ok, i can do that.  but, at the very least, it might be worth it for
some people to stop including moduleparam.h in their code when that
code does nothing with module parameters.  my scanning script picked
out the following files under drivers/ that *seem* to be doing just
that, so respective maintainers might want to toss those useless
includes.  (obviously, at the moment, *all* includes of moduleparam.h
are useless, but the ones in the files below are *doubly* useless. :-)


drivers/pcmcia/socket_sysfs.c
drivers/pcmcia/au1000_generic.c
drivers/net/macb.c
drivers/net/ixp2000/ixpdev.c
drivers/net/ixp2000/enp2611.c
drivers/net/arm/ep93xx_eth.c
drivers/net/irda/kingsun-sir.c
drivers/scsi/aacraid/linit.c
drivers/scsi/3w-9xxx.c
drivers/scsi/arcmsr/arcmsr_hba.c
drivers/scsi/megaraid/megaraid_sas.c
drivers/scsi/3w-xxxx.c
drivers/bluetooth/bt3c_cs.c
drivers/bluetooth/btuart_cs.c
drivers/bluetooth/bluecard_cs.c
drivers/bluetooth/dtl1_cs.c
drivers/acpi/processor_core.c
drivers/serial/mpsc.c
drivers/mmc/card/block.c
drivers/mmc/host/at91_mci.c
drivers/mmc/host/omap.c
drivers/char/hvc_rtas.c
drivers/char/hw_random/ixp4xx-rng.c
drivers/char/mbcs.c
drivers/char/watchdog/mtx-1_wdt.c
drivers/usb/gadget/fsl_usb2_udc.c
drivers/usb/atm/cxacru.c
drivers/usb/host/sl811-hcd.c
drivers/media/dvb/frontends/isl6421.c
drivers/media/dvb/frontends/lnbp21.c
drivers/media/dvb/frontends/dvb_dummy_fe.c
drivers/media/common/ir-keymaps.c
drivers/media/video/ov7670.c
drivers/media/video/cx88/cx88-vp3054-i2c.c
drivers/infiniband/hw/mthca/mthca_profile.c
drivers/infiniband/hw/amso1100/c2_rnic.c
drivers/infiniband/hw/amso1100/c2_provider.c
drivers/infiniband/hw/cxgb3/iwch.c
drivers/infiniband/hw/cxgb3/iwch_provider.c
drivers/input/mouse/trackpoint.c
drivers/input/serio/libps2.c
drivers/w1/slaves/w1_ds2433.c
drivers/w1/slaves/w1_therm.c
drivers/w1/slaves/w1_smem.c
drivers/s390/net/qeth_main.c

  the same could be said for these files under net/:

net/netfilter/nf_conntrack_proto.c
net/ipv6/netfilter/ip6t_LOG.c
net/ipv4/netfilter/nf_nat_h323.c
net/ipv4/netfilter/nf_nat_tftp.c
net/iucv/iucv.c


rday
--
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
