Return-Path: <linux-kernel-owner+w=401wt.eu-S1755741AbXJIRvy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755741AbXJIRvy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 13:51:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753594AbXJIRvr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 13:51:47 -0400
Received: from hu-out-0506.google.com ([72.14.214.238]:32730 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939AbXJIRvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 13:51:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=Uh2BgzwEcZb6GDR657qQuQF5+evYYfVU7Ew1cWYJ6lK03cQThLb2HvYOJGE7egin8BxVBjFIEgRaUgN3vCuIMJ/5p92n5ayU+FXsj4tlJWtnw/BLVdPlWL0718zOD2+41mCY+sQKvCFVkdwAW2BGk41ZAH9qvDt1TlLPNpmOw3I=
Date: Tue, 9 Oct 2007 19:51:33 +0200
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Rob Landley <rob@landley.net>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, rdunlap@xenotime.net
Subject: Re: [PATCH] Stop docproc segfaulting when SRCTREE isn't set.
Message-ID: <20071009175132.GB11579@Ahmed>
References: <200710090125.19089.rob@landley.net> <20071009130315.GB4245@Ahmed> <20071009085500.e7be49a0.randy.dunlap@oracle.com> <20071009171949.GA11579@Ahmed> <470BB933.8010402@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <470BB933.8010402@oracle.com>
User-Agent: Mutt/1.5.11
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2007 at 10:24:03AM -0700, Randy Dunlap wrote:
> Ahmed S. Darwish wrote:
> >On Tue, Oct 09, 2007 at 08:55:00AM -0700, Randy Dunlap wrote:
> >>On Tue, 9 Oct 2007 15:03:15 +0200 Ahmed S. Darwish wrote:
> >>
> >>>Hi Rob,
> >>>
> >>>On Tue, Oct 09, 2007 at 01:25:18AM -0500, Rob Landley wrote:
> >>>[...]
> >>>> 	FILE * infile;
> >>>>+
> >>>>+	srctree = getenv("SRCTREE");
> >>>>+	if (!srctree) srctree = getcwd(NULL,0);
> >>>> 	if (argc != 3) {
> >>>> 		usage();
> >>>> 		exit(1);
> >>>$ man getcwd
> >>>
> >>> char *getcwd(char *buf, size_t size);
> >>>      
> >>> As an extension to the POSIX.1 standard, Linux (libc4, libc5, glibc) 
> >>> getcwd() allocates the buffer dynamically using malloc() if buf is NULL 
> >>> on call.
> >>>
> >>>Shouldn't "srctree" be free()ed in case getenv("SRCTREE") failed ?
> >>What is there to free() at that point?  If getenv() fails (i.e.,
> >>the env. variable is not found), it returns NULL.
> >>or do I need another cup of coffee?
> >>
> >
> >I meant if getenv() failed, "srctree = getcwd(NULL, 0)" will let 
> >"srctree" point to a _ malloc()ed _ buffer representing PWD. 
> >As said in the manpage, this buffer needs to be free()ed after usage.
> >Right or I'm the one who needs that cup of coffee :) ?
> 
> so it needs to be freed at program termination, is that what you are
> saying?  That will happen automatically (along with any open files being
> closed, etc.).
> 

I didn't know that leaked mem will be automatically freed at program 
termination. A new info, Thanks!.

-- 
Ahmed S. Darwish
HomePage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com
