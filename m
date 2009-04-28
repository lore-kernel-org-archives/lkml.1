Return-Path: <linux-kernel-owner+w=401wt.eu-S1760152AbZD1KWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760152AbZD1KWs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 06:22:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932457AbZD1KVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 06:21:53 -0400
Received: from mail-bw0-f163.google.com ([209.85.218.163]:45243 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932445AbZD1KVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 06:21:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=aweSqlow0nefhr9e1s2sp1Id/QXDLM1F4lKVJ26dgO7TZayTWcQnNm5ve0YPoe8oKi
         2F3my4WWSGfE7Ut+qlnbxr4Rqj6Lt98BikVrs/z+YTAosl4GjxIvH+xF6DURZJEDy4V9
         9VC+yq6WZ09eKotjqXduQDm88p9BMRkRSCXgU=
MIME-Version: 1.0
In-Reply-To: <20090428190822.EBED.A69D9226@jp.fujitsu.com>
References: <20090428093621.GD21085@elte.hu>
	 <84144f020904280257j57b5b686k91cc4096a8e5ca29@mail.gmail.com>
	 <20090428190822.EBED.A69D9226@jp.fujitsu.com>
Date: Tue, 28 Apr 2009 13:21:50 +0300
X-Google-Sender-Auth: d63f090a41de331c
Message-ID: <84144f020904280321u4be9fb10t6f0123b589752b80@mail.gmail.com>
Subject: Re: [PATCH 5/5] proc: export more page flags in /proc/kpageflags
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       =?ISO-2022-JP?B?RnIbJEJxRXFTGyhCaWMgV2Vpc2JlY2tlcg==?= 
	<fweisbec@gmail.com>,
       Larry Woodman <lwoodman@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Matt Mackall <mpm@selenic.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

2009/4/28 KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>:
>> I guess the main question here is whether this approach will scale to
>> something like kmalloc() or the page allocator in production
>> environments. For any serious workload, the frequency of events is
>> going to be pretty high.
>
> Immediate Values patch series makes zero-overhead to tracepoint
> while it's not used.
>
> So, We have to implement to stop collect stastics way. it restore
> zero overhead world.
> We don't lose any performance by trace.

Sure but I meant the _enabled_ case here. kmalloc() (and the page
allocator to some extent) is very performance sensitive in many
workloads so you probably don't want to use tracepoints if you're
collecting some overall statistics (i.e. tracing all events) like we
do here.

                                      Pekka
