Return-Path: <linux-kernel-owner+w=401wt.eu-S1756537AbYFKOEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537AbYFKOEe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 10:04:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752885AbYFKOEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 10:04:24 -0400
Received: from shadow.wildlava.net ([67.40.138.81]:49155 "EHLO
	shadow.wildlava.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749AbYFKOEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 10:04:23 -0400
Message-ID: <484FDB63.6050504@skyrush.com>
Date: Wed, 11 Jun 2008 08:04:19 -0600
From: Joe Peterson <joe@skyrush.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Alan Cox <alan@redhat.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, David Newall <davidn@davidnewall.com>,
       Willy Tarreau <w@1wt.eu>, Harald Dunkel <harald.dunkel@t-online.de>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.25.3: su gets stuck for root
References: <48438126.3080308@t-online.de> <20080602053256.GF5609@1wt.eu> <20080602091016.571dda7c@core> <4843B6EE.8080104@davidnewall.com> <20080602102033.63e4cd18@core> <48441138.90503@skyrush.com> <20080602155133.GC933@devserv.devel.redhat.com> <4846A9F4.40003@skyrush.com> <20080604151649.GB12625@devserv.devel.redhat.com> <4846C85E.7080309@skyrush.com> <20080604171056.GB17875@devserv.devel.redhat.com> <4846FBF2.9010206@skyrush.com>
In-Reply-To: <4846FBF2.9010206@skyrush.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Peterson wrote:
> Anyway, here is more info:
> 
> tty_check_change: current->signal->tty = f7880800
> tty_check_change: tty = f7880800
> tty_check_change: tty->pgrp = f7b99e40
>   tty->pgrp->count = 5
>   tty->pgrp->level = 0
>   tty->pgrp->numbers[0].nr = 6951
> tty_check_change: task_pgrp(current) = f7b99d40
>   task_pgrp(current)->count = 1
>   task_pgrp(current)->level = 0
>   task_pgrp(current)->numbers[0].nr = 6952
> tty_check_change: kill_pgrp called; returning -ERESTARTSYS
> set_termios: error return value (-512) from tty_check_change
> foo       6951  0.0  0.1   2332  1096 tty1     S+   14:18   0:00 su foo
> foo       6952  0.0  0.1   2988  1464 tty1     S    14:18   0:00 bash
> 
> 
> So, looks like the tty->pgrp's process is the "su" command itself, and
> the task_pgrp(current)'s process is "bash" - the shell started by the su.

If anyone has any tips for my further debugging of this, given the
above, let me know.  I'd like to help resolve this.

					Thanks!  Joe
