Return-Path: <linux-kernel-owner+w=401wt.eu-S1758970AbZA2X7I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758970AbZA2X7I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 18:59:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753279AbZA2X6z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 18:58:55 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51360
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752905AbZA2X6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 18:58:54 -0500
Date: Thu, 29 Jan 2009 15:58:52 -0800 (PST)
Message-Id: <20090129.155852.161923905.davem@davemloft.net>
To: tglx@linutronix.de, mingo@redhat.com
CC: linux-kernel@vger.kernel.org
Subject: x86's nmi_hz wrt. oprofile's nmi_timer_int.c
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


While working on an NMI watchdog implementation on sparc64
I noticed what seems to be a peculiar behavior of the NMI
timer int oprofile support on x86.

When the NMI watchdog tests itself at boot timer we start
with nmi_hz equal to HZ.

After the NMI watchdog self-test passes, nmi_hz is reduced
down to '1'.

The NMI timer int oprofile support simply uses DIE_NMI notifiers for
it's implementation.  But I don't see anything in the code of
arch/x86/oprofile/nmi_timer_int.c nor the NMI watchdog infrastructure
which will re-adjust nmi_hz back to HZ or something similar.

Am I missing something?
