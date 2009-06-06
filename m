Return-Path: <linux-kernel-owner+w=401wt.eu-S1754011AbZFFAT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011AbZFFAT3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 20:19:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753169AbZFFATU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 20:19:20 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:20157 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692AbZFFATT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 20:19:19 -0400
Date: Fri, 5 Jun 2009 20:18:15 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, tytso@mit.edu, david@fromorbit.com,
       hch@infradead.org, yanmin_zhang@linux.intel.com,
       richard@rsk.demon.co.uk, damien.wyart@free.fr
Subject: Re: [PATCH 0/11] Per-bdi writeback flusher threads v9
Message-ID: <20090606001814.GD3824@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Jan Kara <jack@suse.cz>, Jens Axboe <jens.axboe@oracle.com>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	tytso@mit.edu, david@fromorbit.com, hch@infradead.org,
	yanmin_zhang@linux.intel.com, richard@rsk.demon.co.uk,
	damien.wyart@free.fr
References: <1243511204-2328-1-git-send-email-jens.axboe@oracle.com> <20090604152040.GA6007@nowhere> <20090604120726.708a2211.akpm@linux-foundation.org> <20090604191309.GA4862@nowhere> <20090604195013.GB11363@kernel.dk> <20090604201012.GD11363@kernel.dk> <20090604223449.GA13780@nowhere> <20090605191528.GV11363@kernel.dk> <20090605211438.GA11650@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090605211438.GA11650@duck.suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Source-IP: abhmt004.oracle.com [141.146.116.13]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A09020A.4A29B5CA.027F:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 05, 2009 at 11:14:38PM +0200, Jan Kara wrote:
> On Fri 05-06-09 21:15:28, Jens Axboe wrote:
> > On Fri, Jun 05 2009, Frederic Weisbecker wrote:
> > > The result with noop is even more impressive.
> > > 
> > > See: http://kernel.org/pub/linux/kernel/people/frederic/dbench-noop.pdf
> > > 
> > > Also a comparison, noop with pdflush against noop with bdi writeback:
> > > 
> > > http://kernel.org/pub/linux/kernel/people/frederic/dbench-noop-cmp.pdf
> > 
> > OK, so things aren't exactly peachy here to begin with. It may not
> > actually BE an issue, or at least now a new one, but that doesn't mean
> > that we should not attempt to quantify the impact.
>   What looks interesting is also the overall throughput. With pdflush we
> get to 2.5 MB/s + 26 MB/s while with per-bdi we get to 2.7 MB/s + 13 MB/s.
> So per-bdi seems to be *more* fair but throughput suffers a lot (which
> might be inevitable due to incurred seeks).
>   Frederic, how much does dbench achieve for you just on one partition
> (test both consecutively if possible) with as many threads as have those
> two dbench instances together? Thanks.

Is the graph showing us dbench tput or disk tput?  I'm assuming it is
disk tput, so bdi may just be writing less?

-chris

