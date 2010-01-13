Return-Path: <linux-kernel-owner+w=401wt.eu-S1754896Ab0AMN2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896Ab0AMN2Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 08:28:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753341Ab0AMN2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 08:28:15 -0500
Received: from casper.infradead.org ([85.118.1.10]:49160 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237Ab0AMN2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 08:28:15 -0500
Subject: Re: 2.6.33-rc3-mmotm0106 - BUG: MAX_LOCKDEP_KEYS too low!
From: Peter Zijlstra <peterz@infradead.org>
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <30283.1263363729@localhost>
References: <30283.1263363729@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Jan 2010 14:28:08 +0100
Message-ID: <1263389288.4244.222.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-13 at 01:22 -0500, Valdis.Kletnieks@vt.edu wrote:
> Seen in my dmesg output - I wasn't even home at the time, so my
> laptop was basically idle.
> 
> [ 7777.019267] dell-wmi: Received unknown WMI event (0x11)
> [ 8190.620401] BUG: MAX_LOCKDEP_KEYS too low!

> If I'm hitting MAX_LOCKDEP_KEYS after just a few hours on a mostly-idle
> laptop, should it be set higher?

I'm wondering what's eating all those classes, it there a lot of module
loading/unloading happening?

Does something like the below give any clues?

---
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 5feaddc..90b9428 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -761,6 +761,7 @@ register_lock_class(struct lockdep_map *lock,
unsigned int subclass, int force)
 	debug_atomic_inc(&nr_unused_locks);
 	class->key = key;
 	class->name = lock->name;
+	printk(KERN_EMERG "LOCK CLASS: %s\n", lock->name);
 	class->subclass = subclass;
 	INIT_LIST_HEAD(&class->lock_entry);
 	INIT_LIST_HEAD(&class->locks_before);


