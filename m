Return-Path: <linux-kernel-owner+w=401wt.eu-S1755120AbZGAJmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120AbZGAJmv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 05:42:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754048AbZGAJmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 05:42:43 -0400
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:62744 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754034AbZGAJmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 05:42:43 -0400
Date: Wed, 01 Jul 2009 18:42:32 +0900 (JST)
Message-Id: <20090701.184232.131509470674490734.mitake@dcl.info.waseda.ac.jp>
To: mingo@elte.hu
Cc: andi@firstfloor.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RFC] Adding information of counts processes acquired
 how many spinlocks to schedstat
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
In-Reply-To: <20090701090749.GA13535@elte.hu>
References: <87hbxwj1k3.fsf@basil.nowhere.org>
	<20090701.174226.419764642024067218.mitake@dcl.info.waseda.ac.jp>
	<20090701090749.GA13535@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n619gwoU024970

From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH][RFC] Adding information of counts processes acquired how many spinlocks to schedstat
Date: Wed, 1 Jul 2009 11:07:49 +0200

> 
> * Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp> wrote:
> 
> > From: Andi Kleen <andi@firstfloor.org>
> > Subject: Re: [PATCH][RFC] Adding information of counts processes acquired how many spinlocks to schedstat
> > Date: Wed, 01 Jul 2009 09:38:04 +0200
> > 
> > > Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp> writes:
> > > 
> > > > Hi,
> > > >
> > > > I wrote a test patch which add information of counts processes acquired how many spinlocks to schedstat.
> > > > After applied this patch, /proc/<PID>/sched will change like this,
> > > 
> > > The problem is that spinlocks are very common and schedstats is 
> > > enabled commonly in production kernels. You would need to 
> > > demonstrate that such a change doesn't have significant 
> > > performance impact. For me it looks like it has.
> > 
> > I agree with your opinion about performance impact.
> > I thought this will make no problem,
> > because schedstat is categorized as "Kernel hacking" section.
> > But according to you, many production kernels enable it
> > so my patch will make widespread performance degradation.
> > I didn't know that, sorry.
> 
> His arguments are bogus: both lockstat and perfcounters are optional 
> (and default off), and the sw counter can be made near zero cost 
> even if both perfcounters and lockstat is enabled. Also, sw counters 
> are generally per CPU, etc. so not a performance issue.
> 
> The only (small) overhead will be when the lock-acquire sw counter 
> is actively enabled because you run 'perf stat -e lock-acquire' - 
> but that is expected and inherent in pretty much any kind of 
> instrumentation.
> 
> The feature you are working on has the chance to be a very useful 
> and popular piece of instrumentation. Being able to tell the lock 
> acquire stats on a per task, per workload, per CPU or system-wide 
> basis is a unique capability no other tool can offer right now.
> 
> Andi is often trolling perfcounters related (and other) threads, 
> please dont let yourself be deterred by that and feel free to ignore 
> him.
OK, at least it is truth that
counter in perfcounters makes only valid overhead.

And I have a question,
I tried to build perf, but I got a build error,

util/symbol.c: In function â€˜dso__load_symâ€™:
util/symbol.c:466: error: â€˜ELF_C_READ_MMAPâ€™ undeclared (first use in this function)
util/symbol.c:466: error: (Each undeclared identifier is reported only once
util/symbol.c:466: error: for each function it appears in.)

I used this libelf,
http://www.mr511.de/software/english.html
but constant ELF_C_READ_MMAP is not provided...

which "libelf" should I use?
It seems that there are some libelf implementations.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
