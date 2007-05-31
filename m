Return-Path: <linux-kernel-owner+w=401wt.eu-S1754193AbXEaUub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193AbXEaUub (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 16:50:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750971AbXEaUuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 16:50:23 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:37964 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750766AbXEaUuW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 16:50:22 -0400
Date: Thu, 31 May 2007 22:51:22 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Prarit Bhargava <prarit@redhat.com>, tigran@aivazian.fsnet.co.uk
Cc: Christoph Lameter <clameter@sgi.com>, "Luck, Tony" <tony.luck@intel.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, David Chinner <dgc@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, linux-ia64@vger.kernel.org
Subject: [PATCH] microcode: fix section mismatch warning
Message-ID: <20070531205122.GG27305@uranus.ravnborg.org>
References: <617E1C2C70743745A92448908E030B2A01929DD3@scsmsx411.amr.corp.intel.com> <Pine.LNX.4.64.0705302019040.5583@schroedinger.engr.sgi.com> <465EE7BB.4050605@redhat.com> <20070531200446.GA27305@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070531200446.GA27305@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following section mismatch warnings in microcode.c:
WARNING: arch/i386/kernel/built-in.o(.init.text+0x3966): Section mismatch: reference to .exit.text: (between 'microcode_init' and 'parse_maxcpus')
WARNING: arch/i386/kernel/built-in.o(.init.text+0x3992): Section mismatch: reference to .exit.text: (between 'microcode_init' and 'parse_maxcpus')

The warning are caused by a function marked __init that
calls a function marked __exit.
Functions marked __exit may be discarded either during link or run-time
and thus the reference is not good.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
diff --git a/arch/i386/kernel/microcode.c b/arch/i386/kernel/microcode.c
index 83f825f..d865d04 100644
--- a/arch/i386/kernel/microcode.c
+++ b/arch/i386/kernel/microcode.c
@@ -478,7 +478,7 @@ static int __init microcode_dev_init (void)
 	return 0;
 }
 
-static void __exit microcode_dev_exit (void)
+static void microcode_dev_exit (void)
 {
 	misc_deregister(&microcode_dev);
 }
