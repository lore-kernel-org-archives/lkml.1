Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756002Ab0CJAK5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 19:10:57 -0500
Received: from mail-fx0-f227.google.com ([209.85.220.227]:34598 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753648Ab0CJAKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 19:10:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=cTNcHnMBy45O3Ej4dSZTv2V53+52uLX7zLMx6pMtRzY+G6G54Bd113NPnQKvXk7FPC
         etgmiKV96aGiZ1g34wHw9F9P4Y2zjs/ENTIaFvU/A8SYn57+Bt2qXSIKw64em7xzNVS+
         T28bxyCQs4mkztXUz9BDYn+5SIc3OVuZkiOyA=
Date: Wed, 10 Mar 2010 01:10:51 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Paul Mackerras <paulus@samba.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 1/3] lockdep: Move lock events under lockdep recursion
	protection
Message-ID: <20100310001050.GG5058@nowhere>
References: <1267599302-2886-1-git-send-regression-fweisbec@gmail.com> <1267599302-2886-2-git-send-regression-fweisbec@gmail.com> <4B95F662.4090401@dcl.info.waseda.ac.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B95F662.4090401@dcl.info.waseda.ac.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 09, 2010 at 04:18:58PM +0900, Hitoshi Mitake wrote:
> Thanks a lot, Frederic!
>
> I tested perf lock with your patch, result is like this,
>
> Typical scores:
>
> before:
> % sudo ./perf lock record ./perf bench sched messaging
> # Running sched/messaging benchmark...
> # 20 sender and receiver processes per group
> # 10 groups == 400 processes run
>
>      Total time: 3.265 [sec]
> [ perf record: Woken up 0 times to write data ]
> [ perf record: Captured and wrote 143.952 MB perf.data (~6289344 samples) ]
>
> after:
> % sudo ./perf lock record ./perf bench sched messaging
> # Running sched/messaging benchmark...
> # 20 sender and receiver processes per group
> # 10 groups == 400 processes run
>
>      Total time: 1.943 [sec]                       <--- about x1.5 faster!
> [ perf record: Woken up 0 times to write data ]
> [ perf record: Captured and wrote 98.161 MB perf.data (~4288734 samples)  
> ]   <--- size of perf.data is also reduced
>


Oh great! Yeah this recursion thing was really bad.

Thanks.

