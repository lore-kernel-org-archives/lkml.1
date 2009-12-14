Return-Path: <linux-kernel-owner+w=401wt.eu-S932796AbZLNWxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932796AbZLNWxR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 17:53:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932344AbZLNWxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 17:53:15 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:56264 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932327AbZLNWxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 17:53:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=osq9MCjLZVlysfCBMkBns06VRY3+mz+3Le8hnMMdBVU9RVOC0wGlEPSmcaWzGHm5uK
         zepjDMNoUxdROh6HYRTSIppgL4VWDObq1yTqxJ1A2vGn6YI9EpSJ+iED6volKTh71t7y
         t4LMmx/h92rUM2thBncrBTNhrdP7zZ2FDh/VI=
Date: Mon, 14 Dec 2009 23:53:09 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 3/3] perf diff: Introduce tool to show performance
	difference
Message-ID: <20091214225307.GA6048@nowhere>
References: <1260828571-3613-1-git-send-email-acme@infradead.org> <1260828571-3613-3-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260828571-3613-3-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 14, 2009 at 08:09:31PM -0200, Arnaldo Carvalho de Melo wrote:
> From: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> I guess it is enough to show some examples:
> 
> [root@doppio linux-2.6-tip]# rm -f perf.data*
> [root@doppio linux-2.6-tip]# ls -la perf.data*
> ls: cannot access perf.data*: No such file or directory
> [root@doppio linux-2.6-tip]# perf record -f find / > /dev/null
> [ perf record: Woken up 1 times to write data ]
> [ perf record: Captured and wrote 0.062 MB perf.data (~2699 samples) ]
> [root@doppio linux-2.6-tip]# ls -la perf.data*
> -rw------- 1 root root 74440 2009-12-14 20:03 perf.data
> [root@doppio linux-2.6-tip]# perf record -f find / > /dev/null
> [ perf record: Woken up 1 times to write data ]
> [ perf record: Captured and wrote 0.062 MB perf.data (~2692 samples) ]
> [root@doppio linux-2.6-tip]# ls -la perf.data*
> -rw------- 1 root root 74280 2009-12-14 20:03 perf.data
> -rw------- 1 root root 74440 2009-12-14 20:03 perf.data.old
> [root@doppio linux-2.6-tip]# perf diff | head -5
>    1        -34994580     /lib64/libc-2.10.1.so   _IO_vfprintf_internal
>    2        -15307806         [kernel.kallsyms]   __kmalloc
>    3    +1   +3665941     /lib64/libc-2.10.1.so   __GI_memmove
>    4    +4  +23508995     /lib64/libc-2.10.1.so   _int_malloc
>    5    +7  +38538813         [kernel.kallsyms]   __d_lookup
> [root@doppio linux-2.6-tip]# perf diff -p | head -5
>    1        +1.00%     /lib64/libc-2.10.1.so   _IO_vfprintf_internal
>    2                       [kernel.kallsyms]   __kmalloc
>    3    +1             /lib64/libc-2.10.1.so   __GI_memmove
>    4    +4             /lib64/libc-2.10.1.so   _int_malloc
>    5    +7  -1.00%         [kernel.kallsyms]   __d_lookup
> [root@doppio linux-2.6-tip]# perf diff -v | head -5
>    1        361449551 326454971 -34994580     /lib64/libc-2.10.1.so   _IO_vfprintf_internal
>    2        151009241 135701435 -15307806         [kernel.kallsyms]   __kmalloc
>    3    +1  101805328 105471269  +3665941     /lib64/libc-2.10.1.so   __GI_memmove
>    4    +4   78041440 101550435 +23508995     /lib64/libc-2.10.1.so   _int_malloc
>    5    +7   59536172  98074985 +38538813         [kernel.kallsyms]   __d_lookup
> [root@doppio linux-2.6-tip]# perf diff -vp | head -5
>    1        9.00% 8.00% +1.00%     /lib64/libc-2.10.1.so   _IO_vfprintf_internal
>    2        3.00% 3.00%                [kernel.kallsyms]   __kmalloc
>    3    +1  2.00% 2.00%            /lib64/libc-2.10.1.so   __GI_memmove
>    4    +4  2.00% 2.00%            /lib64/libc-2.10.1.so   _int_malloc
>    5    +7  1.00% 2.00% -1.00%         [kernel.kallsyms]   __d_lookup
> [root@doppio linux-2.6-tip]#



Wow, nice! :)



> 
> This should be enough for diffs where the system is non volatile, i.e. when one
> doesn't updates binaries.
> 
> For volatile environments, stay tuned for the next perf tool feature: a buildid
> cache populated by 'perf record', managed by 'perf buildid-cache' a-la ccache,
> and used by all the report tools.



Yeah. My first idea about that was to rebase the comparison against
symbols only, this is the last atom we have that is not supposed
to move in a volatile system.

And that would also apply to callchains.

