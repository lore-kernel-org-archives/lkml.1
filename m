Return-Path: <linux-kernel-owner+w=401wt.eu-S1753019Ab0ARHIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019Ab0ARHIq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 02:08:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752932Ab0ARHIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 02:08:45 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:48783 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752297Ab0ARHIo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 02:08:44 -0500
Date: Mon, 18 Jan 2010 18:08:41 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jan Kiszka <jan.kiszka@siemens.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Wolfram Sang <w.sang@pengutronix.de>
Subject: linux-next: manual merge of the tip tree with Linus' tree
Message-Id: <20100118180841.96628ee6.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta4 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the tip tree got a conflict in
scripts/recordmcount.pl between commit
b82a4045f7962483a78a874343dc6e31b79c96c1 ("tracing/x86: Derive arch from
bits argument in recordmcount.pl") from Linus' tree and commit
dfaa9e2c5707b2c217c0121aac796e0fa3051482 ("tracing: Use appropriate perl
constructs in recordmcount.pl") from the tip tree.

I fixed it up (see below) and can carry the fix for a while.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc scripts/recordmcount.pl
index ea6f6e3,545fe71..0000000
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@@ -194,12 -195,8 +195,8 @@@ sub check_objcop
      }
  }
  
 -if ($arch eq 'x86') {
 +if ($arch =~ /(x86(_64)?)|(i386)/) {
-     if ($bits == 64) {
- 	$arch = "x86_64";
-     } else {
- 	$arch = "i386";
-     }
+     $arch = ($bits == 64) ? 'x86_64' : 'i386';
  }
  
  #
