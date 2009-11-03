Return-Path: <linux-kernel-owner+w=401wt.eu-S1752055AbZKCFwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055AbZKCFwj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 00:52:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751326AbZKCFwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 00:52:38 -0500
Received: from casper.infradead.org ([85.118.1.10]:59912 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915AbZKCFwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 00:52:37 -0500
Date: Mon, 2 Nov 2009 21:53:58 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Anssi Hannula <anssi.hannula@gmail.com>,
       Jussi Kivilinna <jussi.kivilinna@mbnet.fi>, linux-input@vger.kernel.org
Subject: Re: [PATCH] input: fix locking context in ml_ff_set_gain
Message-ID: <20091102215358.5398c8c1@infradead.org>
In-Reply-To: <20091103054446.GB3212@core.coreip.homeip.net>
References: <20091031141925.149c9874@infradead.org>
	<20091102063818.GB3354@core.coreip.homeip.net>
	<20091103054446.GB3212@core.coreip.homeip.net>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> OK, it ended up being pretty simple. Anssi, any chance you could test
> it to make sure I did not screw up? Thanks!
> 
@@ -371,35 +370,34 @@ static void ml_effect_timer(unsigned long
timer_data) 
 	debug("timer: updating effects");
 
-	spin_lock(&ml->timer_lock);
+	spin_lock_irq(&dev->event_lock);
 	ml_play_effects(ml);
-	spin_unlock(&ml->timer_lock);
+	spin_unlock_irq(&dev->event_lock);
 }

this bit looks evil.

might be better off as irqsave...


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
