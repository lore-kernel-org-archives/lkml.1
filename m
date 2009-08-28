Return-Path: <linux-kernel-owner+w=401wt.eu-S1751954AbZH1QrE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954AbZH1QrE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 12:47:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751596AbZH1QrD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 12:47:03 -0400
Received: from mail2.shareable.org ([80.68.89.115]:38747 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386AbZH1QrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 12:47:02 -0400
Date: Fri, 28 Aug 2009 17:46:58 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Ulrich Drepper <drepper@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: adding proper O_SYNC/O_DSYNC, was Re: O_DIRECT and barriers
Message-ID: <20090828164657.GB8036@shareable.org>
References: <20090821174525.GA28861@infradead.org> <20090822005006.GA22530@shareable.org> <20090824023422.GA775@infradead.org> <20090827143459.GB31453@shareable.org> <20090827171044.GA5427@infradead.org> <4A96C14C.8040105@redhat.com> <20090828154647.GA15808@infradead.org> <4A98008B.6050503@redhat.com> <20090828161745.GA8755@infradead.org> <4A9806D9.5050409@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A9806D9.5050409@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Drepper wrote:
> >  - O_RSYNC basically means we need to commit atime updates before a
> >    read returns, right?
> 
> No, that's not it.
> 
> O_RSYNC on its own just means the data is successfully transferred to 
> the calling process (always the case).
> 
> O_RSYNC|O_DSYNC means that if a read request hits data that is currently 
> in a cache and not yet on the medium, then the write to medium is 
> successful before the read succeeds.
> 
> O_RSYNC|O_SYNC means the same plus the integrity of file meta 
> information (access time etc).

On several unixes, O_RSYNC means it will send the read to the
hardware, not relying on the cache.  This can be used to verify the
data which was written earlier, whether by O_DSYNC or fdatasync.

-- Jamie
