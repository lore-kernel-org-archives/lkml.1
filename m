Return-Path: <linux-kernel-owner+w=401wt.eu-S1759051AbXJOOgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759051AbXJOOgj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 10:36:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755105AbXJOOgb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 10:36:31 -0400
Received: from tango.0pointer.de ([85.214.72.216]:35210 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755299AbXJOOga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 10:36:30 -0400
X-Greylist: delayed 642 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Oct 2007 10:36:30 EDT
Date: Mon, 15 Oct 2007 16:25:46 +0200
From: Lennart Poettering <mzxreary@0pointer.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>
Subject: Re: [RFC][PATCH] sched: SCHED_FIFO watchdog timer
Message-ID: <20071015142546.GA7851@tango.0pointer.de>
References: <1192222309.5897.3.camel@lappy> <1192315867.5625.6.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1192315867.5625.6.camel@lappy>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14.10.07 00:51, Peter Zijlstra (a.p.zijlstra@chello.nl) wrote:

> The below patch is an idea proposed by tglx and depends on sched-devel +
> the hrtick patch previously posted.
> 
> The current watchdog action is to demote the task to SCHED_NORMAL,
> however it might be wanted to deliver a signal instead (or have more per
> task configuration state). Which is why I added Lennart to the CC list
> as I gathered he would like something like this for PulseAudio.

Indeed! Having this in the kernel would allow us to enable RT
scheduling for PulseAudio by default without bad effects. I was thinking about
adding some kind of babysitting process to userspace -- but doing this as
an RLIMIT in the kernel strikes me a much better idea!

I think it would make a lot of sense to make the API very similar to
RLIMIT_CPU, i.e. also send out SIGXCPU and SIGKILL, with the single
difference that RLIMIT_CPU sends out a signal depending on the total
CPU time used for the process and the new RLIMIT based on the time the
process spent without sleeping. That would be a very reasonable
extension to the current RLIMIT_CPU model.

Thank you very much for doing this patch!

Lennart

-- 
Lennart Poettering                        Red Hat, Inc.
lennart [at] poettering [dot] net         ICQ# 11060553
http://0pointer.net/lennart/           GnuPG 0x1A015CC4
