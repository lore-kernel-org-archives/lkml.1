Return-Path: <linux-kernel-owner+w=401wt.eu-S937901AbXHPCaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937901AbXHPCaX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 22:30:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765265AbXHPCaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 22:30:05 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:13437 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131AbXHPCaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 22:30:03 -0400
X-IronPort-AV: i="4.19,268,1183348800"; 
   d="scan'208"; a="37178846:sNHT31733751"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: Gerd Hoffmann <kraxel@suse.de>, linux-kernel@vger.kernel.org
Subject: Early printk behaviour
Date: Wed, 15 Aug 2007 22:34:06 -0400
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708152234.06734.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 16 Aug 2007 02:30:02.0678 (UTC) FILETIME=[5978E560:01C7DFAD]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I was putting together an early printk implementation for the Blackfin, and 
was wondering what the expected behaviour was in this situation.

When I set up my bootargs earlyprintk=serial,ttyBF0,57600 and have no console 
defined (no graphical console, no serial console).

based on the patch:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=69331af79cf29e26d1231152a172a1a10c2df511

which no longer calls disable_early_printk, the earlyprintk console never gets 
turned off (because nothing else ever calls register_console). I get 
everything out the early console, until the init section is released (where 
the console structure is sitting), and it starts printing out garbage.

Is this expected behaviour?

-Robin
