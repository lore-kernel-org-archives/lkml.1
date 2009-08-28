Return-Path: <linux-kernel-owner+w=401wt.eu-S1752579AbZH1VIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579AbZH1VIl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 17:08:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752051AbZH1VIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 17:08:40 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45600 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbZH1VIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 17:08:39 -0400
Date: Fri, 28 Aug 2009 17:08:38 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Ulrich Drepper <drepper@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jamie Lokier <jamie@shareable.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: adding proper O_SYNC/O_DSYNC, was Re: O_DIRECT and barriers
Message-ID: <20090828210838.GA26799@infradead.org>
References: <20090824023422.GA775@infradead.org> <20090827143459.GB31453@shareable.org> <20090827171044.GA5427@infradead.org> <4A96C14C.8040105@redhat.com> <20090828154647.GA15808@infradead.org> <4A98008B.6050503@redhat.com> <20090828161745.GA8755@infradead.org> <4A9806D9.5050409@redhat.com> <20090828164106.GA9951@infradead.org> <4A984337.7080009@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A984337.7080009@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 28, 2009 at 01:51:03PM -0700, Ulrich Drepper wrote:
> No, that's not a good idea.  This would mean a program compiled with  
> newer headers is using O_SYNC which isn't known to old kernels and  
> ignored.  Such programs will then not even get the current O_DSYNC 
> benefits.

Ok, let's agree on how to proceed:


once 2.6.31 is out we will do the following

 - do a global s/O_SYNC/O_DSYNC/g over the whole kernel tree
 - add a this to include/asm-generic/fcntl.h and in modified form
   to arch headers not using it:

#ifndef O_FULLSYNC
#define O_FULLSYNC	02000000
#endif

#ifndef O_RSYNC
#define O_RSYNC		04000000
#endif

#define O_SYNC	(O_FULLSYNC|O_DSYNC)

 - during the normal merge window I will add a real implementation for
   for O_FULLSYNC and O_RSYNC

P.S. better naming suggestions for O_FULLSYNC welcome
