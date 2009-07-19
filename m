Return-Path: <linux-kernel-owner+w=401wt.eu-S1754619AbZGSPNM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619AbZGSPNM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 11:13:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754561AbZGSPNL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 11:13:11 -0400
Received: from www.tglx.de ([62.245.132.106]:39151 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754533AbZGSPNL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 11:13:11 -0400
Date: Sun, 19 Jul 2009 17:12:58 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dan Carpenter <error27@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, John Stultz <johnstul@us.ibm.com>
Subject: Re: potential null dereference in sysfs_override_clocksource()
In-Reply-To: <alpine.DEB.2.00.0907191545580.12306@bicker>
Message-ID: <alpine.LFD.2.00.0907191712050.11571@localhost.localdomain>
References: <alpine.DEB.2.00.0907191545580.12306@bicker>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan,

On Sun, 19 Jul 2009, Dan Carpenter wrote:

> Hello,
> 
> I am testing a source checker (http://repo.or.cz/w/smatch.git).
> 
> It found an issue in sysfs_override_clocksource() from 
> kernel/time/clocksource.c.  If "len" is zero then "ovr" is null and 
> checking ovr->flags will oops on line 517.
> 
> kernel/time/clocksource.c
>    516          if (tick_oneshot_mode_active() &&
>    517              !(ovr->flags & CLOCK_SOURCE_VALID_FOR_HRES)) {
>    518                  printk(KERN_WARNING "%s clocksource is not HRT compatible. "

Indeed. I queued a fix.

Thanks for pointing it out,


       tglx
