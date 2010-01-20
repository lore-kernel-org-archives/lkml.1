Return-Path: <linux-kernel-owner+w=401wt.eu-S1753732Ab0ATRTn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732Ab0ATRTn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 12:19:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753688Ab0ATRTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 12:19:40 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:10382 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753667Ab0ATRTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 12:19:38 -0500
Subject: Re: [PATCH] powernow-k8: On load failure, remind the user to
 enable support in BIOS setup
From: Marti Raudsepp <marti@juffo.org>
To: Thomas Renninger <trenn@suse.de>
Cc: cpufreq@vger.kernel.org, Dave Jones <davej@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       Mark Langsdorf <mark.langsdorf@amd.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <201001201656.51376.trenn@suse.de>
References: <160211accaba09e778c6.1264001606@newn>
	 <201001201656.51376.trenn@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Jan 2010 19:19:33 +0200
Message-ID: <1264007973.18960.45.camel@newn>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-20 at 16:56 +0100, Thomas Renninger wrote:
> But most often this happens if people upgrade their CPU and do not 
> update their BIOS.
> Or the vendor does not recognise the new CPU even if the BIOS got 
> updated.

Maybe some of those people just didn't realize it was disabled in BIOS?
If you tell users that it's a firmware bug then they'll probably just
give up.

> The itself message might be an enhancment, IMO it's not worth a patch.

Why do you think so? I spent an hour on hunting down the BIOS upgrade,
only to find that it didn't improve anything. It was a day later that I
realized that it might be a BIOS option; and the option was literally
the _last_ option in the whole BIOS setup. :)

This message would have saved the day.

> But do not revert the FW_BUG part!

Sure, you have a point here.

How about this patch?

---
powernow-k8: On load failure, tell user to update BIOS and enable in BIOS setup

Signed-off-by: Marti Raudsepp <marti@juffo.org>

diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -800,6 +800,8 @@
 	 * www.amd.com
 	 */
 	printk(KERN_ERR FW_BUG PFX "No PSB or ACPI _PSS objects\n");
+	printk(KERN_ERR PFX "Make sure that your BIOS is up to date"
+		" and Cool'N'Quiet support is enabled in BIOS setup\n");
 	return -ENODEV;
 }
 



