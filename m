Return-Path: <linux-kernel-owner+w=401wt.eu-S1754586AbZBVVIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586AbZBVVIg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 16:08:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752842AbZBVVI2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 16:08:28 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38800 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752841AbZBVVI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 16:08:27 -0500
Date: Sun, 22 Feb 2009 13:07:28 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Adrian Bunk <bunk@kernel.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH 1/2] PM: Split up sysdev_[suspend|resume] from
 device_power_[down|up]
In-Reply-To: <20090222205654.GC4485@localhost.pp.htv.fi>
Message-ID: <alpine.LFD.2.00.0902221306090.3111@localhost.localdomain>
References: <200902221837.49396.rjw@sisk.pl> <200902221838.51548.rjw@sisk.pl> <20090222205654.GC4485@localhost.pp.htv.fi>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 22 Feb 2009, Adrian Bunk wrote:
> ...
>   MODPOST 2586 modules
> ERROR: "sysdev_resume" [arch/x86/kernel/apm.ko] undefined!
> ERROR: "sysdev_suspend" [arch/x86/kernel/apm.ko] undefined!
> make[2]: *** [__modpost] Error 1

Ahh. device_power_[down|up] were EXPORT_SYMBOL_GPL, so now that we've 
split them, so must sysdev_[suspend|resume] be.

Does this fix it?

		Linus
---
 drivers/base/sys.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/base/sys.c b/drivers/base/sys.c
index c98c31e..ef2055e 100644
--- a/drivers/base/sys.c
+++ b/drivers/base/sys.c
@@ -432,6 +432,7 @@ aux_driver:
 	}
 	return ret;
 }
+EXPORT_SYMBOL_GPL(sysdev_suspend);
 
 
 /**
@@ -463,6 +464,7 @@ int sysdev_resume(void)
 	}
 	return 0;
 }
+EXPORT_SYMBOL_GPL(sysdev_resume);
 
 
 int __init system_bus_init(void)
