Return-Path: <linux-kernel-owner+w=401wt.eu-S1755271AbZCULOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271AbZCULOU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 07:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753150AbZCULOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 07:14:05 -0400
Received: from brick.kernel.dk ([93.163.65.50]:34600 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753116AbZCULOC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 07:14:02 -0400
Date: Sat, 21 Mar 2009 12:14:00 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jerome Marchand <jmarchan@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: forbid to re-enable I/O stat accounting
Message-ID: <20090321111400.GJ27476@kernel.dk>
References: <200903201333.n2KDXONh023780@dhcp-0-152.brq.redhat.com> <20090321030309.f783ec8c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090321030309.f783ec8c.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 21 2009, Andrew Morton wrote:
> 
> Please fix your email headers - what I received was
> 
> From: Jerome Marchand <jmarchan@redhat.com>
> To: unlisted-recipients:;;@imap1.linux-foundation.org (no To-header on input)
> Cc: Jens Axboe <axboe@kernel.dk>

Ditto, I didn't think anyone else got it. At least noone else got my
reply :-)

> On Thu, 19 Mar 2009 11:36:50 +0100 Jerome Marchand <jmarchan@redhat.com> wrote:
> 
> > When we stop I/O stat accounting we stop to update the in-flight
> > requests counter and we need this counter to be reliable for
> > accounting I/O stats. Unfortunately updating in_flight field may
> > affect performance. So, until we have a better solution, just forbid
> > to re-enable I/O stat accounting after it has been disabled.
> 
> hm.  Is it really so hard to just quiesce the device until all in-flight
> requests have drained?  freeze_bdev() might be a suitable starting point?

That was my suggestion as well, we really need to be able to turn it
back on again. Ideally, I'd like iostat and friends to turn it on/off
when somebody does the monitoring. A one-way street option is not very
nice.

-- 
Jens Axboe

