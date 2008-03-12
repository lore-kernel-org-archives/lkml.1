Return-Path: <linux-kernel-owner+w=401wt.eu-S1755238AbYCLWCe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238AbYCLWCe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 18:02:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753524AbYCLWCQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 18:02:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41454 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753462AbYCLWCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 18:02:15 -0400
Date: Wed, 12 Mar 2008 15:00:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Ralf Baechle <ralf@linux-mips.org>, David Howells <dhowells@redhat.com>
Subject: pm_register() and pm_send_all()
Message-Id: <20080312150042.96668bcd.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This:

kernel/power/pm.c:203: warning: 'pm_register' is deprecated (declared at kernel/power/pm.c:62)
kernel/power/pm.c:203: warning: 'pm_register' is deprecated (declared at kernel/power/pm.c:62)
kernel/power/pm.c:204: warning: 'pm_send_all' is deprecated (declared at kernel/power/pm.c:178)
kernel/power/pm.c:204: warning: 'pm_send_all' is deprecated (declared at kernel/power/pm.c:178)

is getting a bit boring.  These were marked deprecated at least three years
ago.


pm_register() no longer has any callers and afacit can be removed
immediately.

pm_send_all() has just a handful of callers:

arch/x86/kernel/apm_32.c
arch/mips/au1000/common/power.c
arch/frv/kernel/pm.c

could we please get a bit of a push on this?  How should these
pm_send_all() calls be replaced?

Thanks.

(I almost have a warning-free x86_64 allmodconfig, but the one in
drivers/message/i2o/i2o_config.c is going to be a problem).

