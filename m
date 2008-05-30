Return-Path: <linux-kernel-owner+w=401wt.eu-S1761600AbYE3ERt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761600AbYE3ERt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 00:17:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760349AbYE3EON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 00:14:13 -0400
Received: from xenotime.net ([66.160.160.81]:57649 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758756AbYE3EOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 00:14:10 -0400
Date: Thu, 29 May 2008 21:27:46 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Paul Jackson <pj@sgi.com>
Cc: miaox@cn.fujitsu.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, menage@google.com
Subject: Re: [RFC] [PATCH 1/2] cpusets: restructure the function
 update_cpumask() and update_nodemask()
Message-Id: <20080529212746.2d9cae24.rdunlap@xenotime.net>
In-Reply-To: <20080529225708.74f65654.pj@sgi.com>
References: <483E564A.5050807@cn.fujitsu.com>
	<20080529031656.cdc38001.pj@sgi.com>
	<483F5DAA.5060004@cn.fujitsu.com>
	<20080529205344.4ba1efdb.pj@sgi.com>
	<483F6367.1040701@cn.fujitsu.com>
	<20080529212211.0e794c81.pj@sgi.com>
	<20080529203042.19f76f09.rdunlap@xenotime.net>
	<20080529225708.74f65654.pj@sgi.com>
Organization: YPO4
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2008 22:57:08 -0500 Paul Jackson wrote:

> Randy wrote:
> > For static functions, it's up to the maintainer/developer whether to do that
> > or not.  But if the functions already have kernel-doc, there's no strong
> > reason to remove it.  And these look good currently, so I see no
> > good reason to change them.
> 
> Ok - thank-you for the explanation.
> 
> I had this vague recollection that kernel-doc was just for non-static
> functions, so when I saw Miao put kernel-doc comments on a static
> routine, I looked around to see if that was normal.
> 
> I didn't see mention of static functions in kernel-doc-nano-HOWTO.txt,

There's no restriction to static or non-static.

> and in a brief survey, didn't happen to see any static functions with
> kernel-doc comments.  However my survey was so brief I even missed five

There are plenty of them.

> such functions in the file I maintain, kernel/cpuset.c.  So from that
> I came to the (apparently flawed) conclusion that it didn't make sense
> to kernel-doc static functions, and so advised Miao.
> 
> I don't quite see what purpose kernel-doc would have for static
> functions, and am still concerned that such would (mildly) clutter the
> presentation of the externally visible cpuset functions in which those
> who just use cpusets would be interested.

Well, they won't clutter the generated kernel-doc docbook output unless
you/we/someone requests that both non-static and static functions be listed
in it.  (more on that below)

> It remains, of course, important to have good documentation of
> functions, static or not, but I would expect developers working inside
> the kernel/cpuset.c file to look for documentation of functions
> static to that file within the code and comments of that file, not in
> kernel-doc.

kernel-doc is in comments.  Just specially formatted ones.

> However I am just the cpuset maintainer, not a kernel-doc expert.
> 
> I remain inclined toward removing the kernel-doc markings on static
> functions in kernel/cpuset.c, but if you wish, Randy, to make a renewed
> appeal for me not to do so, I will happily honor that appeal.
> 
> Life is good either way when we are discussing how to annotate
> documentation, rather than lamenting its absence.

a.  I looked at those 5 functions.  They should be documented, whether
it's done with kernel-doc or some other way.  I don't see why there would
be a problem with using kernel-doc instead of something else.

b.  Yes, any documentation along these lines is better than none.  We agree.

> If you, Randy, felt inclined to explain the value of kernel-doc comments
> on file static functions in kernel-doc-nano-HOWTO.txt, that might be
> valuable for the next person who travels this path.

It might need a little tweaking.  Basically what is already there says:

"""
!E<filename> is replaced by the documentation, in <filename>, for
functions that are exported using EXPORT_SYMBOL: the function list is
collected from files listed in Documentation/DocBook/Makefile.

!I<filename> is replaced by the documentation for functions that are
_not_ exported using EXPORT_SYMBOL.
"""

so if a docbook (like one generated from Documentation/DocBook/kernel-api.tmpl)
uses both of these:
!Ekernel/cpuset.c
!Ikernel/cpuset.c

then that docbook will contain both exported functions and non-exported ones.
To produce a docbook with only exported symbols, use only
!Ekernel/cpuset.c


The nuance here is the difference in exported/non-exported vs. non-static/static.

> Thank-you.

Same to you, sir.

Does that help?  your understanding of kernel-doc or your decision?

---
~Randy
"He closes his eyes and drops the goggles.  You can't get hurt
by looking at a bitmap.  Or can you?"
