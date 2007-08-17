Return-Path: <linux-kernel-owner+w=401wt.eu-S1759325AbXHQQDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759325AbXHQQDU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 12:03:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752554AbXHQQC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 12:02:58 -0400
Received: from mba.ocn.ne.jp ([122.1.175.29]:55533 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752205AbXHQQC5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 12:02:57 -0400
Date: Sat, 18 Aug 2007 01:04:12 +0900 (JST)
Message-Id: <20070818.010412.72709547.anemo@mba.ocn.ne.jp>
To: jengelh@computergmbh.de
Cc: david-b@pacbell.net, a.zummo@towertech.it, linux-kernel@vger.kernel.org,
       rtc-linux@googlegroups.com, dbrownell@users.sourceforge.net
Subject: Re: [PATCH] rtc: Make rtc-ds1742 driver hotplug-aware
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <Pine.LNX.4.64.0708171736170.30502@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0708171258360.5492@fbirervta.pbzchgretzou.qr>
	<200708170823.15894.david-b@pacbell.net>
	<Pine.LNX.4.64.0708171736170.30502@fbirervta.pbzchgretzou.qr>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Aug 2007 17:37:01 +0200 (CEST), Jan Engelhardt <jengelh@computergmbh.de> wrote:
> >Most busses don't have managed device IDs like PCI, USB, or PNP.
> >
> >The platform, spi, and i2c busses use the driver name, which is
> >obviously managed within the scope of all Linux drivers.
> >
> Yeah but that does not tell me why it needs the ds1742 alias
> if scripts (whatever they use to discover it) could modprobe rtc-ds1742
> instead.

Well, the rtc-ds1742 platform driver uses a string "ds1742" for its
platform_driver definition.

static struct platform_driver ds1742_rtc_driver = {
	.probe		= ds1742_rtc_probe,
	.remove		= __devexit_p(ds1742_rtc_remove),
	.driver		= {
		.name	= "ds1742",
		.owner	= THIS_MODULE,
	},
};

We can change the name string and all definitions of "ds1742" platform
device instead of adding MODULE_ALIAS.  It is easy since there are
only a few users in kernel.  If that was preferred, I can rewrite this
patch.

---
Atsushi Nemoto
