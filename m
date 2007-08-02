Return-Path: <linux-kernel-owner+w=401wt.eu-S1760920AbXHBXGq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760920AbXHBXGq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 19:06:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756327AbXHBXGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 19:06:38 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:15440 "EHLO
	viefep28-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756290AbXHBXGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 19:06:37 -0400
From: Daniel Ritz <daniel.ritz-ml@swissonline.ch>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: REGRESSION: serial_cs broken by 8250 changes
Date: Fri, 3 Aug 2007 01:06:32 +0200
User-Agent: KMail/1.9.6
Cc: Yinghai Lu <yinghai.lu@sun.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708030106.33917.daniel.ritz-ml@swissonline.ch>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

commit 18a8bd949d6adb311ea816125ff65050df1f3f6e breaks serial_cs badly
with an oops, completely killing PCMCIA.

register_console() now calls console->early_setup(). which in case of
8250.c (the only user anyway) is serial8250_console_early_setup()
which is __init, calling 8250_early.c:serial8250_find_port_for_earlycon()
which is __init as well. boom.

the changelog mentions SERIAL_PORT_DFNS removal which happens to be
commit 7e92b4fc345f5b6f57585fbe5ffdb0f24d7c9b26. but this got reverted
by commit 57d4810ea0d9ca58a7bcc1336607f0cede0a2abf. so i'd suggest to
just revert the 8250 changes as well.

rgds
-daniel
