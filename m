Return-Path: <linux-kernel-owner+w=401wt.eu-S964917AbXBLNtl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964917AbXBLNtl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 08:49:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964919AbXBLNtl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 08:49:41 -0500
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:43163 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964917AbXBLNtl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 08:49:41 -0500
Message-ID: <45D07075.7090302@drzeus.cx>
Date: Mon, 12 Feb 2007 14:49:41 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
User-Agent: Thunderbird 1.5.0.9 (X11/20070131)
MIME-Version: 1.0
To: Alex Dubov <oakad@yahoo.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Recent and not-so problems with tifm_sd driver
References: <20070212115343.41523.qmail@web36712.mail.mud.yahoo.com>
In-Reply-To: <20070212115343.41523.qmail@web36712.mail.mud.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Dubov wrote:
> I removed that line altogether (it does not really needed as mmc host will not be accessed
> anymore). The problem is more elaborate. Here, the card fails, mmc_host_remove is called without
> sleep beforehand, and "after remove" message is printed immediately after it. Only then, mmc_block
> remembers to finish its business. If I leave the sleep in place, mmc_block's stuff will get
> scheduled before the mmc_remove_host and everything will be all right.
> You may also notice that host is already powered off ("Setting ... power 0" message) and still
> mmc_block continues to make requests like nothing happened.
> 

How did you do the "after remove" detection? Patch?

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
