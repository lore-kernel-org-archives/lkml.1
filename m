Return-Path: <linux-kernel-owner+w=401wt.eu-S932309AbXLNLFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932309AbXLNLFa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 06:05:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754749AbXLNLFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 06:05:21 -0500
Received: from www.tglx.de ([62.245.132.106]:55656 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752014AbXLNLFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 06:05:20 -0500
Date: Fri, 14 Dec 2007 12:05:03 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: miaox@cn.fujitsu.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] time: add an offline-cpu check in add_timer_on()
In-Reply-To: <p73lk7xfssz.fsf@bingen.suse.de>
Message-ID: <alpine.LFD.0.99999.0712141203230.10584@localhost.localdomain>
References: <47625B94.50105@cn.fujitsu.com> <p73lk7xfssz.fsf@bingen.suse.de>
User-Agent: Alpine 0.99999 (LFD 796 2007-11-08)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Dec 2007, Andi Kleen wrote:

> Miao Xie <miaox@cn.fujitsu.com> writes:
> 
> > Hi everyone,
> >   I think we need a check in the function add_timer_on() to avoid adding a
> > timer into the timer list of an offline cpu.
> >
> > This patch fixes this problem in add_timer_on().
> 
> No it doesn't -- it will just crash if a caller does that. If it's a real 
> problem then you either need to fix the callers or change add_timer_on()
> to transparently put it onto another CPU.
> 
> I don't think it's a real problem though because CPU offlining does
> a stop machine and that should take care of most such races.

No. CPU offlining does not prevent code to try inserting a timer on a
offlined CPU. If there is a real problem with this we need to fix the
calling code. We should not insert it somewhere else magically.

Thanks,

	 tglx
