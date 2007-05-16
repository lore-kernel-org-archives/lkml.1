Return-Path: <linux-kernel-owner+w=401wt.eu-S933228AbXEPWZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933228AbXEPWZZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 18:25:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755639AbXEPWZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 18:25:15 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:56051 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755591AbXEPWZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 18:25:14 -0400
Subject: Re: v2.6.21-rt2
From: Daniel Walker <dwalker@mvista.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
In-Reply-To: <20070516220444.GA27081@elte.hu>
References: <20070516180447.GA17922@elte.hu>
	 <1179348842.20519.20.camel@imap.mvista.com>
	 <20070516210104.GA17240@elte.hu>
	 <1179350448.20519.25.camel@imap.mvista.com>
	 <20070516213259.GC19850@elte.hu>
	 <1179352036.20519.36.camel@imap.mvista.com>
	 <20070516220444.GA27081@elte.hu>
Content-Type: text/plain
Date: Wed, 16 May 2007 15:22:58 -0700
Message-Id: <1179354178.20519.43.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-17 at 00:04 +0200, Ingo Molnar wrote:
> * Daniel Walker <dwalker@mvista.com> wrote:
> 
> > I don't know. irqs_off_preempt_count() could get used someplace else, 
> > where you would want to flip the preempt_count() check .. It seems 
> > sane to combine your patch with mine ..
> > 
> > irqs_off_preempt_count() (!__get_cpu_var(trace_cpu_idle) && 
> > preempt_count())
> > 
> > You can't call __get_cpu_var() without the a positive preempt_count(), 
> > so the check seems backwards regardless of the other factors ..
> 
> yeah. The whole trace_preempt_enter_idle() thing looks a bit suspect. 
> Why cannot those architectures simply disable/enable preemption and get 
> the same effect? It's not like we ever want to allow the preemption of 
> the idle task.

They disable interrupts it looks like (i386, and x86_64), around the
same area where those trace_preempt_enter_idle calls are placed .. I'm
not up on the details of Steve's fix .. There's also a
preempt_disable/preempt_enable ..

I'm not up on the details of Steve's fix , but stuff looks a little
odd ..

Daniel

