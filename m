Return-Path: <linux-kernel-owner+w=401wt.eu-S933881AbZKXStc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933881AbZKXStc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 13:49:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933839AbZKXStc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 13:49:32 -0500
Received: from mail-ew0-f215.google.com ([209.85.219.215]:57765 "EHLO
	mail-ew0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933807AbZKXStb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 13:49:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=i6K795niD/51gvaRlxwMGAxOMaqWPexNu5a4A/zSTNudO2lzhe4N3vnW4pA6KFFEUF
         UCMONy59+54CiCbN62kMPOQf8u/nTxdgWK4ft6iEwy8hjvCjnj8tOJieOJzzRZztl+nl
         K9ZGSZmfI519BrVnl9C/0NDpe8obwF7qqjI6w=
Date: Tue, 24 Nov 2009 19:49:35 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 0/5] perf kmem: Add more functions and show more
	statistics
Message-ID: <20091124184927.GA4994@nowhere>
References: <4B0B6E44.6090106@cn.fujitsu.com> <20091124090425.GF21991@elte.hu> <4B0BA99D.5020602@cn.fujitsu.com> <20091124100724.GA5570@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091124100724.GA5570@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 24, 2009 at 11:07:24AM +0100, Ingo Molnar wrote:
> 
> * Li Zefan <lizf@cn.fujitsu.com> wrote:
> 
> > > 3)
> > > 
> > > it doesnt seem to be working on one of my boxes, which has perf and kmem 
> > > events as well:
> > > 
> > > aldebaran:~/linux/linux/tools/perf> perf kmem record
> > > ^C[ perf record: Woken up 1 times to write data ]
> > > [ perf record: Captured and wrote 0.050 MB perf.data (~2172 samples) ]
> > > 
> > 
> > Seems no kmem event is recorded. No sure what happened here.
> > 
> > Might be that the parameters that perf-kmem passes to perf-record
> > are not properly selected?
> > 
> > Do perf-sched and perf-timechart work on this box?
> 
> yeah:
> 
> aldebaran:~> perf sched record sleep 1
> [ perf record: Woken up 1 times to write data ]
> [ perf record: Captured and wrote 0.017 MB perf.data (~758 samples) ]
> aldebaran:~> perf trace | tail -5
>          distccd-20944 [010]  1792.787376: sched_stat_runtime: comm=distccd pid=20944 runtime=11196 [ns] vruntime=696395420043 [ns]
>             init-0     [009]  1792.914837: sched_stat_wait: comm=x86_64-linux-gc pid=881 delay=10686 [ns]
>             init-0     [009]  1792.915082: sched_stat_sleep: comm=events/9 pid=44 delay=2183651362 [ns]
>               as-889   [013]  1793.008008: sched_stat_runtime: comm=as pid=889 runtime=156807 [ns] vruntime=1553569219042 [ns]
>             init-0     [004]  1793.154400: sched_stat_wait: comm=events/4 pid=39 delay=12155 [ns]
> 
> aldebaran:~> perf kmem record sleep 1
> [ perf record: Woken up 1 times to write data ]
> [ perf record: Captured and wrote 0.078 MB perf.data (~3398 samples) ]
> aldebaran:~> perf trace | tail -5
> aldebaran:~> 
> 
> the perf.data has mmap and exit events - but no kmem events.
> 
> I've attached the config, in case it matters. It runs latest -tip, with 
> your latest series applied as well.
> 
> 	Ingo



I think this is a problem external to kmem events. It's about
trace events/perf in general. It looks like we have some losses.
Steve and Arjan have reported similar things.

I'll investigate this way.

Thanks.

