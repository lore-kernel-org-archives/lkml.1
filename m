Return-Path: <linux-kernel-owner+w=401wt.eu-S1755412AbYESATQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412AbYESATQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 20:19:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753374AbYESAS7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 20:18:59 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:4744 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753368AbYESAS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 20:18:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=PmvBG0Ya0/hd+AIWiJwYaaLooSmQX6uN4yI63zkIe93DkzCGKmli8m9XIulM8srzhuJ/PeEpMv7ZxI3d3P6AVuMOteJotSqhkmMaeae+n5upx78DPE9ORYG57k+L6UPDZK8Qk5qkWy6yIoaPXpc1Viq5ExVI+So9pCZ6ZT8fQac=
Subject: [BUG] Winchip2A + 2.6.25 = klogd 100% CPU, /proc/mtrr busted
From: David Hagood <david.hagood@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 18 May 2008 19:18:49 -0500
Message-Id: <1211156329.7192.16.camel@surfer>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm trying to resurrect an old laptop based on the Winchip2A, but I am
unable to get a 2.6.25 kernel built that works.

I've tried various combinations of gcc versions (4.1, 4.2.3, 4.3
snapshots), various build options, and in all cases I get the same
symptoms:

1) klogd will take 100% CPU time once the system is up.
2) attempting to access /proc/mtrr will yield "Input/output error"

strace'ing the klogd process yields:
syslog(0x2, 0x804d6e0, 0xfff)           = -1 EPERM (Operation not
permitted)
write(2, "klogd: Error return from sys_syc"..., 65) = -1 EBADF (Bad file
descriptor)

I've tried building the kernel targeting the WinChip2a, the WinChip2,
generic 586, with no preemption, preemption, no optimize for size,
optimize for size.

The funny thing is that if I run the stock kernels as built by Ubuntu
this does not happen, and if I build a kernel in the same way for my
Athlon machines it works.

Has anybody else seen this?


