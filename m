Return-Path: <linux-kernel-owner+w=401wt.eu-S1754311AbYBROme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311AbYBROme (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 09:42:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751583AbYBROmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 09:42:23 -0500
Received: from one.firstfloor.org ([213.235.205.2]:59956 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbYBROmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 09:42:21 -0500
Date: Mon, 18 Feb 2008 16:18:23 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Theodore Tso <tytso@mit.edu>, Andi Kleen <andi@firstfloor.org>,
       Tomasz Chmielewski <mangoo@wpkg.org>,
       LKML <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: very poor ext3 write performance on big filesystems?
Message-ID: <20080218151823.GA26622@one.firstfloor.org>
References: <47B980AC.2080806@wpkg.org> <p7363wmxsxr.fsf@bingen.suse.de> <20080218141640.GC12568@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080218141640.GC12568@mit.edu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18, 2008 at 09:16:41AM -0500, Theodore Tso wrote:
> ext3 tries to keep inodes in the same block group as their containing
> directory.  If you have lots of hard links, obviously it can't really
> do that, especially since we don't have a good way at mkdir time to
> tell the filesystem, "Psst!  This is going to be a hard link clone of
> that directory over there, put it in the same block group".

Hmm, you think such a hint interface would be worth it?

> 
> > What has helped a bit was to recreate the file system with -O^dir_index
> > dir_index seems to cause more seeks.
> 
> Part of it may have simply been recreating the filesystem, not

Undoubtedly.

> necessarily removing the dir_index feature.  Dir_index speeds up
> individual lookups, but it slows down workloads that do a readdir

But only for large directories right? For kernel source like
directory sizes it seems to be a general loss.

-Andi

