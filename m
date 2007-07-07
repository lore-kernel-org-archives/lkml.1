Return-Path: <linux-kernel-owner+w=401wt.eu-S1755363AbXGGTCn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363AbXGGTCn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 15:02:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752588AbXGGTCg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 15:02:36 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:54737 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766AbXGGTCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 15:02:36 -0400
X-Originating-Ip: 74.102.207.204
Date: Sat, 7 Jul 2007 15:00:28 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Al Viro <viro@zeniv.linux.org.uk>
Subject: schedule_timeout() called with state TASK_RUNNING from fs/select.c
Message-ID: <Pine.LNX.4.64.0707071454090.4114@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-36.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  as i understand it, schedule_timeout() should always be called with
a current->state of TASK_INTERRUPTIBLE or TASK_UNINTERRUPTIBLE, no?
based on a trivial check i added to kernel/timer.c, i can read this in
/var/log/messages:

...
Jul  7 14:48:40 localhost kernel: Bad schedule_timeout state: 0 from Xorg, c015eeb9
Jul  7 14:49:05 localhost kernel: Bad schedule_timeout state: 0 from gnome-terminal, c015ea47
Jul  7 14:50:19 localhost kernel: Bad schedule_timeout state: 0 from Xorg, c015eeb9
Jul  7 14:50:50 localhost kernel: Bad schedule_timeout state: 0 from Xorg, c015eeb9
...

  those last values are __builtin_return_address(0), and here's the
snippet from /proc/kallsyms:

...
c015e7f2 T do_sys_poll
c015eb19 T sys_poll
c015eb50 T do_select
c015ef10 t core_sys_select
...

  i'm guessing those addresses correspond to the calls to
schedule_timeout() in do_sys_poll() and do_select(), if anyone thinks
it's worth looking at.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
