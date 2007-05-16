Return-Path: <linux-kernel-owner+w=401wt.eu-S1760261AbXEPOn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760261AbXEPOn3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 10:43:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754586AbXEPOnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 10:43:20 -0400
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:60648 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753981AbXEPOnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 10:43:19 -0400
Message-ID: <464B1886.1060502@s5r6.in-berlin.de>
Date: Wed, 16 May 2007 16:43:18 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.2) Gecko/20070222 SeaMonkey/1.1.1
MIME-Version: 1.0
To: linux-scsi@vger.kernel.org
CC: Simon Arlott <simon@fire.lp0.eu>,
       James Bottomley <james.bottomley@steeleye.com>,
       Dave Jones <davej@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kernel-packagers@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] SCSI: Let users disable SCSI_WAIT_SCAN to be built
References: <1179073116.3723.45.camel@mulgrave.il.steeleye.com> <a781481a0705140235h6a96563cw63ed2c7a85a4f736@mail.gmail.com> <a781481a0705140245s6823df32l5bbf81abf92b0347@mail.gmail.com> <a781481a0705140500q32a891d6g69b40c2d45ec40c6@mail.gmail.com> <a781481a0705140523y789e012bj2ec317565e34366f@mail.gmail.com> <1179153096.3703.23.camel@mulgrave.il.steeleye.com> <a781481a0705141741u4c2f442dk76c68f757cadc38d@mail.gmail.com> <17841.simon.1179228389@5ec7c279.invalid> <20070515120228.GI10562@parisc-linux.org> <4649E03A.1090004@simon.arlott.org.uk> <20070515172905.GJ10562@parisc-linux.org> <tkrat.99c0f1a1898aa67f@s5r6.in-berlin.de>
In-Reply-To: <tkrat.99c0f1a1898aa67f@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
> --- linux-2.6.22-rc1.orig/drivers/scsi/Kconfig
> +++ linux-2.6.22-rc1/drivers/scsi/Kconfig
> @@ -241,11 +241,19 @@ config SCSI_SCAN_ASYNC
>  	  You can override this choice by specifying "scsi_mod.scan=sync"
>  	  or async on the kernel's command line.
>  
> -config SCSI_WAIT_SCAN
> +config SCSI_WAIT_SCAN_NO_Y
>  	tristate
>  	default m
> -	depends on SCSI
> -	depends on MODULES

SCSI_WAIT_SCAN_NO_Y is unnecessary, as Randy Dunlap pointed out in "Re:
How to force Kconfig tristate into range n..m?".
http://lkml.org/lkml/2007/5/15/320

> +
> +config SCSI_WAIT_SCAN
> +	tristate "Pseudo driver which waits for SCSI scanning to finish"
> +	depends on MODULES && SCSI && SCSI_WAIT_SCAN_NO_Y

	depends on SCSI && m

> +	help
> +	  When loaded, this module will do nothing else than wait for
> +	  SCSI low-level drivers to finish asynchronous scanning.
> +	  The module will be called scsi_wait_scan.

There should be explained that it is the command "modprobe
scsi_wait_scan" which is doing the waiting, and that this is useful or
required in initrds.

> +	  Most people can say n here.

This sentence should probably be omitted, as it may be wrong in the
future and unsafe already now.

I will resend an updated patch.
-- 
Stefan Richter
-=====-=-=== -=-= =----
http://arcgraph.de/sr/
