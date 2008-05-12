Return-Path: <linux-kernel-owner+w=401wt.eu-S1755162AbYELVsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162AbYELVsh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 17:48:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752365AbYELVs2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 17:48:28 -0400
Received: from vena.lwn.net ([206.168.112.25]:38298 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751546AbYELVs1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 17:48:27 -0400
To: linux-kernel@vger.kernel.org
Subject: request_firmware() gives build failures
From: Jonathan Corbet <corbet@lwn.net>
Date: Mon, 12 May 2008 15:48:23 -0600
Message-ID: <17728.1210628903@vena.lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just tried building -rc2 (then current git) and got a few errors like:

  drivers/built-in.o: In function `generic_set_freq':
  tuner-xc2028.c:(.text+0x90f42): undefined reference to `request_firmware'
  tuner-xc2028.c:(.text+0x91418): undefined reference to `release_firmware'

A bit of digging turned up the problem: I had fw_loader configured as a
module, but some drivers which need it were configured built-in.  Don't
ask why I had those drivers configured in at all...time to prune that
.config I've been carrying around...

In any case, setting CONFIG_FW_LOADER=y makes the problem go away.  I'm
not good enough at kconfig to make that happen magically; putting in
"select FW_LOADER" doesn't seem to be enough.  In any case, given that
callers to request_firmware() can be built in, does it make sense to
have an option to make the firmware loader modular?

jon

