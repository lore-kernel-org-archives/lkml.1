Return-Path: <linux-kernel-owner+w=401wt.eu-S1750944AbXCFUU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750944AbXCFUU0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 15:20:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750911AbXCFUU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 15:20:26 -0500
Received: from mail21.syd.optusnet.com.au ([211.29.133.158]:43241 "EHLO
	mail21.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750914AbXCFUUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 15:20:24 -0500
From: Con Kolivas <kernel@kolivas.org>
To: tglx@linutronix.de
Subject: Re: 2.6.21-rc2-mm2
Date: Wed, 7 Mar 2007 07:19:00 +1100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       john stultz <johnstul@us.ibm.com>
References: <20070306004408.d3f6434d.akpm@linux-foundation.org> <200703070024.51273.kernel@kolivas.org> <1173192434.24738.333.camel@localhost.localdomain>
In-Reply-To: <1173192434.24738.333.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703070719.00442.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 March 2007 01:47, Thomas Gleixner wrote:
> On Wed, 2007-03-07 at 00:24 +1100, Con Kolivas wrote:
> > >         printk(KERN_INFO "Time: %s clocksource has been installed.\n",
> > >                clock->name);
> > > }
> > >
> > > So clock seems to be NULL, but was accessed before
> > > clocksource_calculate_interval() as well.
> >
> > It seems to be specifically tripping at c->mult after reading c->shift if
> > I'm reading it correctly.
> >
> > Note again, this is qemu, not real hardware and it will likely be giving
> > very unrealistic values for timer calibrations.
>
> I know, but this does not really explain why the
>
> 	tmp += c->mult/2;
>
> results in a NULL pointer access after
>
> 	tmp <<= c->shift;

/me shrugs

No idea.

> Does disassembling the code in question give some info ? You might also
> try to look with GDB at it.

Alas it wouldn't mean anything to me, sorry. And qemu doesn't work with gdb on 
64bit processes in 32bit userspace even with a 64bit gdb.

-- 
-ck
