Return-Path: <linux-kernel-owner+w=401wt.eu-S1758672AbYEELbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758672AbYEELbV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 07:31:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758265AbYEELbA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 07:31:00 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:62049 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758245AbYEELa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 07:30:59 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjMFAEuNHkhMROPA/2dsb2JhbACBU6g8
Date: Mon, 5 May 2008 07:30:57 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, systemtap@sources.redhat.com,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: System call instrumentation
Message-ID: <20080505113057.GA28070@Krystal>
References: <20080504134838.GA21487@Krystal> <20080505065559.GD3350@elte.hu> <20080505105915.GA26444@Krystal> <20080505111029.GA9948@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080505111029.GA9948@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 07:25:29 up 66 days,  7:36,  5 users,  load average: 1.13, 0.81,
	0.77
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > > hm, i'm not sure about this. I've implemented system call tracing in 
> > > -rt [embedded in the latency tracer] and it only needed changes in 
> > > entry.S, not in every system call site. Now, granted, that tracer 
> > > was simpler than what LTTng tries to do, but do we _really_ need 
> > > more complexity? A trace point that simply expresses:
> > > 
> > >    sys_call_event(int sysno, long param1, long param2, long param3,
> > >                              long param4, long param5, long param6);
> > > 
> > 
> > That would work for all system calls that doesn't have parameters like 
> > "const char __user *filename".
> 
> what's the problem with them? Do you want to follow those parameters?
> 
> 	Ingo

Ideally, I'd like to have this kind of high-level information :

event name : kernel syscall
syscall name : open
arg1 (%s) : "somefile"    <-----
arg2 (%d) : flags
arg3 (%d) : mode

However, "somefile" has to be read from userspace. With the protection
involved, it would cause a performance impact to read it a second time
rather than tracing the string once it's been copied to kernel-space.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
