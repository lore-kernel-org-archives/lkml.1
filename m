Return-Path: <linux-kernel-owner+w=401wt.eu-S1755541AbXJIRUO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541AbXJIRUO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 13:20:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752485AbXJIRUB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 13:20:01 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:34162 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126AbXJIRUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 13:20:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=gtOsx/kKvb0Wf6L/CsJsv7NBZubd3vo3gTBT7edW0aKD1StlRO/uBjIBv8APda81to6CAEOV1LaP4o4fRC/g8upVHuaUzq65uOxB5wsABekpRt787AnNCe6ems7kcXOssobK27mrJkf0ubRgRymQqU2k4l6GWbl9isnCDglsk9Q=
Date: Tue, 9 Oct 2007 19:19:49 +0200
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Rob Landley <rob@landley.net>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, rdunlap@xenotime.net
Subject: Re: [PATCH] Stop docproc segfaulting when SRCTREE isn't set.
Message-ID: <20071009171949.GA11579@Ahmed>
References: <200710090125.19089.rob@landley.net> <20071009130315.GB4245@Ahmed> <20071009085500.e7be49a0.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071009085500.e7be49a0.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.11
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2007 at 08:55:00AM -0700, Randy Dunlap wrote:
> On Tue, 9 Oct 2007 15:03:15 +0200 Ahmed S. Darwish wrote:
> 
> > Hi Rob,
> > 
> > On Tue, Oct 09, 2007 at 01:25:18AM -0500, Rob Landley wrote:
> > [...]
> > >  	FILE * infile;
> > > +
> > > +	srctree = getenv("SRCTREE");
> > > +	if (!srctree) srctree = getcwd(NULL,0);
> > >  	if (argc != 3) {
> > >  		usage();
> > >  		exit(1);
> > 
> > $ man getcwd
> > 
> >  char *getcwd(char *buf, size_t size);
> >       
> >  As an extension to the POSIX.1 standard, Linux (libc4, libc5, glibc) getcwd() 
> >  allocates the buffer dynamically using malloc() if buf is NULL on call.
> > 
> > Shouldn't "srctree" be free()ed in case getenv("SRCTREE") failed ?
> 
> What is there to free() at that point?  If getenv() fails (i.e.,
> the env. variable is not found), it returns NULL.
> or do I need another cup of coffee?
>

I meant if getenv() failed, "srctree = getcwd(NULL, 0)" will let 
"srctree" point to a _ malloc()ed _ buffer representing PWD. 
As said in the manpage, this buffer needs to be free()ed after usage.
Right or I'm the one who needs that cup of coffee :) ?

Regards,

-- 
Ahmed S. Darwish
HomePage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com
