Return-Path: <linux-kernel-owner+w=401wt.eu-S1758110AbZBSPVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758110AbZBSPVl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 10:21:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752130AbZBSPVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 10:21:32 -0500
Received: from mx2.redhat.com ([66.187.237.31]:33254 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751265AbZBSPVb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 10:21:31 -0500
Subject: Re: [PATCH] drm: Take mmap_sem up front to avoid lock order
 violations.
From: Kristian =?ISO-8859-1?Q?H=F8gsberg?= <krh@redhat.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>, krh@bitplanet.net, eric@anholt.net,
       Wang Chen <wangchen@cn.fujitsu.com>, dri-devel@lists.sf.net,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>
In-Reply-To: <20090219151701.GG1747@wotan.suse.de>
References: <499BC08C.5000603@cn.fujitsu.com>
	 <1234975113-4941-1-git-send-email-krh@bitplanet.net>
	 <1235035145.4612.38.camel@laptop> <1235039601.4612.45.camel@laptop>
	 <1235054980.31384.16.camel@gaara.bos.redhat.com>
	 <20090219151701.GG1747@wotan.suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 Feb 2009 10:21:16 -0500
Message-Id: <1235056876.31384.22.camel@gaara.bos.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-19 at 16:17 +0100, Nick Piggin wrote:
> On Thu, Feb 19, 2009 at 09:49:40AM -0500, Kristian Høgsberg wrote:
> > 
> > > Secondly, mmap_sem is not a recursive lock (very few kernel locks are,
> > > and we generally frown upon recursive locking schemes), this means that
> > > the fault handler still cannot function properly.
> > 
> > I understand, but we take it twice only as a read lock, so that should
> > work, right?  We prevent the deadlock the lockdep validator warned about
> > and as far as I can see, the patch doesn't introduce a new one.  But
> > other than that I agree with the frowning on recursive locking, it's too
> > often used to paper over badly thought out locking.
> 
> It doesn't work. rwsems are fair (otherwise there is terrible starvation
> properties), so if another process does an interleaved down_write, then
> the 2nd down_read will block until the down_write is serviced.

Ooh, right, yes of course, ouch.

thanks,
Kristian


