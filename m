Return-Path: <linux-kernel-owner+w=401wt.eu-S1756861AbZJFJwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756861AbZJFJwY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 05:52:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756823AbZJFJwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 05:52:23 -0400
Received: from smtp.nokia.com ([192.100.122.233]:52120 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756805AbZJFJwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 05:52:23 -0400
Date: Tue, 6 Oct 2009 12:48:45 +0300
From: Felipe Balbi <felipe.balbi@nokia.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: alan@lxorguk.ukuu.org.uk, dbrownell@users.sourceforge.net
Subject: TTY loosing bytes ?
Message-ID: <20091006094845.GT4452@nokia.com>
Reply-To: felipe.balbi@nokia.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 06 Oct 2009 09:50:24.0060 (UTC) FILETIME=[6CE057C0:01CA466A]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I'm facing a weird issue with TTY when using u_serial gadget.

The problem seems to be related to ldisc's buffer getting full. Imagine
a situation where you have 510 bytes available on N_TTY's buffer and you
try to flush 512 bytes then the code path would look like:

--> flush_to_ldisc();
	--> n_tty_receive_buf(512 bytes);
		--> i = 510;
		--> memcpy(i);

		--> i = 0;
		--> memcpy(i);
	<-- wake_up_interruptible();

What happens is that we loose those 2 extra bytes. I tried digging this
problem and try to find a fix for it but it's been really complicated
for me.

Hope you guys can help. Actually, I've been reproducing the problem on
2.6.28 but looking at the code current mainline should have the same
problem. I also cherry-picked the relevant patches to my 2.6.28 tree
(hope I got all of them) and it still failed.

Sorry I'm reporting such a problem with such an old kernel but upgrading
the kernel right now is just impossible.

If you guys could give any pointers I would be really glad.

-- 
balbi
