Return-Path: <linux-kernel-owner+w=401wt.eu-S1753975AbXJ1PP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975AbXJ1PP2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 11:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751425AbXJ1PPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 11:15:20 -0400
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:34526 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbXJ1PPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 11:15:20 -0400
Message-ID: <4724A783.9050400@tiscali.nl>
Date: Sun, 28 Oct 2007 16:15:15 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: Debugging activated during runtime
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Wouldn't it be nice to be able to specify upon loading, or during runtime
to modules whether debug messages should be printed?
- No kernel recompile needed for debugging.
- Less *_DEBUG options required in menuconfig.

How I think this could work:
Add to the module struct a bool to denote debugging state. If set, pr_debug
forwards messages to printk.

Another advantage:
- A module could be loaded after an unexpected conditions (e.g. after a BUG_ON).

Caveats I can see right now:
- For modules often loaded during boot this may not be a good solution.

Alternatively, instead of a bool for the debug state, the module struct could
also get a log-level flag: messages below that level won't be printed.
