Return-Path: <linux-kernel-owner+w=401wt.eu-S1754616Ab0AUIrq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616Ab0AUIrq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 03:47:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752875Ab0AUIrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 03:47:45 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:36704 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461Ab0AUIro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 03:47:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type;
        b=Yt424ENilRso6lqmqvy9DuboL9dkNzDUEEUVftWncz+X53F+rcmvF/Sxc58Q9yl0P1
         uE+rgqC+zjfE3UVgQM9R3iUrLonoo99yfFNxQvwkvoVluNCU5eDuN990CtcEOvbf5rBO
         JQM0k3Uk6kc8sOwNKmiuZi7C8RRzzar8kOUok=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <1264023204.4283.1124.camel@laptop>
References: <4B560ACD.4040206@linux.vnet.ibm.com>
	 <1263994448.4283.1052.camel@laptop>
	 <1264023204.4283.1124.camel@laptop>
Date: Thu, 21 Jan 2010 09:47:42 +0100
Message-ID: <7c86c4471001210047v5907f9d8ncecc1f5441afab3a@mail.gmail.com>
Subject: Re: [RFC] perf_events: support for uncore a.k.a. nest units
From: stephane eranian <eranian@googlemail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi@firstfloor.org>, Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Dan Terpstra <terpstra@eecs.utk.edu>, Philip Mucci <mucci@eecs.utk.edu>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 20, 2010 at 10:33 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2010-01-20 at 14:34 +0100, Peter Zijlstra wrote:
>
>> So how about PERF_TYPE_{CORE,NODE,SOCKET} like things?
>
> OK, so I read most of the intel uncore stuff, and it seems to suggest
> you need a regular pmu event to receive uncore events (chained setup),
> this seems rather retarded since it wastes a perfectly good pmu event
> and makes configuring all this more intricate...
>
I don't think that is correct. You can be using the uncore PMU on Nehalem
without any core PMU event. The only thing to realize is that uncore PMU
shares the same interrupt vector as core PMU. You need to configure which
core the uncore is going to interrupt on. This is done via a bitmask, so you
can interrupt more than one core at a time. Several strategies are possible.


> A well, nothing to be done about that I guess..
>
>
>
>
