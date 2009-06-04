Return-Path: <linux-kernel-owner+w=401wt.eu-S1754148AbZFDKhC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148AbZFDKhC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 06:37:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752422AbZFDKgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 06:36:53 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:56391 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbZFDKgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 06:36:53 -0400
Date: Thu, 4 Jun 2009 12:39:09 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-kbuild@vger.kernel.org
Subject: Re: [Patch 1/2] kbuild: two trivial fixes for check headers
Message-ID: <20090604103909.GA10102@uranus.ravnborg.org>
References: <20090604080406.7005.27662.sendpatchset@localhost.localdomain> <20090604091519.GA9571@uranus.ravnborg.org> <4A27927E.9090800@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A27927E.9090800@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 04, 2009 at 05:23:10PM +0800, Amerigo Wang wrote:
> Sam Ravnborg wrote:
> >On Thu, Jun 04, 2009 at 04:01:52AM -0400, Amerigo Wang wrote:
> >  
> >>Remove a useless 'extern' in an exported header.
> >>Fix a comment headers_check.pl.
> >>    
> >
> >These two patches has nothing in commom.
> >  
> 
> They are both about kernel headers stuff.
> 
> >  
> >>Signed-off-by: WANG Cong <amwang@redhat.com>
> >>Cc: Sam Ravnborg <sam@ravnborg.org>
> >>
> >>------
> >>diff --git a/include/mtd/jffs2-user.h b/include/mtd/jffs2-user.h
> >>index fa94b0e..10dc7ef 100644
> >>--- a/include/mtd/jffs2-user.h
> >>+++ b/include/mtd/jffs2-user.h
> >>@@ -18,7 +18,7 @@
> >> #undef je32_to_cpu
> >> #undef jemode_to_cpu
> >> 
> >>-extern int target_endian;
> >>+int target_endian;
> >>    
> >
> >You now declare a global variable named target_endian each time you 
> >include this file - which is wrong.
> >  
> Why? 'make headers_check' complains about it.

Rightfully is does...
But is think it is a prototype of a function.

But think about it - it does not makes sense to have an
extern declarationof a variable in an exported header.
There is no way that userspace can access this variable
from user-space and therefore the declaration of the variable
needs to be moved to a kernel-only header file.

So if you touch this I would ask you not to consider a single line
in jffs-user.h - but rather take a critiacal look at the whole
file and fix any issues there is.
And then to send it to the mtd people (dwmw2).
I did not look at the file but just looking at yout patch
the "undef jemode_to_cpu" looks fishy in an exported header.

	Sam
