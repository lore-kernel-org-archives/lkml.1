Return-Path: <linux-kernel-owner+w=401wt.eu-S1753558AbZH3QoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558AbZH3QoU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 12:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753480AbZH3QoT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 12:44:19 -0400
Received: from mail2.shareable.org ([80.68.89.115]:53631 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477AbZH3QoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 12:44:18 -0400
Date: Sun, 30 Aug 2009 17:44:11 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Ulrich Drepper <drepper@redhat.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: adding proper O_SYNC/O_DSYNC, was Re: O_DIRECT and barriers
Message-ID: <20090830164411.GB7129@shareable.org>
References: <20090827143459.GB31453@shareable.org> <20090827171044.GA5427@infradead.org> <4A96C14C.8040105@redhat.com> <20090828154647.GA15808@infradead.org> <4A98008B.6050503@redhat.com> <20090828161745.GA8755@infradead.org> <4A9806D9.5050409@redhat.com> <20090828164106.GA9951@infradead.org> <4A984337.7080009@redhat.com> <20090828210838.GA26799@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090828210838.GA26799@infradead.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> P.S. better naming suggestions for O_FULLSYNC welcome

O_FULLSYNC might get confused with MacOS X's F_FULLSYNC, which means
something else: fsync through hardware volatile write caches.

(Might we even want to provide O_FULLSYNC and O_FULLDATASYNC to mean
that, eventually?)

O_ISYNC is a bit misleading if we don't really offer "flush just the
inode state" by itself.

So it should at least start with underscores: __O_ISYNC.

How about __O_SYNC_NEW with

    #define O_SYNC     (O_DSYNC|__O_SYNC_NEW)

I think that tells people reading the headers a bit about what to
expect on older kernels too.

-- Jamie
