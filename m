Return-Path: <linux-kernel-owner+w=401wt.eu-S1759603AbYDAUa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759603AbYDAUa1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 16:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757039AbYDAUaR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 16:30:17 -0400
Received: from el-out-1112.google.com ([209.85.162.176]:5808 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756793AbYDAUaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 16:30:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=oP3UsX7ZIY7hFj9B1UFVhzDXNXdrlHpSKjGvBm1R++nCOyry3vAURJWgtmajyyoFva/q1emUV1f7wq7rq5SZ2vhE/itBwn9QbHtxTh+/2zwF+ysbaRmzFPZxl2D3b+WWHXdPL1ARf31blgP5bO3P9SK1HBeaxGlHTHwc8FLyfG4=
Message-ID: <9d95d80e0804011330w53652286j1349ef7fda29bedb@mail.gmail.com>
Date: Tue, 1 Apr 2008 16:30:14 -0400
From: "Carlo Nyto" <carlonyto@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Slow tape drive timeout
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am experiencing a two minute timeout open()ing a tape device when
there is no tape in the drive.

open() with O_NONBLOCK succeeds immediately, however.

The problem is that I am trying to set up Legato on a system that has
multiple tape drives. For certain common operations, Legato tries to
open() each tape drive multiple times. On a system with multiple tape
drives, this adds up to a significant amount of time wasted due to
this timeout.

Solaris does not have this problem, and Legato support advises that
they are at the mercy of the operating system.

Changing the timeout with e.g. "mt -f /dev/nst0 sttimeout 15" does not
change the timeout to 15 seconds, it is still exactly 2 minutes.

This happens with kernel 2.6.24.4, as well as RedHat's 2.6.9-67.

Here is a snippet of strace -T -tt output:

15:56:18.688392 open("/dev/nst0", O_RDONLY) = -1 ENOMEDIUM (No medium
found) <120.480482>

In this case, the tape device is a Quantum DLT-S4 connected to with an
Emulex FC card, via a Fibre Channel SAN.

Any help would be appreciated. Thanks.
