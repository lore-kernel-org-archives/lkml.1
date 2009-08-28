Return-Path: <linux-kernel-owner+w=401wt.eu-S1751306AbZH1Pqy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751306AbZH1Pqy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 11:46:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751195AbZH1Pqx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 11:46:53 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40617 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166AbZH1Pqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 11:46:52 -0400
Date: Fri, 28 Aug 2009 11:46:47 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Ulrich Drepper <drepper@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jamie Lokier <jamie@shareable.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: adding proper O_SYNC/O_DSYNC, was Re: O_DIRECT and barriers
Message-ID: <20090828154647.GA15808@infradead.org>
References: <20090821114010.GG12579@kernel.dk> <20090821135403.GA6208@shareable.org> <20090821142635.GB30617@infradead.org> <20090821152459.GC6929@shareable.org> <20090821174525.GA28861@infradead.org> <20090822005006.GA22530@shareable.org> <20090824023422.GA775@infradead.org> <20090827143459.GB31453@shareable.org> <20090827171044.GA5427@infradead.org> <4A96C14C.8040105@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A96C14C.8040105@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 27, 2009 at 10:24:28AM -0700, Ulrich Drepper wrote:
> The problem with O_* extensions is that the syscall doesn't fail if the  
> flag is not handled.  This is a problem in the open implementation which  
> can only be fixed with a new syscall.
>
> Why cannot just go on and say we interpret O_SYNC like O_SYNC and  
> O_SYNC|O_DSYNC like O_DSYNC.  The POSIX spec explicitly requires that  
> the latter handled like O_SYNC.
>
> We could handle it by allocating two bits, only one is handled in the  
> kernel.  If the O_DSYNC definition for userlevel would be different from  
> the kernel definition then the kernel could interpret O_SYNC|O_DSYNC  
> like O_DSYNC.  The libc would then have to translate the userlevel  
> O_DSYNC into the kernel O_DSYNC.  If the libc is too old for the kernel  
> and the application, the userlevel flag would be passed to the kernel  
> and nothing bad happens.

What about hte following variant:

 - given that our current O_SYNC really is and always has been actuall
   Posix O_DSYNC keep the numerical value and rename it to O_DSYNC in
   the headers.
 - Add a new O_SYNC definition:

	#define O_SYNC		(O_DSYNC|O_REALLY_SYNC)

   and do full O_SYNC handling in new kernels if O_REALLY_SYNC is
   present.
