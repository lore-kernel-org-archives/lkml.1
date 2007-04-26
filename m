Return-Path: <linux-kernel-owner+w=401wt.eu-S1751627AbXDZQqG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751627AbXDZQqG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 12:46:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752905AbXDZQqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 12:46:05 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:40367 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627AbXDZQqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 12:46:03 -0400
Date: Thu, 26 Apr 2007 09:44:27 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: Rene Herman <rene.herman@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Marcel Holtmann <marcel@holtmann.org>,
       Christoph Hellwig <hch@infradead.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: MODULE_MAINTAINER
Message-Id: <20070426094427.6f5bfc4c.randy.dunlap@oracle.com>
In-Reply-To: <20070426155205.GN3468@stusta.de>
References: <20070404170016.453d26f1@the-village.bc.nu>
	<4613D492.2070404@gmail.com>
	<462C7D74.60003@gmail.com>
	<1177327476.17026.75.camel@localhost.localdomain>
	<Pine.LNX.4.64.0704230748270.25463@localhost.localdomain>
	<462CA764.5080401@gmail.com>
	<20070425181856.42fcfeb4.akpm@linux-foundation.org>
	<463081E5.5010306@gmail.com>
	<20070426135426.GM3468@stusta.de>
	<20070426084143.1d973c71.randy.dunlap@oracle.com>
	<20070426155205.GN3468@stusta.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2007 17:52:06 +0200 Adrian Bunk wrote:

> On Thu, Apr 26, 2007 at 08:41:43AM -0700, Randy Dunlap wrote:
> > On Thu, 26 Apr 2007 15:54:26 +0200 Adrian Bunk wrote:
> > 
> > > On Thu, Apr 26, 2007 at 12:41:41PM +0200, Rene Herman wrote:
> > > > On 04/26/2007 03:18 AM, Andrew Morton wrote:
> > > >
> > > >> On Mon, 23 Apr 2007 14:32:36 +0200 Rene Herman <rene.herman@gmail.com>
> > > >> wrote:
> > > >>> Provide MODULE_MAINTAINER() as a convenient place to stick a name and
> > > >>> email address both for drivers having multiple (current and
> > > >>> non-current) authors and for when someone who wants to maintain a
> > > >>> driver isn't so much an author.
> > > >
> > > > [ snip ]
> > > >
> > > >> I'm not sure we want to do this - that's what ./MAINTAINERS is for and we
> > > >> end up having to maintain the same info in two places.
> > > >
> > > > joe@user:~$ less ./MAINTAINERS
> > > > ./MAINTAINERS: No such file or directory
> > > >
> > > > MAINTAINERS is a developers thing, not users, yet a maintainer is someone 
> > > > who other than by developers wants to be contacted by users of a particular 
> > > > driver. Right now, a module exports a set of name and email addresses 
> > > > through the MODULE_AUTHOR tag but given multiple current and non-current 
> > > > authors, completely or largely orphaned drivers (I have a lot of junk PC 
> > > > hardware so I come across those relatively often) and people who might be 
> > > > interested in taking care of a driver but who do not consider themselves an 
> > > > author for (upto now) having done a s/, struct pt_regs// on it, that tag 
> > > > only confuses the issue of whom to contact.
> > > >
> > > > And it in fact even does so when Joe does know about a MAINTAINERS file and 
> > > > does happen to have a kernel source tree lying around somewhere. With one 
> > > > set of addresses displayed prominently inside the sourcecode of the very 
> > > > driver and another one of in a MAINTAINERS file, the first one wins. Joe 
> > > > would have to be very new to Linux to trust something in the tree that's 
> > > > not actually compiled over something that is.
> > > >
> > > > As the first response in this thread Cristoph Hellwig stated that 
> > > > MODULE_AUTHOR serves no purpose other than what MODULE_MAINTAINER would be 
> > > > serving. Others agreed and Adrian Bunk suggested deleting MODULE_AUTHOR 
> > > > outright.
> > > >
> > > > That would actually also serve my purposes; if there's no MODULE_AUTHOR 
> > > > confusing the issue, I don't so much need a MODULE_MAINTAINER to fix it 
> > > > again. I believe having "modinfo" (optionally!) display a contact address 
> > > > for a driver might be a user advantage, but with all the wrong addresses 
> > > > gone, I don't really care deeply; MODULE_AUTHOR doesn't serve the purpose 
> > > > today and with it gone the user at least knows he needs to look elsewhere. 
> > > > MODULE_AUTHOR is also a credits issue but the information can be 
> > > > transferred to copyright headers. It would obviously also fix any possible 
> > > > maintenance issues.
> > > >
> > > > Alan Cox believes that having author information embedded in the module 
> > > > serves a legal purpose though and objects to removal.
> > 
> > Wouldn't a /* comment */ satisfy AUTHOR needs?
> > 
> > It gives deserved attribution and should serve legal purpose just as
> > well as a macro does (IANAL!).
> 
> Alan's opinion in [1] sounds reasonable (and I trust that he knows what 
> he is talking about).

OK, I see.

> > IMO we want MAINTAINER info in the macro and in modinfo,
> > so I'm for removing MODULE_AUTHOR and just having MAINTAINER.
> >...
> 
> I don't think we want to expose maintainership information to users at 
> all:
> - duplicates information in MAINTAINERS
> - maintainers sometimes disappear
> - the 3 year old kernel of your distribution would contain 3 year old
>   maintainership information
> 
> IMHO the default should be that users report problems with distribution 
> kernels to their distribution and problems with ftp.kernel.org kernels 
> to either linux-kernel or the kernel Bugzilla.

s/linux-kernel/the appropriate mailing list/ please :)

so looks to me like we maintain the status quo.

> > ~Randy
> 
> cu
> Adrian
> 
> [1] http://lkml.org/lkml/2007/4/4/260


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
