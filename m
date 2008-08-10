Return-Path: <linux-kernel-owner+w=401wt.eu-S1755517AbYHJPSN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517AbYHJPSN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 11:18:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753584AbYHJPR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 11:17:59 -0400
Received: from pruts.nl ([82.94.235.106]:51375 "EHLO iron.pruts.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752357AbYHJPR6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 11:17:58 -0400
X-Greylist: delayed 527 seconds by postgrey-1.27 at vger.kernel.org; Sun, 10 Aug 2008 11:17:58 EDT
Date: Sun, 10 Aug 2008 17:08:59 +0200
From: Ico Doornekamp <lkml@zevv.nl>
To: linux-kernel@vger.kernel.org
Subject: TIOCGWINSZ retuns old pty size after receiving SIGWINCH
Message-ID: <20080810150859.GO3653@pruts.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Prutser: true
X-PGP-key: 4202FA2F
X-PGP-KeyServer: subkeys.pgp.net
X-PGP-Fingerprint: F042 F5CD B0A6 EC6A CB80  A829 CACD A4B5 4202 FA2F
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,

Recently my X terminals showed annoying behaviour where the application
in the terminal was not resized properly to the actual size of the X
terminal emulator window, resulting in a lot of misaligned text on the
screen. Hunting the issue down from the windowmanager and the terminal
emulator program, I suspect the problem might lie in the kernel. I'm
running 2.6.26 on a dual core i386.

What I see is this: the userspace application receives a SIGWINCH signal
and acquires the terminal size usign the TIOCGWINSZ ioctl. It seems that
in some cases the old instead of the new terminal size is returned.
A small delay before the ioctl seems to 'fix' this behaviour.

I noticed some changes involving locking in the the pty code in the last
kernel verions, could one of these changes cause the above behaviour ? If
so, wouldn't this affect much more users ?

Ico

-- 
:wq
^X^Cy^K^X^C^C^C^C
