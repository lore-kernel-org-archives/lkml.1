Return-Path: <linux-kernel-owner+w=401wt.eu-S1754351AbYIHM7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351AbYIHM7b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 08:59:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752874AbYIHM7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 08:59:08 -0400
Received: from 2-1-3-15a.ens.sth.bostream.se ([82.182.31.214]:39430 "EHLO
	zoo.weinigel.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837AbYIHM7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 08:59:06 -0400
Message-Id: <20080908124848.541807034@zoo.weinigel.se>
User-Agent: quilt/0.46-1
Date: Mon, 08 Sep 2008 14:48:48 +0200
From: Christer Weinigel <christer@weinigel.se>
To: ben-linux@fluff.org
Cc: linux-kernel@vger.kernel.org, christer@weinigel.se
Subject: [patch 0/3] s3cmci SDIO patches
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

here are the s3cmci SDIO patches that I've done so far.

The first patch modifies the s3cmci driver so that it supports
non-word-sized transfers which is needed by SDIO.

The second patch removes calls the pio_tasklet directly from the
interrupt handler instead of scheduling it as a tasklet.  This reduces
the CPU load for the driver sligthtly.

The third patch adds experimental SDIO interrupt support.  Since there
are issues with spurious interrupts on some S3C processors, I think
this needs more testing before going into the kernel.

I'm working on trying to get the SDIO driver to go faster and use less
CPU, so I'm mainly doing two things right now, first of all I'd like
to try to make DMA work again.  There are hooks in the code for DMA,
but when i tried turning it on, it didn't work, so I'll try to chase
that down.

I'll probably make some other random changes, I'd like to make the
driver support non-word-aligned block transfers for example, something
that it doesn't support right now.  It doesn't seem to be needed for
SDIO Bluetooth Type A, but it would be nice to have it for
correctness.

And I'll try to clean up my patches to add asynchronous operations to
the SDIO layer, which might cause some fallout on the s3cmci driver.

Is there anything you'd like me to do with the s3cmci driver while I'm
at it?

  /Christer

-- 
"Just how much can I get away with and still go to heaven?"

Christer Weinigel <christer@weinigel.se>  http://www.weinigel.se
