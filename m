Return-Path: <linux-kernel-owner+w=401wt.eu-S1755342AbYGaODo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342AbYGaODo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 10:03:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752758AbYGaODg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 10:03:36 -0400
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:20126 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752730AbYGaODf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 10:03:35 -0400
Message-ID: <4891C61A.9010206@panasas.com>
Date: Thu, 31 Jul 2008 17:03:06 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Richard Hacker <lerichi@gmx.net>, Sam Ravnborg <sam@ravnborg.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: how to use KBUILD_EXTRA_SYMBOLS
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 31 Jul 2008 14:02:30.0210 (UTC) FILETIME=[124FAA20:01C8F316]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have two out-of-tree modules that I compile with the M=
mechanics, one of the modules has imports from the other one.

I tried to follow modules.txt and put an KBUILD_EXTRA_SYMBOLS
when building. Somewhat like below:

	# derived.ko module Makefile
	# $(BASE_MODULE_DIR) must point to base.ko source directory
	KBUILD_BASE = +$(MAKE) -C $(KSRC) M=`pwd` KBUILD_OUTPUT=$(KBUILD_OUTPUT) ARCH=$(ARCH)

	derived:
		$(KBUILD_BASE) KBUILD_EXTRA_SYMBOLS=$(BASE_MODULE_DIR) modules

But doing this does work:
	# derived module Makefile
	# $(BASE_MODULE_DIR) must point to base.ko source directory

	KBUILD_BASE = +$(MAKE) -C $(KSRC) M=`pwd` KBUILD_OUTPUT=$(KBUILD_OUTPUT) ARCH=$(ARCH)

	derived:
		$(KBUILD_BASE) KBUILD_EXTMOD=$(BASE_MODULE_DIR) modules


The diff is s/KBUILD_EXTRA_SYMBOLS/KBUILD_EXTMOD.

It took me a long while and inspection the git-log of
Documentation/kbuild/modules.txt to figure that out. Perhaps an example
is do in documentation.

What am I doing wrong?

Thanks
Boaz


