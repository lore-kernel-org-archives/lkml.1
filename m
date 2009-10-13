Return-Path: <linux-kernel-owner+w=401wt.eu-S1760516AbZJMQ2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760516AbZJMQ2R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 12:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760505AbZJMQ2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 12:28:17 -0400
Received: from 139-142-54-143.atc.vaillant.ca ([139.142.54.143]:55679 "EHLO
	quartz.edm.orcorp.ca" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760484AbZJMQ2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 12:28:16 -0400
Date: Tue, 13 Oct 2009 10:27:25 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pavel Machek <pavel@ucw.cz>, Roland Dreier <rdreier@cisco.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-rdma@vger.kernel.org,
       linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       Anton Blanchard <anton@samba.org>, general@lists.openfabrics.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       Jeff Squyres <jsquyres@cisco.com>
Subject: Re: [ofa-general] Re: [GIT PULL] please pull ummunotify
Message-ID: <20091013162725.GL18578@obsidianresearch.com>
References: <adazl8td35u.fsf@cisco.com> <adatyz1d17q.fsf@cisco.com> <20090929171332.GD14405@elf.ucw.cz> <20090930094456.GD24621@elte.hu> <20090930160232.GZ22310@obsidianresearch.com> <20091012181944.GF17138@elte.hu> <20091012193048.GA20313@obsidianresearch.com> <20091012202046.GA7648@elte.hu> <20091013040515.GI18578@obsidianresearch.com> <20091013064006.GC9470@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091013064006.GC9470@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 13, 2009 at 08:40:06AM +0200, Ingo Molnar wrote:
> 
> * Jason Gunthorpe <jgunthorpe@obsidianresearch.com> wrote:
> 
> > On Mon, Oct 12, 2009 at 10:20:46PM +0200, Ingo Molnar wrote:
> > > It might be more acceptable because the flag-hint mechanism can at most 
> > > cause over-flushing - while with perf events we might miss to invalidate 
> > > a range altogether.
> > 
> > Right. Overflushing is not important, but missing an event entirely is 
> > not recoverable (at least within the current kernel APIs).
> 
> So if we detect event loss in the perf event case (should not happen 
> with sufficient buffering but it is a possibility the code should be 
> prepared for) then we can just flush the [0,-1ULL] range, right?

No, the reason overflushing within a registration is OK is because of
how the MPI APIs are defined and typically used. The map and
registration window will typically be 1:1 ie you malloc something and
then register it. It is an error to register beyond your malloced
space. So, in truth, the hint stuff isn't really essential for MPI.

flushing all ranges would result in data loss since ranges may be in
use at the time, and 'flush' is actually unregister/reregister - the
hardware cannot do in place atomic modify.

Jason
