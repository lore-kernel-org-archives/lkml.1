Return-Path: <linux-kernel-owner+w=401wt.eu-S1752436AbXLDTaq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752436AbXLDTaq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 14:30:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750806AbXLDTak
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 14:30:40 -0500
Received: from tomts40.bellnexxia.net ([209.226.175.97]:34733 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750764AbXLDTaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 14:30:39 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HAEs5VUdMROHU/2dsb2JhbACBWo9I
Date: Tue, 4 Dec 2007 14:25:37 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Dave Hansen <haveblue@us.ibm.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, mbligh@google.com
Subject: Re: [RFC PATCH] LTTng instrumentation mm (updated)
Message-ID: <20071204192537.GC31752@Krystal>
References: <20071128140953.GA8018@Krystal> <1196268856.18851.20.camel@localhost> <20071129023421.GA711@Krystal> <1196317552.18851.47.camel@localhost> <20071130161155.GA29634@Krystal> <1196444801.18851.127.camel@localhost> <20071130170516.GA31586@Krystal> <1196448122.19681.16.camel@localhost> <20071130191006.GB3955@Krystal> <y0mve7ez2y3.fsf@ton.toronto.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <y0mve7ez2y3.fsf@ton.toronto.redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:23:22 up 31 days, 28 min,  6 users,  load average: 0.33, 0.72,
	0.93
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Frank Ch. Eigler (fche@redhat.com) wrote:
> Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> writes:
> 
> > [...]
> >> > We would like to be able to tell which swap file the information has
> >> > been written to/read from at any given time during the trace.
> >> 
> >> Oh, tracing is expected to be on at all times?  I figured someone would
> >> encounter a problem, then turn it on to dig down a little deeper, then
> >> turn it off.
> >
> > Yep, it can be expected to be on at all times, especially on production
> > systems using "flight recorder" tracing to record information in a
> > circular buffer [...]
> 
> Considering how early in the boot sequence swap partitions are
> activated, it seems optimistic to assume that the monitoring equipment
> will always start up in time to catch the initial swapons.  It would
> be more useful if a marker parameter was included in the swap events
> to let a tool/user map to /proc/swaps or a file name.
> 
> - FChE

Not early at all ? We have userspace processes running.. this is _late_
in the boot sequence! ;)

Anyhow, that I have now is a combination including your proposal :

- I dump the swapon/swapoff events.
- I also dump the equivalent of /proc/swaps (with kernel internal
  information) at trace start to know what swap files are currently
  used.

Does it sound fair ?

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
