Return-Path: <linux-kernel-owner+w=401wt.eu-S1763566AbXHDIt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763566AbXHDIt7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 04:49:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758280AbXHDItu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 04:49:50 -0400
Received: from antonio.urjc.es ([193.147.184.24]:54424 "EHLO antonio.urjc.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750971AbXHDItt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 04:49:49 -0400
Message-ID: <46B43DBA.5040703@urjc.es>
Date: Sat, 04 Aug 2007 10:50:02 +0200
From: Javier Pello <javier.pello@urjc.es>
Organization: Universidad Rey Juan Carlos
User-Agent: Thunderbird 2.0.0.0 (X11/20070503)
MIME-Version: 1.0
To: david@lang.hm
CC: linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: [PATCH] request_firmware: skip timeout if userspace was not 
	notified
References: <46B37CF7.2020803@urjc.es> 
	<Pine.LNX.4.64.0708032219230.6905@asgard.lang.hm>
In-Reply-To: <Pine.LNX.4.64.0708032219230.6905@asgard.lang.hm>
Content-Type: text/plain;
	charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender DNS name whitelisted, not delayed by 
	milter-greylist-2.0.2 (antonio.urjc.es [193.147.184.24]); Sat, 04 Aug 2007 
	10:49:31 +0200 (CEST)
X-imss-version: 2.047
X-imss-result: Passed
X-imss-scanInfo: M:B L:E SM:2
X-imss-tmaseResult: TT:1 TS:-6.1565 TC:1F TRN:27 TV:3.6.1039(15340.003)
X-imss-scores: Clean:100.00000 C:0 M:0 S:0 R:0
X-imss-settings: Baseline:1 C:1 M:1 S:1 R:1 (0.0000 0.0000)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I've been told that it's possible to have the kernel pull the firmware
> off of an initrd (or was it initramfs, I keep confusing the two) without
> having any userspace, just put the right file in the right place
> (unfortunantly I've never gotten around to testing this) will this patch
> break this feature?

Correct me if I'm wrong, but I understand that the way this works is having
the initramfs become an "early userspace", a filesystem that is mounted,
well, earlier during boot, so that it is available before drivers begin
to initialise (earlier: as a rootfs_initcall, as opposed to at the end of
the boot process), but that in all respects behaves as a fully-fledged root
filesystem. In particular, firmware should be requested from userspace in
the standard way, and the patch should not break anything. I would test
this to be sure, but I have absolutely no experience preparing an initramfs.

Javier


