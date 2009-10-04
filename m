Return-Path: <linux-kernel-owner+w=401wt.eu-S1757689AbZJDSkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757689AbZJDSkX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 14:40:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757601AbZJDSkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 14:40:22 -0400
Received: from brick.kernel.dk ([93.163.65.50]:60693 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752360AbZJDSkW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 14:40:22 -0400
Date: Sun, 4 Oct 2009 20:39:45 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH] cfq: enable idle for seeky processes on rotational NCQ
	devices
Message-ID: <20091004183945.GG26573@kernel.dk>
References: <200910041837.34546.czoccolo@gmail.com> <20091004173636.GC26573@kernel.dk> <4e5e476b0910041129o91268f0uc550640d62d82aab@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e5e476b0910041129o91268f0uc550640d62d82aab@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 04 2009, Corrado Zoccolo wrote:
> On Sun, Oct 4, 2009 at 7:36 PM, Jens Axboe <jens.axboe@oracle.com> wrote:
> > I think this one is a bit problematic. What I'd like seeky processes to
> > do is enable 'idle unless other sync read comes in' for such cases,
> > otherwise it will cost us a lot of performance on the seeky vs seeky
> > cases because we don't get to take advantage of queuing.
> 
> Are we sure that queuing is beneficial in this workload, on non-raid
> rotational devices?
> If the seeks are still quite local (e.g. when accessing a single
> file), given that seek time is proportional to seek length, idling
> should provide higher throughput.

Yes very sure, seek time is only approximately proportional to seek
length. With queuing, you potentially can account for rotational delay,
which is an equally big factor in IO latency. For small seeks, it's easy
the dominating factor even.

> Anyway, I'm working on an other patch that will group together all
> seeky queues and dispatch them without idling, and idle only on the
> last one, so if you prefer, this can be postponed until the other
> patch is ready.

I think so.

-- 
Jens Axboe

