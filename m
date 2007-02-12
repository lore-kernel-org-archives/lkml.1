Return-Path: <linux-kernel-owner+w=401wt.eu-S1750908AbXBLADf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750908AbXBLADf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 19:03:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750929AbXBLADf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 19:03:35 -0500
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:32837 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750908AbXBLADf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 19:03:35 -0500
Message-ID: <45CFAED5.2090808@lwfinger.net>
Date: Sun, 11 Feb 2007 18:03:33 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 1.5.0.9 (X11/20060911)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Regress for 8139too in 2.6.20
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In kernel version 2.6.20, my network interface, a Uniden PCN 300 PCMCIA card that uses the 8139too
driver fails to initialize with Yenta and 8139too as modules. It worked correctly in 2.6.19. Using
git bisect, the bad commit is shown below:

finger@sonylap:~/linux-2.6> git bisect good
8d610dd52dd1da696e199e4b4545f33a2a5de5c6 is first bad commit
commit 8d610dd52dd1da696e199e4b4545f33a2a5de5c6
Author: Linus Torvalds <torvalds@woody.osdl.org>
Date:   Mon Dec 11 12:12:04 2006 -0800

    Make sure we populate the initroot filesystem late enough

    We should not initialize rootfs before all the core initializers have
    run.  So do it as a separate stage just before starting the regular
    driver initializers.

    Signed-off-by: Linus Torvalds <torvalds@osdl.org>

:040000 040000 12bc13def90d15921d41d2b285854b3e157a970f f936e01f6b1b2b75478484861d34e81830c73860 M
    include
:040000 040000 5673719c3f6b47b329cfc9554c112077634a9b19 9c2e768964af1500d62849836b9f8e801fe7f29e M
    init


If Yenta is built into the kernel, rather than a module, it works again with 2.6.20.

Larry
