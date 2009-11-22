Return-Path: <linux-kernel-owner+w=401wt.eu-S1755473AbZKVRFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473AbZKVRFk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 12:05:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755283AbZKVRFk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 12:05:40 -0500
Received: from tomts36-srv.bellnexxia.net ([209.226.175.93]:55114 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755202AbZKVRFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 12:05:39 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArEEACr8CEtGGN1W/2dsb2JhbACBTNEghDwE
Date: Sun, 22 Nov 2009 12:05:42 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
       dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
       peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com
Subject: Re: [PATCH tip/core/rcu 0/3] rcu: resend of grace-period stall and
	cleanup patches
Message-ID: <20091122170542.GA12827@Krystal>
References: <20091122165321.GA19922@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20091122165321.GA19922@linux.vnet.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 11:57:55 up 96 days,  3:47,  3 users,  load average: 0.52, 0.52,
	0.55
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> Hello!
> 
> This patch series is a resend of the three RCU patches that are candidates
> for the upcoming 2.6.33 merge window, but that are not yet in -tip.
> These are:
> 
> 1.	A fix for a grace-period-stall bug that occurs on large
> 	machines.
[...]

Hi Paul,

I was thinking about the last bugs you discovered. Some caracteristics
they had in common were that they occur only on large marchines (32+ or
64+ CPUs). This is caused by the fact that some of your code is only
covered by tests when the number of CPUs go over the architecture size
(in bits).

I managed to cover this kind of scenario with smaller state-space in the
LTTng formal models (but it also applies to kernel code) by tweaking the
code, with bitmasks, to ensure that the number of bits the code uses is,
e.g., no more than the minimum amount of required bits. Therefore, you
are ensured to run into overflow scenarios either more quickly or, as in
this case, on decently-sized hardware.

Hope this helps,

Thanks,

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
