Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756735Ab0CNJrg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 05:47:36 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:61296 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755261Ab0CNJre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 05:47:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=mI6HRS284pLB2YCJvcVdcqRGqPT/0MccU5P6rzuw6BgT3KaDavjsg84Ee03s5ogsGa
         AZpFrU8FDvA8of9lnlMbys3Zqm+XVWBTKXMDfJUUsnki9lUfj3fINdBb/H/0Ufpum3JN
         GP3CeK5eWIX7g9Lr0VyBTlxppzrDDulA2NcSg=
Date: Sun, 14 Mar 2010 10:47:34 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 2/2] perf hist: Don't fprintf the callgraph
	unconditionally
Message-ID: <20100314094732.GC5158@nowhere>
References: <1268408808-13595-1-git-send-email-acme@infradead.org> <1268408808-13595-2-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1268408808-13595-2-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 12, 2010 at 12:46:48PM -0300, Arnaldo Carvalho de Melo wrote:
> From: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
>   [root@doppio ~]# perf report -i newt.data | head -10
>   # Samples: 11999679868
>   #
>   # Overhead  Command                  Shared Object  Symbol
>   # ........  .......  .............................  ......
>   #
>       63.61%     perf  libslang.so.2.1.4              [.] SLsmg_write_chars
>        6.30%     perf  perf                           [.] symbols__find
>        2.19%     perf  libnewt.so.0.52.10             [.] newtListboxAppendEntry
>        2.08%     perf  libslang.so.2.1.4              [.] SLsmg_write_chars@plt
>        1.99%     perf  libc-2.10.2.so                 [.] _IO_vfprintf_internal
>   [root@doppio ~]#
> 
> Not good, the newt form for report works, but slang has to eat the cost of the
> additional callgraph lines everytime it prints a line, and the callgraph
> doesn't appear on the screen, so move the callgraph printing to a separate
> function and don't use it in newt.c.
> 
> Newt tree widgets are being investigated to properly support callgraphs, but
> till that gets merged, lets remove this huge overhead and show at least the
> symbol overheads for a callgraph rich perf.data with good performance.
> 
> Cc: Frédéric Weisbecker <fweisbec@gmail.com>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Paul Mackerras <paulus@samba.org>
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>


Hmm, so for now the callchain won't work anymore until
it gets properly reimplemented right?

Not that much a problem as a necessary step if it really makes
easier for the newt integration.

