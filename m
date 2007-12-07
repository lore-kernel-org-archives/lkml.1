Return-Path: <linux-kernel-owner+w=401wt.eu-S1755313AbXLGQuK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313AbXLGQuK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 11:50:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752937AbXLGQt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 11:49:57 -0500
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:31297 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752908AbXLGQt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 11:49:57 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ou2MzbD6123k+0uPAR1XXVXJfKCKQpMKIsMQNGVB5IwmGCxyEnBJyjMbo9fNSU706s/XA8QWWk4qSyV2IkIca41K+FXBUzz6zyqSNS40AKA8OCpChxfmsilal+QgVpTuUJ89+s3UqjF//19D2NMP/S/JxgWtkrqhJQqdVl97YvY=  ;
X-YMail-OSG: HRzy0KkVM1l8PfxdXX6nHH1ltMOq7s88Ow0sK8TfDb511oXm
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] scheduler: fix x86 regression in native_sched_clock
Date: Sat, 8 Dec 2007 03:48:52 +1100
User-Agent: KMail/1.9.5
Cc: Stefano Brivio <stefano.brivio@polimi.it>, Robert Love <rml@tech9.net>,
       linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Michael Buesch <mb@bu3sch.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>
References: <20071207021952.6f0ac922@morte> <200712072213.06530.nickpiggin@yahoo.com.au> <20071207111720.GA10543@elte.hu>
In-Reply-To: <20071207111720.GA10543@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712080348.53117.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 December 2007 22:17, Ingo Molnar wrote:
> * Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > > ah, printk_clock() still uses sched_clock(), not jiffies. So it's
> > > not the jiffies counter that goes back and forth, it's sched_clock()
> > > - so this is a printk timestamps anomaly, not related to jiffies. I
> > > thought we have fixed this bug in the printk code already:
> > > sched_clock() is a 'raw' interface that should not be used directly
> > > - the proper interface is cpu_clock(cpu).
> >
> > It's a single CPU box, so sched_clock() jumping would still be
> > problematic, no?
>
> sched_clock() is an internal API - the non-jumping API to be used by
> printk is cpu_clock().

You know why sched_clock jumps when the TSC frequency changes, right?

