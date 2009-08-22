Return-Path: <linux-kernel-owner+w=401wt.eu-S933374AbZHVUgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933374AbZHVUgR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 16:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933300AbZHVUgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 16:36:17 -0400
Received: from relay8.uol.com.br ([187.17.116.6]:51312 "EHLO relay8.uol.com.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932860AbZHVUgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 16:36:16 -0400
Date: Sat, 22 Aug 2009 17:33:53 -0300
From: =?utf-8?Q?Rog=C3=A9rio?= Brito <rbrito@ime.usp.br>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       USB list <linux-usb@vger.kernel.org>,
       SCSI development list <linux-scsi@vger.kernel.org>,
       linux-kernel@vger.kernel.org, bugzilla-daemon@bugzilla.kernel.org
Subject: [PATCH] usb: fix paths in usbmon documentation
Message-ID: <20090822203353.GA2103@ime.usp.br>
References: <20090820220740.GA767@ime.usp.br>
 <Pine.LNX.4.44L0.0908211003090.2912-100000@iolanthe.rowland.org>
 <20090822191420.GA5572@ime.usp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090822191420.GA5572@ime.usp.br>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SIG5: d12c5be76ec9203ee49214bece3a84d2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there.

On Aug 21 2009, Alan Stern wrote:
> On Thu, 20 Aug 2009, Rogério Brito wrote:
> > Again, just reiterating, what I said before, even though I am not sure
> > if I can reproduce it, I will try to.
> 
> A usbmon trace showing what happens when you plug in the drive and 
> when you run smartctl would help.

The documentation for usbmon in the kernel 2.6.31-rc7 kernel doesn't
match what the kernel exposes in the debug fs tree. This patch fixes it.

Signed-off-by: Rogério Brito <rbrito@ime.usp.br>

---

diff --git a/Documentation/usb/usbmon.txt b/Documentation/usb/usbmon.txt
index 6c3c625..ea05cf7 100644
--- a/Documentation/usb/usbmon.txt
+++ b/Documentation/usb/usbmon.txt
@@ -33,7 +33,7 @@ if usbmon is built into the kernel.
 
 Verify that bus sockets are present.
 
-# ls /sys/kernel/debug/usbmon
+# ls /sys/kernel/debug/usb/usbmon
 0s  0u  1s  1t  1u  2s  2t  2u  3s  3t  3u  4s  4t  4u
 #
 
@@ -58,11 +58,11 @@ Bus=03 means it's bus 3.
 
 3. Start 'cat'
 
-# cat /sys/kernel/debug/usbmon/3u > /tmp/1.mon.out
+# cat /sys/kernel/debug/usb/usbmon/3u > /tmp/1.mon.out
 
 to listen on a single bus, otherwise, to listen on all buses, type:
 
-# cat /sys/kernel/debug/usbmon/0u > /tmp/1.mon.out
+# cat /sys/kernel/debug/usb/usbmon/0u > /tmp/1.mon.out
 
 This process will be reading until killed. Naturally, the output can be
 redirected to a desirable location. This is preferred, because it is going


-- 
Rogério Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2CAEB8
http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org
