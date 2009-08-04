Return-Path: <linux-kernel-owner+w=401wt.eu-S1755511AbZHDNFP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511AbZHDNFP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 09:05:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755470AbZHDNFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 09:05:14 -0400
Received: from tomts36.bellnexxia.net ([209.226.175.93]:34052 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755461AbZHDNFN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 09:05:13 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuEEADHOd0pMQWXi/2dsb2JhbACBUtMNhBgF
Date: Tue, 4 Aug 2009 09:05:10 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Matthieu CASTET <matthieu.castet@parrot.com>
Cc: "ltt-dev@lists.casi.polymtl.ca" <ltt-dev@lists.casi.polymtl.ca>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       "rostedt@goodmis.org" <rostedt@goodmis.org>
Subject: Re: Tracing thread name
Message-ID: <20090804130510.GA23396@Krystal>
References: <4A76E42D.7010908@parrot.com> <20090803134843.GB23455@Krystal> <4A78099B.4@parrot.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <4A78099B.4@parrot.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:02:52 up 157 days,  9:29,  3 users,  load average: 1.65, 1.24,
	0.92
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Matthieu CASTET (matthieu.castet@parrot.com) wrote:
> Hi Mathieu,
> 
> Mathieu Desnoyers a écrit :
> > * Matthieu CASTET (matthieu.castet@parrot.com) wrote:
> >> Hi,
> >>
> >> I use ltt on a 2.6.27 on an arm architecture.
> >> It works quite well, but I have a minor problem :
> >>
> >> my application sets thread name with prctl PR_SET_NAME. But ltt viewer
> >> doesn't seem to saw it.
> >>
> > 
> > Hrm, I guess we might want to instrument set_task_comm as you propose to
> > get the correct process name, but if this gets us the thread name, I
> > think it's only an implementation side-effect:
> 
> > The way LTTng handles thread names is by adding a userspace "thread
> > branding" event. It should be executed at thread startup. The downside
> > of the current LTTng approach is that we cannot know the name of threads
> > already executing before we started tracing.
> > 
> 
> Do you know if it is possible to patch my version to add such feature ?
> 
> I saw that the name already change in the trace before/after an exec.
> How lltv get the new name ?
> With "fs.exec" tracepoint ?
> In that case I could fake a "fs.exec" tracepoint in set_task_comm.

A better solution : you add a new event in both lttng and lttv, and
modify state.c to support your new event. The current event to brand
thread is named "userspace.thread_brand". Look for this in LTTV to see
all the sites that need to support the new event (there are very few).

Mathieu

> 
> Thanks
> 
> Matthieu
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
