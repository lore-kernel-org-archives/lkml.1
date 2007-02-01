Return-Path: <linux-kernel-owner+w=401wt.eu-S1161250AbXBACms@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161250AbXBACms (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 21:42:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161249AbXBACms
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 21:42:48 -0500
Received: from nigel.suspend2.net ([203.171.70.205]:46704 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933354AbXBACmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 21:42:47 -0500
Subject: Re: [RFC PATCH -rt 2/2] RCU priority boosting additions to
	rcutorture
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       dipankar@in.ibm.com, tytso@us.ibm.com, dvhltc@us.ibm.com,
       oleg@tv-sign.ru, twoerner.k@gmail.com, josh@freedesktop.org,
       billh@gnuppy.monkey.org, nielsen.esben@googlemail.com, corbet@lwn.net
In-Reply-To: <20070201023149.GV2574@linux.vnet.ibm.com>
References: <20070201012136.GA21770@linux.vnet.ibm.com>
	 <20070201012653.GB22922@linux.vnet.ibm.com>
	 <1170295936.32500.1.camel@nigel.suspend2.net>
	 <20070201023149.GV2574@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Thu, 01 Feb 2007 13:42:42 +1100
Message-Id: <1170297763.32500.7.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul.

On Wed, 2007-01-31 at 18:31 -0800, Paul E. McKenney wrote:
> Good to hear from you, Nigel!

Thanks :)

> Should indeed be OK to freeze during suspend/hibernate.  Will my
> schedule_timeout_interruptible() be sufficient to allow the freeze
> to happen, or do I need to add an explicit try_to_freeze()?

You need a try_to_freeze() - the process has to enter the refrigerator()
function to be counted as frozen.

> Ah, and I probably need to use the same trick that mtd_blktrans_thread()
> does to avoid having all my sleeps killed of by an errant signal:
> 
> 	spin_lock_irq(&current->sighand->siglock);
> 	sigfillset(&current->blocked);
> 	recalc_sigpending();
> 	spin_unlock_irq(&current->sighand->siglock);
> 
> Or is such paranoia unnecessary?

Yeah. try_to_freeze() is a function now, so you can do something if
(try_to_freeze()) goto sleep_again if you so desire.

Regards,

Nigel

