Return-Path: <linux-kernel-owner+w=401wt.eu-S1754906AbZJEVWM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906AbZJEVWM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 17:22:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754870AbZJEVWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 17:22:12 -0400
Received: from mail-yw0-f176.google.com ([209.85.211.176]:38629 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754587AbZJEVWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 17:22:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=pg5Mg7ae8Yip3xB3//5Qm1pw4KkUAROBmyHTekCNd1Of1F+SLplcPxu+YID5qrE5ck
         cKwD/gOyCa9EqACfdJHtb9+fDc8mayzqH6rFTYO7YsDnKUXifQqZB/ZYGcNe5uqaX5aR
         6s7VLGyEKL2isXzkwGNeCD0jIt2IifpVY+AB0=
MIME-Version: 1.0
In-Reply-To: <20091004162005.GH4650@gandalf.sssup.it>
References: <20091002154020.GC4494@redhat.com>
	 <20091002195815.GE4494@redhat.com>
	 <4e5e476b0910021514i1b461229t667bed94fd67f140@mail.gmail.com>
	 <20091002222756.GG4494@redhat.com>
	 <4e5e476b0910030543o776fb505ka0ce38da9d83b33c@mail.gmail.com>
	 <20091003133810.GC12925@redhat.com>
	 <4e5e476b0910040215m35af5c99pf2c3a463a5cb61dd@mail.gmail.com>
	 <20091004121122.GB18778@redhat.com>
	 <4e5e476b0910040546h5f77cd1fo3172fe5c229eb579@mail.gmail.com>
	 <20091004162005.GH4650@gandalf.sssup.it>
Date: Mon, 5 Oct 2009 23:21:34 +0200
Message-ID: <4e5e476b0910051421n6a3b7797xe416cc790d38b124@mail.gmail.com>
Subject: Re: Do we support ioprio on SSDs with NCQ (Was: Re: IO scheduler 
	based IO controller V10)
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Fabio Checconi <fchecconi@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Valdis.Kletnieks@vt.edu,
       Mike Galbraith <efault@gmx.de>, Jens Axboe <jens.axboe@oracle.com>,
       Ingo Molnar <mingo@elte.hu>,
       Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, nauman@google.com, dpshah@google.com,
       lizf@cn.fujitsu.com, mikew@google.com, paolo.valente@unimore.it,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, jmoyer@redhat.com,
       dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com,
       akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com,
       torvalds@linux-foundation.org, riel@redhat.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 4, 2009 at 6:20 PM, Fabio Checconi <fchecconi@gmail.com> wrote:
> But if the ``always ready to perform I/O'' assumption held then even RR
> would have provided service differentiation, always seeing backlogged
> queues and serving them according to their weights.

Right, this property is too strong. But also a weaker "the two queues
have think times less than the disk access time" will be enough to
achieve the same goal by means of proper placement in the RR tree.

If both think times are greater than access time, then each queue will
get a service level equivalent to it being the only queue in the
system, so in this case service differentiation will not apply (do we
need to differentiate when everyone gets exactly what he needs?).

If one think time is less, and the other is more than the access time,
then we should decide what kind of fairness we want to have,
especially if the one with larger think time has also higher priority.

> In this case the problem is what Vivek described some time ago as the
> interlocked service of sync queues, where the scheduler is trying to
> differentiate between the queues, but they are not always asking for
> service (as they are synchronous and they are backlogged only for short
> time intervals).

Corrado
