Return-Path: <linux-kernel-owner+w=401wt.eu-S1757052AbYKCV3L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757052AbYKCV3L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 16:29:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755767AbYKCV2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 16:28:53 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37504 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755588AbYKCV2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 16:28:52 -0500
Date: Mon, 3 Nov 2008 13:27:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Theodore Tso <tytso@mit.edu>
Cc: ajones@riverbed.com, sandeen@redhat.com, linux-ext4@vger.kernel.org,
       sct@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext3: wait on all pending commits in ext3_sync_fs
Message-Id: <20081103132735.9e63a3d0.akpm@linux-foundation.org>
In-Reply-To: <20081103211929.GA18117@mit.edu>
References: <4908C951.2000309@redhat.com>
	<20081103184426.GA31894@ajones-laptop.nbttech.com>
	<20081103113318.35b0c266.akpm@linux-foundation.org>
	<20081103201428.GB30565@ajones-laptop.nbttech.com>
	<20081103123750.67c96224.akpm@linux-foundation.org>
	<20081103205854.GC30565@ajones-laptop.nbttech.com>
	<20081103131313.e9ae2f93.akpm@linux-foundation.org>
	<20081103211929.GA18117@mit.edu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Nov 2008 16:19:29 -0500
Theodore Tso <tytso@mit.edu> wrote:

> On Mon, Nov 03, 2008 at 01:13:13PM -0800, Andrew Morton wrote:
> > On Mon, 3 Nov 2008 12:58:54 -0800
> > Arthur Jones <ajones@riverbed.com> wrote:
> > 
> > > Hi Andrew, ...
> > > 
> > > On Mon, Nov 03, 2008 at 12:37:50PM -0800, Andrew Morton wrote:
> > > > [...]
> > > > OK.  But still, questions remain.
> > > > 
> > > > - should we clear s_dirt if log_wait_commit() didn't work?
> > > > 
> > > > - ext3_force_commit() clears s_dirt also
> > > > 
> > > > - should ext3_sync_fs() be dropping the ext3_force_commit() return
> > > >   value on the floor?
> 
> Should all the callers of ->sync_fs also be dropping the error returns
> on the floor?

Oh, this is sync_fs.  How meaningful would it be to return an error
from sys_umount()?  Would there be any point in leaving the errored fs
mounted?  Dunno.

But if we're going to drop this error on the floor, we should do
that at a higher level, not on a per-fs basis ;)

