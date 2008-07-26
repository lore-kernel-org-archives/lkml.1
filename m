Return-Path: <linux-kernel-owner+w=401wt.eu-S1754714AbYGZG3b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714AbYGZG3b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 02:29:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752293AbYGZG3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 02:29:22 -0400
Received: from nebensachen.de ([195.34.83.29]:53022 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751567AbYGZG3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 02:29:21 -0400
X-Hashcash: 1:20:080726:alan@lxorguk.ukuu.org.uk::AInpuFUM+wUm43Vp:0000000000000000000000000000000000000GPEP
X-Hashcash: 1:20:080726:jeff@garzik.org::mE0L3ZkUmAhef2E8:004rQx
X-Hashcash: 1:20:080726:bzolnier@gmail.com::258onb/EzA5Vt+aT:000000000000000000000000000000000000000000027ur
X-Hashcash: 1:20:080726:james.bottomley@hansenpartnership.com::ihxeHiChjvd/3TQC:0000000000000000000000002dtb
X-Hashcash: 1:20:080726:pavel@ucw.cz::GF35FppLLzCu5Z6J:000006KNj
X-Hashcash: 1:20:080726:linux-ide@vger.kernel.org::hLiy5KEBKOtvcbDg:0000000000000000000000000000000000003i2i
X-Hashcash: 1:20:080726:linux-kernel@vger.kernel.org::pLy+2G5iM8uibKcs:0000000000000000000000000000000007Ug4
From: Elias Oltmanns <eo@nebensachen.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jeff@garzik.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Pavel Machek <pavel@ucw.cz>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] Add documentation for hard disk shock protection
	interface
In-Reply-To: <87prp1kvyy.fsf@denkblock.local>
Message-ID: <20080726062142.29070.60679.stgit@denkblock.local>
References: <87prp1kvyy.fsf@denkblock.local>
User-Agent: StGIT/0.14.2
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Date: Sat, 26 Jul 2008 08:29:11 +0200
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Put some information (and pointers to more) into the kernel's doc tree,
describing briefly how to set up disk shock protection under GNU/Linux.

Signed-off-by: Elias Oltmanns <eo@nebensachen.de>
---

 Documentation/laptops/disk-shock-protection.txt |   66 +++++++++++++++++++++++
 1 files changed, 66 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/laptops/disk-shock-protection.txt

diff --git a/Documentation/laptops/disk-shock-protection.txt b/Documentation/laptops/disk-shock-protection.txt
new file mode 100644
index 0000000..ac26040
--- /dev/null
+++ b/Documentation/laptops/disk-shock-protection.txt
@@ -0,0 +1,66 @@
+Hard disk shock protection
+==========================
+
+Author: Elias Oltmanns <eo@nebensachen.de>
+Last modified: 2008-07-24
+
+
+Intro
+-----
+
+ATA/ATAPI-7 specifies the IDLE IMMEDIATE command with UNLOAD FEATURE.
+Issuing this command should cause the drive to switch to idle mode and
+unload disk heads. This feature is being used in modern laptops in
+conjunction with accelerometers and appropriate software to implement
+a shock protection facility. The idea is to stop all I/O operations on
+the internal hard drive and park its heads on the ramp when critical
+situations are anticipated. The desire to have such a feature
+available on GNU/Linux systems has been the original motivation to
+implement a generic disk head parking interface in the Linux kernel.
+
+
+The interface
+-------------
+
+The interface works as follows: Writing an integer value to
+/sys/block/*/device/unload_heads will take the heads of the respective
+drive off the platter and block all I/O operations for the specified
+number of seconds. When the timeout expires and no further disk head
+park request has been issued in the meantime, normal operation will be
+resumed.
+
+FIXME:
+Once we've addressed the problem with pre-ATA-7 drives supporting the
+UNLOAD FEATURE but not announcing it properly, we'll document it
+accordingly.
+
+
+References
+----------
+
+There are several laptops from different brands featuring shock
+protection capabilities. As manufacturers have refused to support open
+source development of the required software components so far, Linux
+support for shock protection varies considerably between different
+hardware implementations. Ideally, this section should contain a list
+of pointers at different projects aiming at an implementation of shock
+protection on different systeems. Unfortunately, I only know of a
+single project which, although still considered experimental, is fit
+for use. Please feel free to add projects that have been the victims
+of my ignorance.
+
+- http://www.thinkwiki.org/wiki/HDAPS
+  See this page for information about Linux support of the hard disk
+  active protection syystem as implemented in IBM/Lenovo Thinkpads.
+  (FIXME: The information there will have to be updated once this
+  patch has been approved or the user interface has been agreed upon
+  at least.)
+
+
+CREDITS
+-------
+
+This implementation of disk head parking has been based on a patch
+originally published by Jon Escombe <lists@dresco.co.uk>. Assisted by
+various kernel developers, the author of this document has rewritten
+the original patch in order to make it fit for upstream submission.


