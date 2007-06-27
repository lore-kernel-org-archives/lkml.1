Return-Path: <linux-kernel-owner+w=401wt.eu-S1762206AbXF0SEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762206AbXF0SEU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 14:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757280AbXF0SEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 14:04:13 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:56495 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756443AbXF0SEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 14:04:12 -0400
Date: Wed, 27 Jun 2007 19:04:09 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Neil Booth <neil@daikokuya.co.uk>, Josh Triplett <josh@freedesktop.org>,
       Segher Boessenkool <segher@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, linux-sparse@vger.kernel.org
Subject: Re: [PATCH 16/16] fix handling of integer constant expressions
Message-ID: <20070627180408.GC21478@ftp.linux.org.uk>
References: <alpine.LFD.0.98.0706241203530.3593@woody.linux-foundation.org> <1a25667a20e43a072f733a3ec2b8e79d@kernel.crashing.org> <20070624203837.GE21478@ftp.linux.org.uk> <467F531A.3030702@freedesktop.org> <20070626221040.GI21478@ftp.linux.org.uk> <20070626221134.GA21350@ftp.linux.org.uk> <20070627121021.GQ7590@daikokuya.co.uk> <alpine.LFD.0.98.0706270910000.8675@woody.linux-foundation.org> <20070627172903.GB21478@ftp.linux.org.uk> <alpine.LFD.0.98.0706271043570.8675@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0706271043570.8675@woody.linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2007 at 10:45:55AM -0700, Linus Torvalds wrote:
> 
> 
> On Wed, 27 Jun 2007, Al Viro wrote:
> > 
> > Eh...  I'd say that my variant for offsetof() is simply better - it usually
> > directly turns into EXPR_VALUE, right in place, without rather convoluted
> > work.  Aside of "should such cast be a constant integer expression"...
> 
> Umm. But sparse is meant to parse C code. Which very much includes *other* 
> projects.
> 
> The kernel, for example, has its own offsetof. And yes, these days we use 
> "__compiler_offsetof()", but we used to do
> 
> 	#define offsetof(TYPE, MEMBER) ((size_t) &((TYPE *)0)->MEMBER)
> 
> and I seriously doubt that the kernel is the only one doing things like 
> that.

You can't have it both way, really.  If we are talking about annotating
a codebase we _can_ annotate, that one is not a problem at all.  If we
are talking about vanilla C project that never heard about sparse...
We can define whatever extensions we like, but such project has to
cope with whatever C compilers they had been using.

So "sparse believes that this defintion of offsetof can be used as
array size" will mean fsck-all outside of #ifdef __CHECKER__ and
under such ifdef we can always define it to builtin; if anything,
that will be faster and easier on sparse.
