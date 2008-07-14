Return-Path: <linux-kernel-owner+w=401wt.eu-S1756762AbYGNQPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756762AbYGNQPx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 12:15:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754461AbYGNQPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 12:15:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51603 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754096AbYGNQPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 12:15:43 -0400
Date: Mon, 14 Jul 2008 09:15:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Mike Snitzer" <snitzer@gmail.com>
Cc: "Hidehiro Kawai" <hidehiro.kawai.ez@hitachi.com>, jack@suse.cz,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Satoshi OSHIMA" <satoshi.oshima.fk@hitachi.com>,
       sugita <yumiko.sugita.yf@hitachi.com>
Subject: Re: - jbd-strictly-check-for-write-errors-on-data-buffers.patch
 removed from -mm tree
Message-Id: <20080714091507.0ae6ecca.akpm@linux-foundation.org>
In-Reply-To: <170fa0d20807140708k46f86ac1tfee50d3fa14e3e41@mail.gmail.com>
References: <200806092212.m59MC553010889@imap1.linux-foundation.org>
	<484E4097.2010204@hitachi.com>
	<20080610021746.51e5cfa8.akpm@linux-foundation.org>
	<170fa0d20807140708k46f86ac1tfee50d3fa14e3e41@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jul 2008 10:08:24 -0400 "Mike Snitzer" <snitzer@gmail.com> wrote:

> On Tue, Jun 10, 2008 at 5:17 AM, Andrew Morton <akpm@linux-foundation.org>
> wrote:
> 
> > On Tue, 10 Jun 2008 17:51:35 +0900 Hidehiro Kawai <
> > hidehiro.kawai.ez@hitachi.com> wrote:
> >
> > > Hello Andrew,
> > >
> > > akpm@linux-foundation.org wrote:
> > >
> > > > The patch titled
> > > >      jbd: strictly check for write errors on data buffers
> > > > has been removed from the -mm tree.  Its filename was
> > > >      jbd-strictly-check-for-write-errors-on-data-buffers.patch
> > > >
> > > > This patch was dropped because I don't think we want to go read-only on
> > file data write errors
> > > >
> > > > The current -mm tree may be found at
> > http://userweb.kernel.org/~akpm/mmotm/<http://userweb.kernel.org/%7Eakpm/mmotm/>
> > > >
> > > > ------------------------------------------------------
> > > > Subject: jbd: strictly check for write errors on data buffers
> > > > From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
> > >
> > > This patch series doesn't change the behavior on file data write
> > > errors as I stated before, but we found that the current behavior has
> > > been made accidentally.  So yesterday I sent an additional patch(*)
> > > which removes the invocation of journal_abort() and thus stop making
> > > the fs read-only on file data write errors, but it seems to be late
> > > for the -mm release preparation.
> > >
> > >   Patch(*) can be found at:
> > >   http://marc.info/?l=linux-kernel&m=121300618614453&w=2
> > >
> > > Anyway, as this patch series was dropped from -mm, I'm going to
> > > send a revised version.
> > >
> > > I plan to separate these pathces into three patche set.
> > > The first patch (set) corrects the current behavior in ordered
> > > writes, it means it removes the invocation of journal_abort() on file
> > > data write errors.  It is the almost same as the patch(*).
> > > The second patch set fixes error handlings for metadata writes and
> > > checkpointing.  It should be applied independently of the first
> > > patch set, and it is the same as PATCH 3/5 to 5/5.
> > > The third patch set makes "abort the journal on file data write errors"
> > > tunable for mission critical users.  Of course, this feature depends
> > > on the first patch set.
> > >
> >
> > That sounds like a good plan, thanks.
> 
> 
> Hidehiro and Andrew,
> 
> The first patch(set) has been in -mm with the following patches:
> jbd-dont-abort-if-flushing-file-data-failed.patch
> jbd-dont-abort-if-flushing-file-data-failed-fix.patch
> 
> "PATCH 3/5 to 5/5" haven't made their way into -mm; nor has the tunable
> "abort the journal on file data write errors".  Where do things stand on
> this work?
> 
> Given the potential for corruption and the fact that -mm's series file
> justifiably has a place-holder comment of "jbd write-error stuff: scary" I'm
> wondering: how soon will all associated fixes be included in -mm?

I assume they'll be resent if/when they're ready?
