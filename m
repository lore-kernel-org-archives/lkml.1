Return-Path: <linux-kernel-owner+w=401wt.eu-S1753275AbXKSLpU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275AbXKSLpU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 06:45:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752153AbXKSLpI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 06:45:08 -0500
Received: from moutng.kundenserver.de ([212.227.126.183]:51836 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbXKSLpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 06:45:07 -0500
Subject: MMC sub-system: SDIO block-mode with increment address issue
From: Dean Jenkins <djenkins@mvista.co.uk>
Reply-To: djenkins@mvista.co.uk
To: Linux kernel mailing list <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: MontaVista
Date: Mon, 19 Nov 2007 11:44:54 +0000
Message-Id: <1195472694.18869.57.camel@libdev3.libertesoft.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-33.0.1.el5) 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX19ZdPxT/oWp4LJLy6e8cwo8OZ6zViAK25B0nht
 1b0bAgVXZ704h6AXs932B4SlyhVvNEok5z71uI5APMS2MArJ5D
 yZQqYmR4q/CHlvz7EazSg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This E-mail is for the attention of Pierre Ossman (MMC sub-system
maintainer)

Hi Pierre,

I've being trying to get SDIO block-mode with incrementing address to
work on an OMAP2430 based reference board with an SDIO card.

Looking at the latest code ( as of 19/11/2007 ) on the mmc-git tree (I'm
not a git expert so I'm not sure how to reference the codebase). I have
a comment to make concerning the following code snippet...

In drivers/mmc/core/sdio_io.c

Function: sdio_io_rw_ext_helper()

<snip>

219                         ret = mmc_io_rw_extended(func->card, write,
220                                 func->num, addr, incr_addr, buf,
221                                 blocks, func->cur_blksize);
222                         if (ret)
223                                 return ret;
224 
225                         remainder -= size;
226                         buf += size;
227                         if (incr_addr)
228                                 addr += size;
229                 }

</snip>

I think the lines

227                         if (incr_addr)
228                                 addr += size;

are incorrect and should be removed. I think the SDIO increment address
parameter relates to the internal operation of the SDIO card and NOT to
the external register address of the FIFO. In other words, I think with
incrementing address enabled in block mode, the register address of the
FIFO in the SDIO function register space will be erroneously changed on
the next block write and will fail (it seems to fail on my card). It
seems strange to change the register address ?

This also relates to byte mode.

What do you think ?

Also, do you have a bug reporting procedure for mmc-git tree ?

Regards,
Dean.


-- 
Dean Jenkins
Embedded Software Engineer
MontaVista Software (UK)
Professional Services Division

