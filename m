Return-Path: <linux-kernel-owner+w=401wt.eu-S1754751AbYIGWAH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751AbYIGWAH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 18:00:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752681AbYIGV74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 17:59:56 -0400
Received: from rere.qmqm.pl ([89.167.52.164]:46296 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752452AbYIGV7z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 17:59:55 -0400
X-Greylist: delayed 444 seconds by postgrey-1.27 at vger.kernel.org; Sun, 07 Sep 2008 17:59:55 EDT
Date: Sun, 7 Sep 2008 23:52:28 +0200
From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
To: linux-kernel@vger.kernel.org
Cc: drzeus-mmc@drzeus.cx, oakad@yahoo.com
Subject: MMC host driver requirements
Message-ID: <20080907215228.GA19193@rere.qmqm.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm writing a driver for ENE CB710/720 memory card readers found in some
laptops (ie. some versions of HP Compaq nx9500). This chip has three
memory card interfaces: MMC/SD, SmartMedia, MemoryStick. I started with
the MMC interface as I have a card to test it with, but I could not find
any documentation about MMC stack besides the source code.

So here are some questions:

1. Can I call mmc_detect_change() after mmc_alloc_host() but before or
   during mmc_add_host() (ie. from interrupt handler)? If yes, what
   if mmc_alloc_host() fails then?
2. Can I call mmc_request_done() from ->request() handler?
3. Does MMC stack serialize calls to ->request() or any other host
   driver ops?
4. What is the difference (if any) between mrq->data and mrq->cmd->data
   as seen from ->request()?
5. Are there any constraints to scatterlist passed to ->request()
   - number of elements, data alignment, element data size?
   (At first I assumed that there are none and have writted a simple
   wrapper to guarantee multiple-of-16-byte data blocks - but maybe
   its just not needed?)

If/when I finish the driver there is the question what are the
requirements for it to be accepted to mainline? It's based on
reverse-engineering work on a Windows driver so it will have
some magic register-access sequences, as the original driver used
completely different MMC/SD stack and probably not fully used chip's
capabilities.

BTW, Google said nothing interesting about the hardware: most hits are
about not existing drivers for it and manufacturer ignoring inquiries
for datasheets.

Best Regards,
Micha³ Miros³aw
