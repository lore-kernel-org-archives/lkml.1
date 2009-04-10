Return-Path: <linux-kernel-owner+w=401wt.eu-S937801AbZDJRHO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937801AbZDJRHO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 13:07:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760959AbZDJRGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 13:06:52 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:56220 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757913AbZDJRGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 13:06:51 -0400
Date: Fri, 10 Apr 2009 18:05:07 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Tejun Heo <tj@kernel.org>,
       Mike Travis <travis@sgi.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] unbreak alpha percpu
Message-ID: <20090410170507.GR26366@ZenIV.linux.org.uk>
References: <20090410151224.GM26366@ZenIV.linux.org.uk> <20090410154704.GN26366@ZenIV.linux.org.uk> <alpine.LFD.2.00.0904100915010.4583@localhost.localdomain> <20090410165030.GQ26366@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090410165030.GQ26366@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 10, 2009 at 05:50:30PM +0100, Al Viro wrote:
> On Fri, Apr 10, 2009 at 09:21:08AM -0700, Linus Torvalds wrote:
> > 
> > Hmm. I certainly personally _much_ prefer this version.
> > 
> > It looks like this actually simplifies things for S390 too (no more 
> > simple_identifier_##var games), and generally just looks better. And 
> > seeing that the S390 special case is no longer S390-specific is also a 
> > good sign, imho.
> 
> simple_identifier_##var has been debris from back when Ingo forced
> s390 to use asm-generic/percpu.h; if you look at it, you'll see that
> a) it hadn't worked (look at the argument list carefully) and
> b) get_cpu_var() has the working version anyway
> 
> Less obvious part is that if it actually *would* work, we'd be screwed -
> unlike get_cpu_var() this sucker is called for things that are not
> simple variables; didn't happen for alpha, but did for s390.
> 
> IOW, that's just an old piece of junk that got removed now.

Fsck...  It breaks per_cpu_ptr() :-/  OK, back to square one, then...
