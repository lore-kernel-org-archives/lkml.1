Return-Path: <linux-kernel-owner+w=401wt.eu-S1756826AbZGENXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756826AbZGENXo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 09:23:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755114AbZGENXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 09:23:37 -0400
Received: from ey-out-1920.google.com ([74.125.78.146]:1623 "EHLO
	ey-out-1920.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755030AbZGENXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 09:23:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=saVc2HSjvbradGjjHifEPAI2IJ7URERss6xvoem+2GRBv9P3pHFt1bN9VOczux7iVd
         LNoNvee0YCBQXxp/5vfiBJjoZQWH+D/qXOTfwBFyyiB9BTRlTB6UQE8/E6h0ANVLWVOI
         /9sFbgUOQessuTy1dW5MjzWmk7Fzu3j5Noa2I=
Date: Sun, 5 Jul 2009 15:23:35 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 5/5] perf report: Support callchains with relative
	overhead rate
Message-ID: <20090705132333.GB4912@nowhere>
References: <1246772361-9960-1-git-send-email-fweisbec@gmail.com> <1246772361-9960-5-git-send-email-fweisbec@gmail.com> <20090705083400.GB12783@elte.hu> <20090705085949.GA23780@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090705085949.GA23780@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 05, 2009 at 10:59:49AM +0200, Ingo Molnar wrote:
> 
> btw., i get some buggy looking output with:
> 
>   $ perf record -f -g ~/hackbench 10
> 
>   $ perf report -c
> 
> 
>                 |--5.11%-- unix_stream_sendmsg
>                 |          |          
>                 |          |--100.00%-- __sock_sendmsg
>                 |          |          sock_aio_write
>                 |          |          do_sync_write
>                 |          |          vfs_write
>                 |          |          sys_write
>                 |          |          sysenter_dispatch
>                 |          |          0xf7f72430
>                 |          |          0xffebbca000000014
>                 |          |          
>                 |           --11.11%-- sock_aio_write
>                 |                     do_sync_write
>                 |                     vfs_write
>                 |                     sys_write
>                 |                     sysenter_dispatch
>                 |                     0xf7f72430
>                 |                     0xffebbca000000014
> 
> Those percentages dont sum up to 100% :-)


Argh. I can reproduce it, will have a look.


> Another detail: i think we should signal when we crop the output due 
> to the filter, via a line of:
> 
>                 |          [...]
> 
> or so.


Ok.



> Plus, when doing 'perf report' on a call-chain recording, shouldnt 
> we auto-detect this fact and default to fractal output 
> automatically, instead of flat mode?
> 
> User can still force flat mode via 'perf report -c flat'.


Yeah but the user won't be able to ignore the callchain.
May be I may add a -c none in this case?

