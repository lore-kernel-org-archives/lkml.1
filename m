Return-Path: <linux-kernel-owner+w=401wt.eu-S1763446AbYEARpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763446AbYEARpa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 13:45:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758015AbYEARpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 13:45:23 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:33417 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755044AbYEARpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 13:45:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding:sender;
        b=OYplNCKeiHum+eQ0lzeeFdU1OXEvj/Z1oVXkt02eD8erCVITIVzYO0RClOjcooW5/pMBT/G7c/eKbuBfQBCPN0mkWDj/NlVHaTBr0fk3X2JQDsn8s+YfVvyouLMgct/H+PPOVo5v0VJ5MiB3dGhENc0zcXkQm1XXSxIcf9bRdo4=
Date: Thu, 1 May 2008 20:45:10 +0300
From: Pekka Paalanen <pq@iki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Paalanen <pq@iki.fi>, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>, Pavel Roskin <proski@gnu.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC 1/3] mmiotrace full patch, preview 3
Message-ID: <20080501204510.5ecb69a2@daedalus.pq.iki.fi>
In-Reply-To: <20080429234021.071f7948@daedalus.pq.iki.fi>
References: <20080428214504.5c359195@daedalus.pq.iki.fi>
	<20080429234021.071f7948@daedalus.pq.iki.fi>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2008 23:40:21 +0300
Pekka Paalanen <pq@iki.fi> wrote:

> On Mon, 28 Apr 2008 21:45:04 +0300
> Pekka Paalanen <pq@iki.fi> wrote:
> 
> > The current state is that mmiotrace seems to work fine, also on SMP,
> > but on SMP there's a chance to miss events due to CPUs racing. At last
> > the log produced via ftrace framework is up-to-spec. Inserting user
> > comments (markers in mmiotrace-parlance) into the log is not yet
> > supported. All in all, after some more testing on my part, IMHO this
> > is in a mergeable state.
> 
> Ok, looks like I won't be able to do more testing than what I did today.
...
> 
> Tested with the patches and sched-devel/latest of
> Tue, 29 Apr 2008 11:47:55 +0000
> using testmmiotrace.ko and things looked fine.

Hi,

I did get the nvidia blob to work, with some help, and tried mmiotrace
on it. Worked perfectly. The machine is Thinkpad T61 with a Core 2 Duo.
Mmiotrace disabled and enabled the extra core without a glitch, and did
not even drop any events with the default ftrace buffer size. Previously
while tracing Nouveau, I had to increase the buffer size, which worked
well, too.

I did a second trace run after doing
echo 1 > /debug/tracing/trace_entries
and as expected, it lost a lot of events, but showed no problems. Then
I disabled mmiotrace while in X, the 2nd cpu core came back online, and
everything was good. Losing events is logged into the kernel log once
per mmiotrace activation, and into the trace whenever noticed.

(On athlon64 3000+, x86_64:)
Earlier I tried unaligned accesses with testmmiotrace.ko, by mapping
from an odd start address and doing 8, 16 and 32 bit reads and writes.
There were no crashes, and at a page boundary it resulted in a recursive
probe hit, which was resolved by disarming the both pages. Only one page
is re-armed, so the other page is left "blind", but did not seem to
harm stability.

Conclusion: green light from me!


-- 
Pekka Paalanen
http://www.iki.fi/pq/
