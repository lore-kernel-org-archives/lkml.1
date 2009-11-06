Return-Path: <linux-kernel-owner+w=401wt.eu-S1757109AbZKFLeM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757109AbZKFLeM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 06:34:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755690AbZKFLeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 06:34:11 -0500
Received: from mail-px0-f179.google.com ([209.85.216.179]:49418 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755372AbZKFLeK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 06:34:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=BXkoko53wlXEHdjZOVv4QyNBxru/8+TE5X/sW9vsa5Kz0LRtOoa5ZhBjlDfYaao1/l
         +Vt4XnG2fTzMbnIEZIu1z+8gGCZA1ddzkANGWNLEtKRpCcUrBXjDdBmQ0E1Y/oguKTa6
         H/xhLcT+KcWWhWZ+d1DRDtNIbWuzdOLdVjlEk=
MIME-Version: 1.0
In-Reply-To: <1255707940.6228.464.camel@Palantir>
References: <1255707324.6228.448.camel@Palantir>
	 <1255707940.6228.464.camel@Palantir>
Date: Fri, 6 Nov 2009 17:04:15 +0530
Message-ID: <8aa016e10911060334r837d330m5586e959be6df166@mail.gmail.com>
Subject: Re: [RFC 9/12][PATCH] SCHED_DEADLINE: system wide bandwidth 
	management
From: Dhaval Giani <dhaval.giani@gmail.com>
To: Raistlin <raistlin@linux.it>
Cc: Peter Zijlstra <peterz@infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       michael trimarchi <michael@evidence.eu.com>,
       Fabio Checconi <fabio@gandalf.sssup.it>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Johan Eker <johan.eker@ericsson.com>, "p.faure" <p.faure@akatech.ch>,
       Chris Friesen <cfriesen@nortel.com>,
       Steven Rostedt <rostedt@goodmis.org>, Henrik Austad <henrik@austad.us>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Darren Hart <darren@dvhart.com>,
       Sven-Thorsten Dietrich <sven@thebigcorporation.com>,
       Bjoern Brandenburg <bbb@cs.unc.edu>,
       Tommaso Cucinotta <tommaso.cucinotta@sssup.it>,
       "giuseppe.lipari" <giuseppe.lipari@sssup.it>,
       Juri Lelli <juri.lelli@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 16, 2009 at 9:15 PM, Raistlin <raistlin@linux.it> wrote:
> This commit adds the capability of controlling the maximum, system wide,
> CPU bandwidth that is devoted to SCHED_DEADLINE tasks.
>
> This is done by means of two files:
>  - /proc/sys/kernel/sched_deadline_runtime_us,
>  - /proc/sys/kernel/sched_deadline_period_us.
> The ratio runtime/period is the total bandwidth all the SCHED_DEADLINE tasks
> can use in the system as a whole.
> Trying to create tasks in such a way that they exceed this limitation will
> fail, as soon as the bandwidth cap would be overcome.
>
> Default value is _zero_ bandwidth available, thus write some numbers in those
> files before trying to start some SCHED_DEADLINE task. Setting runtime > period
> is allowed (i.e., more than 100% bandwidth available for -deadline tasks),
> since it makes more than sense in SMP systems.
>

I don't like this interface. A couple of issues that come to mind are
1. There is no check to prevent over provisioning of the system (if I
have missed the check, please correct me)
2. It is not CPU hotplug safe (I can understand that it is not that
important an issue now, but we should keep in mind that linux is
hotplug capable, so we would need to hook into the hotplug mechanism)

I would very much prefer the current interface where the runtime <=
period is always enforced. For SMP then across the system we would
allow a runtime equivalent to runtime * NR_CPU. I think it would make
more sense to push it as a percentage system wide. (I don't think it
should be an issue for processes since a process can only run one CPU
so its runtime and period will mean just that and not percentage).
comments?

thanks,
Dhaval
-- 

Ogden Nash  - "The trouble with a kitten is that when it grows up,
it's always a cat." -
http://www.brainyquote.com/quotes/authors/o/ogden_nash.html
