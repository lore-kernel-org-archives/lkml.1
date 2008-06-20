Return-Path: <linux-kernel-owner+w=401wt.eu-S1760238AbYFTQLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760238AbYFTQLq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 12:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753532AbYFTQLg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 12:11:36 -0400
Received: from smtp01.uc3m.es ([163.117.176.131]:58635 "EHLO smtp01.uc3m.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753227AbYFTQLg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 12:11:36 -0400
From: "Peter T. Breuer" <ptb@inv.it.uc3m.es>
Message-Id: <200806201611.m5KGBDN02249@inv.it.uc3m.es>
Subject: Re: [PATCH 1/3] i/o bandwidth controller documentation
In-Reply-To: <200806201602.m5KG2Zx32671@inv.it.uc3m.es> from "Peter T. 
	Breuer"at "Jun 20, 2008 06:02:35 pm"
To: "linux kernel" <linux-kernel@vger.kernel.org>
Date: Fri, 20 Jun 2008 18:11:13 +0200 (MET DST)
X-Anonymously-To: 
Reply-To: ptb@inv.it.uc3m.es
X-message-flag: Had your Outlook virus, today?  
	http://www.counterpane.com/crypto-gram-0103.html#4
X-WebTV-Stationery: Standard\; BGColor=black\; TextColor=black
Reply-By: Sat, 1 Apr 2006 14:21:08 -0700
X-Mailer: ELM [version 2.4ME+ PL66 (25)]
X-imss-version: 2.051
X-imss-result: Passed
X-imss-scanInfo: M:B L:E SM:2
X-imss-tmaseResult: TT:1 TS:-2.8630 TC:1F TRN:23 TV:5.5.1026(15982.007)
X-imss-scores: Clean:100.00000 C:0 M:0 S:0 R:0
X-imss-settings: Baseline:1 C:1 M:1 S:1 R:1 (0.0000 0.0000)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +               Block device I/O bandwidth controller

How can this work?  You will limit the number of available buffer heads 
per second?

Unfortunaely, the problem is the fs above the block device.  If the
block device is artificially slowed then the fs will still happily allow
a process to fill buffers forever until memory is full, while the block
device continues to trickle the buffers away.

What one wants is for the fs buffering to be linked to the underlying
block device i/o speed. One wants the rate at which fs buffers are
filled to be no more than (modulu brief spurts) the rate  at which the
device operates.

That way networked block devices have a chance of having some memory
left to send the dirty buffers out to the net with. B/w limiting the
device itself doesn't seem to me to do any good.

Peter
