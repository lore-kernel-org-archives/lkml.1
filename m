Return-Path: <linux-kernel-owner+w=401wt.eu-S1757176AbZKROGH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757176AbZKROGH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 09:06:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756888AbZKROGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 09:06:07 -0500
Received: from tac.ki.iif.hu ([193.6.222.43]:57940 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756835AbZKROGG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 09:06:06 -0500
From: Ferenc Wagner <wferi@niif.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm@lists.linux-foundation.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>, yakui.zhao@intel.com,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Subject: Re: [linux-pm] intermittent suspend problem again
References: <87fx93pwv2.fsf@tac.ki.iif.hu> <200911132059.46377.rjw@sisk.pl>
	<874ooxho2b.fsf@tac.ki.iif.hu> <200911141952.50030.rjw@sisk.pl>
Date: Wed, 18 Nov 2009 15:05:47 +0100
In-Reply-To: Ferenc Wagner's message of "Wed\, 18 Nov 2009 02\:12\:32 +0100"
Message-ID: <87r5rwrkqs.fsf@tac.ki.iif.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ferenc Wagner <wferi@niif.hu> writes:

> Since I've instrumented s2disk and the hibernation path, no freeze
> happened during hibernating the machine.

Not until I removed the delays from hibernation_platform_enter(), which
were put there previously to get step-by-step feedback.  Removing them
again resulted in a freeze in short course, maybe just two hibernations
later.  The instrumentation shows it stuck in dpm_suspend_start(PMSG_HIBERNATE).
Does it mean that some device driver is at fault?  I'll check if it
always fails at the same point (although tracing into dpm_suspend_start
isn't pure fun because of the multitude of devices it loops over).  Is
there any way to get printk output from that phase?

Side question: If I run s2disk from the init=/bin/bash prompt, the
instrumentation in acpi_enter_sleep_state_prep in drivers/acpi/acpica/hwsleep.c
fires before the "Snapshotting system" phase, but it does not fire if I
hibernate from the full running desktop.  (That instrumentation was put
there to investigate the KMS-triggered STR freeze.)  What could explain
this?
-- 
Thanks,
Feri.
