Return-Path: <linux-kernel-owner+w=401wt.eu-S965291AbXDBJei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965291AbXDBJei (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 05:34:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965297AbXDBJei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 05:34:38 -0400
Received: from www.osadl.org ([213.239.205.134]:60808 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965291AbXDBJeh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 05:34:37 -0400
Subject: Re: Clockevents: one-shoot mode is never enabled if local apic
	timer is disabled
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200704021157.03368.maximlevitsky@gmail.com>
References: <200704021157.03368.maximlevitsky@gmail.com>
Content-Type: text/plain
Date: Mon, 02 Apr 2007 11:34:44 +0200
Message-Id: <1175506484.28263.101.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Maxim,

can you please fix your mail client to do proper line wraps at 78
chars ?

On Mon, 2007-04-02 at 11:57 +0300, Maxim Levitsky wrote:
> Hi,
> 
> I finally figured out why one-shoot mode is enabled on my system only
> and only if local apic is enabled.

You could have asked me :)

> I tried to remove this check and this resulted in hard lock-up during
> boot with nolapic_timer
> Maybe this was connected to the fact that this function is called on
> both cpus, and if one set a 
> broadcasting device(HPET) to one shoot mode, second is still not aware
> of this.
> 
> Is it a bug or feature ?

One shot mode - used for NO_HZ and HIGH_RES - requires a working per cpu
timer.

When you disable the lapic timers, then we register the lapic timers
just as dummy devices to utilize the broadcast mechanism. Otherwise the
second CPU would be not working at all. I decided not to enable
nohz/highres when we have no usable per cpu devices available. 

So consider it a feature :)

	tglx


