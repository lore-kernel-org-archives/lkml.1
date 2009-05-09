Return-Path: <linux-kernel-owner+w=401wt.eu-S1753416AbZEIIGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416AbZEIIGZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 04:06:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751817AbZEIIGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 04:06:00 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:59849 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbZEIIF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 04:05:58 -0400
Date: Sat, 9 May 2009 10:05:57 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       michael@araneidae.co.uk
Subject: /proc/uptime idle counter remains at 0
Message-ID: <alpine.LSU.2.00.0905090957490.27646@fbirervta.pbzchgretzou.qr>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


starting from v2.6.28-4930-g79741dd lasting thru at least v2.6.29.1,
the second field of /proc/uptime always shows 0.00. This happens for
both the typical i386 (my case) and on an ARM (according to Michael,
cc'ed).

>From the commit log of 79741dd:

	"""The cpu time spent by the idle process actually doing
	something is currently accounted as idle time. This is plain
	wrong, the architectures that support VIRT_CPU_ACCOUNTING=y
	can do better: distinguish between the time spent doing
	nothing and the time spent by idle doing work. The first is
	accounted with account_idle_time and the second with
	account_system_time."""

Citing Michael from our irc conversation:

	"""the writer[committer] [says] that [the] idle process time
	isn't really idle time ... but that's all that /proc/uptime
	looks at. I guess fs/proc/uptime.c needs to catch up."""

So, were the updates to uptime.c missed, or do we now live on with
/proc/uptime constantly having 0?



Jan
