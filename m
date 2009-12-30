Return-Path: <linux-kernel-owner+w=401wt.eu-S1753467AbZL3VLn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467AbZL3VLn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 16:11:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753456AbZL3VLl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 16:11:41 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:55719 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753448AbZL3VLj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 16:11:39 -0500
Date: Wed, 30 Dec 2009 22:11:38 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
       Shaohua Li <shaohua.li@intel.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: [PATCH] cfq-iosched: non-rot devices do not need queue merging
Message-ID: <20091230211138.GN4489@kernel.dk>
References: <1262175004-2132-1-git-send-email-czoccolo@gmail.com> <20091230184535.GE4489@kernel.dk> <4e5e476b0912301231k3214bb3dicbfc59d94623d72@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4e5e476b0912301231k3214bb3dicbfc59d94623d72@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 30 2009, Corrado Zoccolo wrote:
> On Wed, Dec 30, 2009 at 7:45 PM, Jens Axboe <jens.axboe@oracle.com> wrote:
> > On Wed, Dec 30 2009, Corrado Zoccolo wrote:
> >> Non rotational devices' performances are not affected by
> >> distance of requests, so there is no point in having overhead
> >> to merge queues of nearby requests.
> >
> > If the distance is zero, it may still make a big difference (at least
> > for writes). This check would be better as "ncq and doesn't suck", ala
> >
> >        blk_queue_nonrot(q) && tagged
> >
> > like we do elsewhere.
> 
> For reads, though, even flash cards and netbook ssds are completely
> unaffected. I have done few experiments on my available disks:
> * http://dl.dropbox.com/u/3525644/service_time.png (I used the
> program: http://dl.dropbox.com/u/3525644/stride.c to get the graphs).

Completely agree, it's writes that matter (as mentioned).

> For distance 0, I think request merging will be more effective than
> queue merging, moreover I think the multi-thread trick to have large

Definitely true, but we don't allow cross cfqq merges to begin with.

> I/O depth is used for reads, not writes (where simply issuing buffered
> writes already achieves a similar effect), so I think it is safe to
> disable it for all non-rotational devices.

That still leaves direct writes. Granted it's a problem with a huge
scope, but still.

-- 
Jens Axboe

