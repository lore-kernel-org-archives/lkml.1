Return-Path: <linux-kernel-owner+w=401wt.eu-S1030259AbXAaQmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030259AbXAaQmS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 11:42:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030261AbXAaQmS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 11:42:18 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:28884 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030259AbXAaQmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 11:42:17 -0500
Subject: Re: [PATCH 12/23] clocksource: add clocksource_get_clock()
From: Daniel Walker <dwalker@mvista.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, johnstul@us.ibm.com,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20070131114615.GB1847@elte.hu>
References: <20070131033710.420168478@mvista.com>
	 <20070131033806.795135512@mvista.com>  <20070131114615.GB1847@elte.hu>
Content-Type: text/plain
Date: Wed, 31 Jan 2007 08:40:46 -0800
Message-Id: <1170261646.9781.98.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-01-31 at 12:46 +0100, Ingo Molnar wrote:
> * Daniel Walker <dwalker@mvista.com> wrote:
> 
> > One new API call clocksource_get_clock() which allows clocks to be 
> > selected based on their name, or if the name is null the highest rated 
> > clock is returned.
> 
> this one (and the dependent APIs utilizations) look a step in the right 
> direction to me, but they are not fully consequent and thus a bit 
> confusing at the moment:
> 
> - the current_clocksource is now something that is conceptually related 
>   to timekeeping - while it still resides in the clocksource domain.

Yes . The sysfs code gets moved in the next patch so it resides in the
timekeeping code .. 

> - if we do this split there should be a separate sysfs hierarchy for 
>   timekeeping, separate of clocksource

A long time ago I changed "current_clocksource" to
"timekeeping_clocksource" which made sense at the time .. I got push
back on that from John, and I think maybe Thomas ..


> - you use struct sys_device clocksource_sys_device from clocksource.c in 
>   timekeeping.c, which is inconsistent as well.
> 

This was on purpose , because I feel the sysfs organization benefits
when you have the clocksource users all in one place. Along with the
list of available clocksources .. I'm all ears if you have a better
suggestion ..

Daniel

