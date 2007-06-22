Return-Path: <linux-kernel-owner+w=401wt.eu-S1753621AbXFVGXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621AbXFVGXT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 02:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751282AbXFVGXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 02:23:09 -0400
Received: from pythia.bakeyournoodle.com ([203.82.209.197]:54693 "EHLO
	pythia.bakeyournoodle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbXFVGXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 02:23:08 -0400
Date: Fri, 22 Jun 2007 16:23:05 +1000
To: Daniel Walker <dwalker@mvista.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       john stultz <johnstul@us.ibm.com>,
       LinuxPPC-dev <linuxppc-dev@ozlabs.org>
Subject: Re: [RFC] clocksouce implementation for powerpc
Message-ID: <20070622062305.GX9768@bakeyournoodle.com>
References: <20070616101126.296384219@inhelltoy.tec.linutronix.de> <20070616101637.107940593@inhelltoy.tec.linutronix.de> <1182009083.11539.369.camel@imap.mvista.com> <20070620065710.GR9768@bakeyournoodle.com> <1182351439.18168.79.camel@imap.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1182351439.18168.79.camel@imap.mvista.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: tony@bakeyournoodle.com (Tony Breeds)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2007 at 07:57:19AM -0700, Daniel Walker wrote:

Hi Daniel.

> As I said in our private thread, I do think you should be using
> update_vsyscall() .. update_vsyscall() is just called when the time is
> set, usually that happens in the timer interrupt and sometimes that
> happens in settimeofday() ..

Well I've taken another look at the code and I think I can probably
restructure my code to use update_vsyscall().  I thought I needed a
hook that was called /only/ from settimeofday() (which as you say
doesn't match update_vsyscall()'s usage).

I'll try again and see what problems I hit.
 
> At least some of your code is duplications over what is already being
> worked on inside the powerpc community.. For instance, I know there is
> already a timebase clocksource,
> 
> http://people.redhat.com/~mingo/realtime-preempt/patch-2.6.21.5-rt17

Thanks. The one in -rt doesn't seem to support the VDSO.  however I see
that there is duplication of effort there.
 
> Hmm .. This doesn't look like it's taking into account that the time has
> changed .. Your time has effectively incremented by one jiffie .. The
> vdso_data doesn't appear to be updated ..

Unless I miss your meaning, the vdso is updated in
timer_recalc_offset()/update_gtod() when needed.

Yours Tony

  linux.conf.au        http://linux.conf.au/ || http://lca2008.linux.org.au/
  Jan 28 - Feb 02 2008 The Australian Linux Technical Conference!

