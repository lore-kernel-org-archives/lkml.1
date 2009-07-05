Return-Path: <linux-kernel-owner+w=401wt.eu-S1755130AbZGEJAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130AbZGEJAS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 05:00:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753358AbZGEJAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 05:00:06 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58559 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752739AbZGEJAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 05:00:04 -0400
Date: Sun, 5 Jul 2009 10:59:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 5/5] perf report: Support callchains with relative
	overhead rate
Message-ID: <20090705085949.GA23780@elte.hu>
References: <1246772361-9960-1-git-send-email-fweisbec@gmail.com> <1246772361-9960-5-git-send-email-fweisbec@gmail.com> <20090705083400.GB12783@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090705083400.GB12783@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


btw., i get some buggy looking output with:

  $ perf record -f -g ~/hackbench 10

  $ perf report -c


                |--5.11%-- unix_stream_sendmsg
                |          |          
                |          |--100.00%-- __sock_sendmsg
                |          |          sock_aio_write
                |          |          do_sync_write
                |          |          vfs_write
                |          |          sys_write
                |          |          sysenter_dispatch
                |          |          0xf7f72430
                |          |          0xffebbca000000014
                |          |          
                |           --11.11%-- sock_aio_write
                |                     do_sync_write
                |                     vfs_write
                |                     sys_write
                |                     sysenter_dispatch
                |                     0xf7f72430
                |                     0xffebbca000000014

Those percentages dont sum up to 100% :-)

Another detail: i think we should signal when we crop the output due 
to the filter, via a line of:

                |          [...]

or so.

Plus, when doing 'perf report' on a call-chain recording, shouldnt 
we auto-detect this fact and default to fractal output 
automatically, instead of flat mode?

User can still force flat mode via 'perf report -c flat'.

	Ingo
