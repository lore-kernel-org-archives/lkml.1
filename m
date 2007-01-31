Return-Path: <linux-kernel-owner+w=401wt.eu-S965125AbXAaPOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965125AbXAaPOp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 10:14:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965161AbXAaPOp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 10:14:45 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:14441 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965038AbXAaPOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 10:14:43 -0500
Subject: Re: [PATCH 08/23] clocksource: drop duplicate register checking
From: Daniel Walker <dwalker@mvista.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, johnstul@us.ibm.com,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20070131095935.GA22377@elte.hu>
References: <20070131033710.420168478@mvista.com>
	 <20070131033805.498958666@mvista.com>  <20070131095935.GA22377@elte.hu>
Content-Type: text/plain
Date: Wed, 31 Jan 2007 07:13:13 -0800
Message-Id: <1170256393.9781.23.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-01-31 at 10:59 +0100, Ingo Molnar wrote:
> * Daniel Walker <dwalker@mvista.com> wrote:
> 
> > This is something Thomas already dropped, [...]
> 
> (i think you forgot to Cc: Thomas here, nor is this something that 
> Thomas' change dropped.)

Yes your right .

> > [...] and I'm just sticking with that .. If you register your 
> > clocksource _twice_ your kernel will likely not work correctly (and 
> > might crash).
> 
> this is a quite bad change. John's original clocksource code protects 
> against double registry:
> 
>          if (is_registered_source(c)) {
>                  printk("register_clocksource: Cannot register %s. "
>                         "Already registered!", c->name);
>                  ret = -EBUSY;
> 
> and Thomas' change keeps that property, but doesnt printk. Your change 
> makes double registry possible, potentially crashing the kernel later 
> on! (And this isnt theoretical, double registry did happen in practice 
> when i debugged suspend problems on my SMP laptop.)

My original patch set makes the duplicate register checking better
(which I dropped) .. I'll be happy to reintroduce that part of it..

Daniel

