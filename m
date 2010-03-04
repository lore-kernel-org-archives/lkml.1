Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269Ab0CDDSe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 22:18:34 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:45035 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754083Ab0CDDS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 22:18:29 -0500
X-Authority-Analysis: v=1.0 c=1 a=u-VO3dv88eYA:10 a=7U3hwN5JcxgA:10 a=krKWriI0gw7vnKiC0CIA:9 a=Pz1XQ8aT35CUW2vUMPUA:7 a=AmF7C567ypSloAVdz_JyrIZqWkwA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: 2.6.33: ftrace triggers soft lockup
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <2375c9f91003031901v19c00c21k4a5d46bbe9ade3f@mail.gmail.com>
References: <2375c9f91003022204p5bdab1fdj3b3500998575fc28@mail.gmail.com>
	 <20100304014641.GH5194@nowhere>
	 <2375c9f91003031901v19c00c21k4a5d46bbe9ade3f@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Wed, 03 Mar 2010 22:18:26 -0500
Message-ID: <1267672706.10871.97.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-04 at 11:01 +0800, Américo Wang wrote:

> >
> > So it is stuck in stop machine. I wonder where exactly. I see some do_exit
> > at the top but I wonder how much they are reliable.
> 
> Well, I think 'kstop' is just random, sometimes I got 'watchdog' or some other
> process.
> 
> >
> > Anyway, as Steve said, we really need a full config to reproduce it.
> >
> 
> Done in another reply.

Thanks!

Frederic, I notice that lockdep is on, did anything change that might
slow down the code in lockdep, or is the function graph tracer doing
more locking?

I'm betting that we are hitting a live lock. That is, an interrupt goes
off, it is being traced, and the function graph is tracing it, but some
locking is happening (although it also tracks disabling of interrupts)
and this slows the interrupt handler down enough that when it finishes,
another interrupt goes off.

Américo,

Could you disable LOCKDEP and see if you still encounter this lockup?

Thanks,

-- Steve


