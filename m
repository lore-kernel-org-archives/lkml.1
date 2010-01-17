Return-Path: <linux-kernel-owner+w=401wt.eu-S1753841Ab0AQOMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841Ab0AQOMm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 09:12:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753270Ab0AQOMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 09:12:41 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:10852 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020Ab0AQOMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 09:12:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=E6guVRkRpvWdFv66b+9Wp7DmJbQoPi2pnOg6HFFu/af9giRYnv7k4kf6+Jd7wI8qlb
         Lcfou7VZq4w1qiZi17lVBEo/1YuWYNQVgeJf+RK3jUQNnFUImRL0Cn9+8UCgeAZbFQfP
         OwZDnBtiwgeCpO8OuP2WGY2SjN/r4tBKatjkY=
Date: Sun, 17 Jan 2010 15:12:35 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
       perfmon2-devel@lists.sf.net
Subject: Re: [PATCH] perf_events: improve x86 event scheduling
Message-ID: <20100117141233.GF5035@nowhere>
References: <4b4c761b.0338560a.1eaa.ffff824d@mx.google.com> <1263312616.4244.153.camel@laptop> <bd4cb8901001130154p732672b6x56e758c1ab33a8e8@mail.gmail.com> <1263400193.4244.238.camel@laptop> <bd4cb8901001130852y1de007cbqe66d77605c1ec372@mail.gmail.com> <bd4cb8901001130922s7ad85af6w6c631d90de177ef9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd4cb8901001130922s7ad85af6w6c631d90de177ef9@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 13, 2010 at 06:22:54PM +0100, Stephane Eranian wrote:
> Ok,
> 
> Something like that should problably do it:
> 
> static void event_sched_out(struct perf_event *event, int cpu)
> {
>         event->state = PERF_EVENT_STATE_INACTIVE;
>         event->oncpu = -1;
> }



You need to also call pmu->disable() if it is a software event,
because a breakpoint needs to be unregistered in hardware level
too.

And disable it in x86 level if it is an x86 event?


 
> hw_perf_group_sched_in()
> {
>        ....
>        n = 1;
>         list_for_each_entry(sub, &leader->sibling_list, group_entry) {
>                 if (sub->state > PERF_EVENT_STATE_OFF) {
>                         ret = event_sched_in(sub, cpu);
>                         if (ret)
>                                 goto undo;



Yeah we indeed really need to check that.

Thanks.

