Return-Path: <linux-kernel-owner+w=401wt.eu-S1763493AbYD3Qbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763493AbYD3Qbn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 12:31:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758357AbYD3Qbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 12:31:32 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:41886 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755913AbYD3Qbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 12:31:31 -0400
Subject: Re: AIO/DIO lockup/crash
From: Peter Zijlstra <peterz@infradead.org>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-aio <linux-aio@kvack.org>, Zach Brown <zach.brown@oracle.com>,
       Clark Williams <williams@redhat.com>
In-Reply-To: <x49tzhjcsdw.fsf@segfault.boston.devel.redhat.com>
References: <1209385782.13978.17.camel@twins>
	 <20080428090857.beb19a20.akpm@linux-foundation.org>
	 <1209404909.13978.23.camel@twins>
	 <x49tzhjcsdw.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain
Date: Wed, 30 Apr 2008 18:31:09 +0200
Message-Id: <1209573069.6433.41.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-04-30 at 10:46 -0400, Jeff Moyer wrote:
> Peter Zijlstra <peterz@infradead.org> writes:
> 
> > On Mon, 2008-04-28 at 09:08 -0700, Andrew Morton wrote:
> >
> >> erk, that's dio->bio_lock, isn't it?
> >
> > Yep.
> >
> >> That lock is super-simple and hasn't changed in quite some time.  If there
> >> has been major memory wreckage and we're simply grabbing at a "lock" in
> >> random memory then I'd expect the bug to maninfest in different ways on
> >> different runs?
> >
> > Looks like it.
> >
> >> I assume you have lots of runtime debugging options enabled.
> >
> > Not on this particular run. I'll start a -git run this evening with most
> > of the debugging option enabled. It takes a few hours to reproduce, so I
> > let it run over-night.
> 
> Peter, any update on this?
> 
> FWIW, I've been running the aio-dio-invalidate-failure test on a fedora
> kernel (2.6.25-8.fc9.i686) for several days now without any problems.
> However, I'm not sure I can reproduce the bugs at all.  I'll revert to a
> 2.6.24 kernel and try.

I've ran -git for 10+ hours without crashing, but I've also
changed .config settings (enabled many debugging switches). I'm starting
to work my way backwards to the previous setup that did crash, but since
it takes so long to test each kernel its slow going.



