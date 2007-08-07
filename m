Return-Path: <linux-kernel-owner+w=401wt.eu-S935449AbXHGUs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935449AbXHGUs4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 16:48:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934824AbXHGUrH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:47:07 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51369 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935144AbXHGUrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:47:04 -0400
Date: Tue, 7 Aug 2007 13:43:08 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, bunk@stusta.de,
       Ingo Molnar <mingo@elte.hu>, "David S. Miller" <davem@davemloft.net>
Subject: [2.6.22.2 review 09/84] Fix rfkill IRQ flags.
Message-ID: <20070807204308.GJ23028@kroah.com>
References: <20070807204034.882009319@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-rfkill-irq-flags.patch"
In-Reply-To: <20070807204157.GA23028@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>

[RFKILL]: fix net/rfkill/rfkill-input.c bug on 64-bit systems

Subject: [2.6.22.2 review 09/84] [patch] net/input: fix net/rfkill/rfkill-input.c bug on 64-bit systems

this recent commit:

 commit cf4328cd949c2086091c62c5685f1580fe9b55e4
 Author: Ivo van Doorn <IvDoorn@gmail.com>
 Date:   Mon May 7 00:34:20 2007 -0700

     [NET]: rfkill: add support for input key to control wireless radio

added this 64-bit bug:

        ....
	unsigned int flags;

 	spin_lock_irqsave(&task->lock, flags);
        ....

irq 'flags' must be unsigned long, not unsigned int. The -rt tree has
strict checks about this on 64-bit so this triggered a build failure.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/rfkill/rfkill-input.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/rfkill/rfkill-input.c
+++ b/net/rfkill/rfkill-input.c
@@ -55,7 +55,7 @@ static void rfkill_task_handler(struct w
 
 static void rfkill_schedule_toggle(struct rfkill_task *task)
 {
-	unsigned int flags;
+	unsigned long flags;
 
 	spin_lock_irqsave(&task->lock, flags);
 

-- 
