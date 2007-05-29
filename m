Return-Path: <linux-kernel-owner+w=401wt.eu-S1763248AbXE2Rkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763248AbXE2Rkn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 13:40:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752943AbXE2Rkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 13:40:36 -0400
Received: from mx2.compro.net ([216.54.166.4]:43152 "EHLO mx2.compro.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752775AbXE2Rkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 13:40:35 -0400
X-Greylist: delayed 581 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 May 2007 13:40:35 EDT
X-IronPort-AV: E=Sophos;i="4.14,589,1170651600"; 
   d="scan'208";a="394993"
Message-ID: <465C6359.1020106@compro.net>
Date: Tue, 29 May 2007 13:31:05 -0400
From: Mark Hounschell <markh@compro.net>
Reply-To: markh@compro.net
Organization: Compro Computer Svcs.
User-Agent: Thunderbird 1.5.0.10 (X11/20060911)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: floppy.c soft lockup
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Changes in floppy.c from 2.6.17 and 2.6.18 have broken an application I have. I have tracked 
it down to a single line of code. When the following patch is applied to the version in 2.6.18
my application works.

--- linux-2.6.18/drivers/block/floppy.c 2006-09-19 23:42:06.000000000 -0400
+++ linux-2.6.18-crt/drivers/block/floppy.c     2007-05-29 09:12:20.000000000 -0400
@@ -893,7 +893,6 @@
                set_current_state(TASK_RUNNING);
                remove_wait_queue(&fdc_wait, &wait);

-               flush_scheduled_work();
        }
        command_status = FD_COMMAND_NONE;

I don't claim to understand the changes from 2.6.17 to 2.6.18 except for the devfs removal.
All I can say is this one line of code kills the application. I have tried to write a short pgm
that shows my problem but everything else I write seems to work. The application only runs
on SMP machines and uses process and irq affinities with real-time scheduling. When I turn
off process and irq affinities the application runs. 

I have tried kernels up through 2.6.21.1 with the same results. All kernels from 2.6.18 up
require that I remove this one line of code or my application does not work?

Regards
Mark



