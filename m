Return-Path: <linux-kernel-owner+w=401wt.eu-S1161131AbXBRINJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161131AbXBRINJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 03:13:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161111AbXBRINI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 03:13:08 -0500
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:47066 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161132AbXBRINH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 03:13:07 -0500
Message-ID: <45D80A94.308@drzeus.cx>
Date: Sun, 18 Feb 2007 09:13:08 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
User-Agent: Thunderbird 1.5.0.9 (X11/20070131)
MIME-Version: 1.0
To: Alex Dubov <oakad@yahoo.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Recent and not-so problems with tifm_sd driver
References: <397934.24280.qm@web36702.mail.mud.yahoo.com>
In-Reply-To: <397934.24280.qm@web36702.mail.mud.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Dubov wrote:
>> I don't actually think that is what happening. The block errors tend to trail a
>> bit behind, so the errors you are seeing are probably the result of the queue
>> being flushed out as you remove the card. I don't see any mmc debug messages
>> that indicate that is trying to send more mmc requests.
> 
> Yes, indeed - it does not issue new requests after remove. However, mmc_remove_host does not wait
> for all issued requests to complete and it is a problem.

I don't see how that is possible. mmc_block's remove routine waits for mmcqd to
exit, so there can't be any code still alive that has a request going. (I am
also completely unable to reproduce this problem here).

Add more printk:s do verify how the code in mmc_block executes.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
