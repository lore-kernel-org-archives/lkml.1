Return-Path: <linux-kernel-owner+w=401wt.eu-S1752031AbXCTWY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031AbXCTWY5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 18:24:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752042AbXCTWY4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 18:24:56 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:46037 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752031AbXCTWYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 18:24:55 -0400
From: Ismail =?iso-8859-1?q?D=F6nmez?= <ismail@pardus.org.tr>
Organization: TUBITAK/UEKAE
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 2.6.21-rc4] ieee1394: fix oops on "modprobe -r ohci1394" after network class_device conversion
Date: Wed, 21 Mar 2007 00:26:22 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
       Adrian Bunk <bunk@stusta.de>, Greg KH <greg@kroah.com>,
       Thomas Meyer <thomas@m3y3r.de>, Tobias Diedrich <ranma@tdiedrich.de>
References: <200703140642.28390.ismail@pardus.org.tr> <200703150249.04169.ismail@pardus.org.tr> <tkrat.5965dca5154c0fa2@s5r6.in-berlin.de>
In-Reply-To: <tkrat.5965dca5154c0fa2@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703210026.22825.ismail@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 March 2007 23:43:22 Stefan Richter wrote:
> The networking subsystem has been converted from class_device to device
> but ieee1394 hasn't.  This results in a 100% reproducible NULL pointer
> dereference if the ohci1394 driver module is unloaded while the eth1394
> module is still loaded.
> http://lkml.org/lkml/2006/11/16/147
> http://lkml.org/lkml/2007/3/14/4
>
> This is a regression in 2.6.21-rc1.
>
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
> ---
>
> Works for me.  I still can connect to an OS X box via eth1394 after that
> and modprobe -r ohci1394 before modprobe -r eth1394 works again.
>
> Index: linux-2.6.21-rc4/drivers/ieee1394/eth1394.c
> ===================================================================
> --- linux-2.6.21-rc4.orig/drivers/ieee1394/eth1394.c	2007-03-16
> 19:24:44.000000000 +0100 +++
> linux-2.6.21-rc4/drivers/ieee1394/eth1394.c	2007-03-20 22:28:49.000000000
> +0100 @@ -586,7 +586,10 @@ static void ether1394_add_host (struct h
>          }
>
>  	SET_MODULE_OWNER(dev);
> +#if 0
> +	/* FIXME - Is this the correct parent device anyway? */
>  	SET_NETDEV_DEV(dev, &host->device);
> +#endif
>
>  	priv = netdev_priv(dev);

This also fixes the issue for me, thanks for tracking this down Stefan.

Regards.

-- 
Happiness in intelligent people is the rarest thing I know. (Ernest Hemingway)

Ismail Donmez ismail (at) pardus.org.tr
GPG Fingerprint: 7ACD 5836 7827 5598 D721 DF0D 1A9D 257A 5B88 F54C
Pardus Linux / KDE developer
