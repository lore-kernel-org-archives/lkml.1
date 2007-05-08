Return-Path: <linux-kernel-owner+w=401wt.eu-S967392AbXEHLuL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967392AbXEHLuL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 07:50:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967381AbXEHLuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 07:50:07 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:36718 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S967338AbXEHLuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 07:50:06 -0400
Date: Tue, 8 May 2007 12:54:11 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: righiandr@users.sourceforge.net
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [RFC][PATCH] VM: per-user overcommit policy
Message-ID: <20070508125411.07de2340@the-village.bc.nu>
In-Reply-To: <463FACF9.2080301@users.sourceforge.net>
References: <463F764E.5050009@users.sourceforge.net>
	<20070507212322.6d60210b@the-village.bc.nu>
	<463FACF9.2080301@users.sourceforge.net>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> When $VERY_CRITICAL_DAEMON dies *all* the users blame the sysadmin [me]. If a
> user application dies because a malloc() returns NULL, the sysadmin [I] can
> blame the user saying: "hey! _you_ tried to hog the machine and _your_
> application is not able to handle the NULL result of the malloc()s!"... :-)

If you allow overcommit by the daemons and not user space then some of
the time you will still get out of memory kills which may well hit your
daemon process.

> A solution could be to define the critical processes unkillable via
> /proc/<pid>/oom_adj, but the per-process approach doesn't resolve all the
> possible cases and it's quite difficult to manage in big environments, like HPC
> clusters.

If you are running no overcommit you should never get an out of memory
kill.

> Anyway, it seems that I need to deepen my knowledge about the recent development
> of process containers and openvz...

I think that does what you need - you'd create containers for critical
services and for the users and split resources to protect one from the
other.
