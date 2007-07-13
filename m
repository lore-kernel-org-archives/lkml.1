Return-Path: <linux-kernel-owner+w=401wt.eu-S935998AbXGMOdw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935998AbXGMOdw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 10:33:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759744AbXGMOdo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 10:33:44 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:45064 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758007AbXGMOdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 10:33:43 -0400
Date: Fri, 13 Jul 2007 10:33:41 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Kernel development list <linux-kernel@vger.kernel.org>
Subject: [Bug 7750] open/close loop causes disabled irq (fwd)
Message-ID: <Pine.LNX.4.44L0.0707131030280.4865-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan:

Can this be ignored, or is it a case of a patch papering over a real
problem?  It seems possible that some serial driver is leaving device
IRQs enabled after it has unregistered itself as an interrupt handler.

Alan Stern


---------- Forwarded message ----------
Date: Thu, 12 Jul 2007 20:02:25 -0700 (PDT)
From: bugme-daemon@bugzilla.kernel.org
To: stern@rowland.harvard.edu
Subject: [Bug 7750] open/close loop causes disabled irq

http://bugzilla.kernel.org/show_bug.cgi?id=7750





------- Comment #4 from dannf@dannf.org  2007-07-12 20:07 -------
I attempted to reproduce this today under 2.6.22 and was unable to. I then used
git bisect to try and identify the changeset that fixed the issue and ended up
with the one below.

I wonder if this should be considered a security issue (DoS)?

commit 8528b0f1de1101c6002036fd53638fb21111d0ea
Author: Linus Torvalds <torvalds@woody.linux-foundation.org>
Date:   Tue Jan 23 14:16:31 2007 -0800

    Clear spurious irq stat information when adding irq handler

    Any newly added irq handler may obviously make any old spurious irq
    status invalid, since the new handler may well be the thing that is
    supposed to handle any interrupts that came in.

    So just clear the statistics when adding handlers.

    Pointed-out-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
    Acked-by: Thomas Gleixner <tglx@linutronix.de>
    Acked-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

:040000 040000 d3bd3ddf15462bca9f796e899b96f2e17d30bc34
3ea41ebe53747377873202db8b59e2c4e84aef8c M      kernel


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are on the CC list for the bug, or are watching someone who is.


