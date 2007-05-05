Return-Path: <linux-kernel-owner+w=401wt.eu-S1031491AbXEEGce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031491AbXEEGce (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 02:32:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031499AbXEEGce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 02:32:34 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:47730 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031491AbXEEGce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 02:32:34 -0400
Date: Fri, 4 May 2007 23:31:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Johannes Berg <johannes@sipsolutions.net>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH -mm] PM: Separate hibernation code from suspend code
Message-Id: <20070504233135.4671cd98.akpm@linux-foundation.org>
In-Reply-To: <200705041132.32227.rjw@sisk.pl>
References: <200705041132.32227.rjw@sisk.pl>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 May 2007 11:32:31 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> Separate the hibernation (aka suspend to disk code) from the other suspend code.
> In particular:
>  * Remove the definitions related to hibernation from include/linux/pm.h
>  * Introduce struct hibernation_ops and a new hibernate() function to hibernate
>    the system, defined in include/linux/suspend.h
>  * Separate suspend code in kernel/power/main.c from hibernation-related code
>    in kernel/power/disk.c and kernel/power/user.c (with the help of
>    hibernation_ops)
>  * Switch ACPI (the only user of pm_ops.pm_disk_mode) to hibernation_ops

This causes the long-suffering Vaio to fail to power off during suspend
to disk.  It says "Please power me down manually".

<debugs a bit>

machine_ops.halt(); points at native_machine_halt(), which is a no-op.

However `halt -p' still works OK.  How come it is not similarly affected?
