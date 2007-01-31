Return-Path: <linux-kernel-owner+w=401wt.eu-S1030212AbXAaREJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030212AbXAaREJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 12:04:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030277AbXAaREI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 12:04:08 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:34138 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030212AbXAaREH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 12:04:07 -0500
Subject: Re: [PATCH 23/23] clocksource tsc: add verify routine
From: Daniel Walker <dwalker@mvista.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, johnstul@us.ibm.com,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20070131124300.GG1847@elte.hu>
References: <20070131033710.420168478@mvista.com>
	 <20070131033810.319576375@mvista.com>  <20070131124300.GG1847@elte.hu>
Content-Type: text/plain
Date: Wed, 31 Jan 2007 09:02:35 -0800
Message-Id: <1170262956.9781.117.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-01-31 at 13:43 +0100, Ingo Molnar wrote:
> * Daniel Walker <dwalker@mvista.com> wrote:
> 
> > I've included this as another user of the clocksource interface. I 
> > don't see a usage for this across all achitectures. So a fully generic 
> > version isn't needed.
> 
> well, this implementation is buggy in at least two ways:
> 
> firstly, it allows a circular verification dependency in highres+dyntick 
> mode between the jiffies and tsc clocksources.

In the current implementation, it's only happens if the only clocks that
exist are "tsc" and "jiffies" which makes verification impossible
anyway .. It's unlikely, but it is possible , the fix is not that
complex.

> secondly, verification is not done while the system is booting up:

Do you know that this is needed ? The current implementation
(clocksource watchdog) doesn't fully settle until after
device_initcall() .. So boot-up is about 99% complete ..

It's trivial to make my version do verification during most of
device_initcall() ..

Daniel

