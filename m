Return-Path: <linux-kernel-owner+w=401wt.eu-S1753670AbZH3Q6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670AbZH3Q6k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 12:58:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753527AbZH3Q6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 12:58:39 -0400
Received: from mail2.shareable.org ([80.68.89.115]:50711 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753516AbZH3Q6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 12:58:38 -0400
Date: Sun, 30 Aug 2009 17:58:34 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Ulrich Drepper <drepper@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: adding proper O_SYNC/O_DSYNC, was Re: O_DIRECT and barriers
Message-ID: <20090830165834.GC7129@shareable.org>
References: <20090821152459.GC6929@shareable.org> <20090821174525.GA28861@infradead.org> <20090822005006.GA22530@shareable.org> <20090824023422.GA775@infradead.org> <20090827143459.GB31453@shareable.org> <20090827171044.GA5427@infradead.org> <4A96C14C.8040105@redhat.com> <20090828154647.GA15808@infradead.org> <20090828164432.GA8036@shareable.org> <4A984758.5020008@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A984758.5020008@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Drepper wrote:
> On 08/28/2009 09:44 AM, Jamie Lokier wrote:
> >(Oh, and Ulrich: Why is there a "#define O_RSYNC O_SYNC" in the Glibc
> >headers?  That doesn't make sense: O_RSYNC has nothing to do with
> >writing.)
> 
> O_SYNC is a superset of O_RSYNC.  In the absence of a true O_RSYNC 
> that's the next best thing.

That's an error - O_SYNC is not a superset of O_RSYNC.

O_SYNC (by itself) only affects writes.

O_RSYNC only affect reads.

In the absence of O_RSYNC support in the kernel, it's better to not
define O_RSYNC at all in userspace.  That tells applications they can
call fsync/fdatasync themselves before reading to get an equivalent
effect.

In fact O_RSYNC, when implemented correctly, can be used by
applications to get the effect of range-fsync/fdatasync when such
system calls aren't available (by reading a range), but not as
efficiently of course.  Defining O_RSYNC as O_SYNC fails to do that.

-- Jamie
