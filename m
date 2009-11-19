Return-Path: <linux-kernel-owner+w=401wt.eu-S1752444AbZKSNCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752444AbZKSNCR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 08:02:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752074AbZKSNCR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 08:02:17 -0500
Received: from tac.ki.iif.hu ([193.6.222.43]:39100 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751626AbZKSNCQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 08:02:16 -0500
From: Ferenc Wagner <wferi@niif.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, yakui.zhao@intel.com,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: intermittent suspend problem again
References: <87fx93pwv2.fsf@tac.ki.iif.hu> <200911141952.50030.rjw@sisk.pl>
	<87r5rwrkqs.fsf@tac.ki.iif.hu> <200911182313.14092.rjw@sisk.pl>
	<877htmragv.fsf@tac.ki.iif.hu>
Date: Thu, 19 Nov 2009 14:02:14 +0100
In-Reply-To: <877htmragv.fsf@tac.ki.iif.hu> (Ferenc Wagner's message of "Thu,
	19 Nov 2009 13:00:00 +0100")
Message-ID: <87zl6ipt0p.fsf@tac.ki.iif.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ferenc Wagner <wferi@niif.hu> writes:

> Ferenc Wagner <wferi@niif.hu> writes:
>
>> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
>>
>>> On Wednesday 18 November 2009, Ferenc Wagner wrote:
>>>
>>>> Ferenc Wagner <wferi@niif.hu> writes:
>>>> 
>>>> Side question: If I run s2disk from the init=/bin/bash prompt, the
>>>> instrumentation in acpi_enter_sleep_state_prep in drivers/acpi/acpica/hwsleep.c
>>>> fires before the "Snapshotting system" phase, but it does not fire if I
>>>> hibernate from the full running desktop.  (That instrumentation was put
>>>> there to investigate the KMS-triggered STR freeze.)  What could explain
>>>> this?
>>>
>>> It looks like it uses the "shutdown" method when run with init=/bin/bash, but
>>> I don't know why exactly.
>>
>> Thanks for the tip, I'll check this too.
>
> While looking into this, I found a reproducible kernel panic:
>
> 1. boot with init=/bin/bash
> 2. mount /usr; swapon -a
> 3. plug in a USB pendrive
> 4. s2disk (machine goes to sleep)
> 5. power on, proceed with resuming, press Enter to cancel resume pause
> 6. ACPI: Hardware changed while hibernated, cannot resume!
>    Kernel panic - not syncing: ACPI S4 hardware signature mismatch
>
> Does it make sense?

Yes it does: it's the BIOS USB support playing its childish games.
I can disable it most of the time, except when booting from USB...

I wonder if this problem sould be handled more gracefully, now that USB
persistence is enabled by default.  It works just fine for STR, but
potentially panics after hibernation.
-- 
Regards,
Feri.
