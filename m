Return-Path: <linux-kernel-owner+w=401wt.eu-S1755072Ab0AUK2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755072Ab0AUK2t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 05:28:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754122Ab0AUK2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 05:28:48 -0500
Received: from casper.infradead.org ([85.118.1.10]:46635 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974Ab0AUK2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 05:28:47 -0500
Subject: Re: [PATCH] perf_events: improve x86 event scheduling (v5)
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
       perfmon2-devel@lists.sf.net, eranian@gmail.com
In-Reply-To: <bd4cb8901001210221u5f02f05eq512df5dbb314419b@mail.gmail.com>
References: <4b5430c6.0f975e0a.1bf9.ffff85fe@mx.google.com>
	 <20100118134324.GB10364@nowhere> <1263822898.4283.558.camel@laptop>
	 <20100118142004.GD10364@nowhere> <1263825158.4283.590.camel@laptop>
	 <20100118144556.GE10364@nowhere>
	 <bd4cb8901001210208h758a546cw19fc81300164ec55@mail.gmail.com>
	 <1264068712.4283.1141.camel@laptop>
	 <bd4cb8901001210221u5f02f05eq512df5dbb314419b@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Jan 2010 11:28:37 +0100
Message-ID: <1264069717.4283.1148.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-21 at 11:21 +0100, Stephane Eranian wrote:

> Are you suggesting a speculative approach where you first try simply
> accumulate then schedule and if this fails, then restart the whole
> loop but this time adding and scheduling each event individually?
> For groups, you'd have to fail the group if one of its events fails.

No, I'm only talking about groups. The complaint from frederic was that
current hw_perf_group_sched_in() implementations have to basically
replicate all of the group_sched_in() and event_sched_in() stuff, which
seems wasteful.

So I was thinking of an alternative interface that would give the same
end result but not as much code replication.

I'm now leaning towards adding a parameter to ->enable() to postpone
schedulability and add a hw_perf_validate() like call.

With that I'm also looking at what would be the sanest way to multiplex
all the current weak hw_perf* functions in the light of multiple pmu
implementations.

