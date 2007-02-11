Return-Path: <linux-kernel-owner+w=401wt.eu-S1750763AbXBKSPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750763AbXBKSPT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 13:15:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750767AbXBKSPT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 13:15:19 -0500
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:34179 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750763AbXBKSPS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 13:15:18 -0500
Message-ID: <45CF5D37.1000900@drzeus.cx>
Date: Sun, 11 Feb 2007 19:15:19 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
User-Agent: Thunderbird 1.5.0.9 (X11/20070131)
MIME-Version: 1.0
To: Alex Dubov <oakad@yahoo.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Recent and not-so problems with tifm_sd driver
References: <779217.2685.qm@web36708.mail.mud.yahoo.com>
In-Reply-To: <779217.2685.qm@web36708.mail.mud.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Dubov wrote:
> 
> It just occurred to me that my synopsis of the problem was utterly lame.
> Here, the correct description:
> When the card is pulled out, I mark the host as "ejected" (so it fast-fails all the requests),
> sleep a little for it to relax and then call mmc_remove_host. Otherwise, nasty things happen.
> Here's the example not involving mmc_block at all (command 3 failed, hardware timeout was missed,
> so software timeout picked it up; the sleep hack is disabled):
> 

I believe your problem is line 915 of tifm_sd.c:

> 	tifm_set_drvdata(sock, NULL);

You call that before mmc_free_host() (which flushes the work queue), and I
assume something still needs it. Put in some BUG_ON() here and there and you
should be able to catch it.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
