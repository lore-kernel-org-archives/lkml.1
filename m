Return-Path: <linux-kernel-owner+w=401wt.eu-S1759005AbXF3Qc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759005AbXF3Qc3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 12:32:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758728AbXF3QcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 12:32:19 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52818 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758704AbXF3QcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 12:32:17 -0400
Date: Sat, 30 Jun 2007 09:32:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dan Aloni <da-x@monatomic.org>
Cc: "Kok, Auke" <auke-jan.h.kok@intel.com>,
       Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] automatic CC generation for patch submission
Message-Id: <20070630093205.c6ab33af.akpm@linux-foundation.org>
In-Reply-To: <20070630104752.GA26138@localdomain>
References: <20070630023451.GA21593@localdomain>
	<4685C549.3020602@intel.com>
	<20070630025425.59cbc299.akpm@linux-foundation.org>
	<20070630104752.GA26138@localdomain>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Jun 2007 13:47:52 +0300 Dan Aloni <da-x@monatomic.org> wrote:

> On Sat, Jun 30, 2007 at 02:54:25AM -0700, Andrew Morton wrote:
> > On Fri, 29 Jun 2007 19:51:53 -0700 "Kok, Auke" <auke-jan.h.kok@intel.com> wrote:
> > 
> > > > Some extensions to the popular E-Mail clients might be needed 
> > > > here. Also, a bot reading LKML would automatically send links 
> > > > about posted patches to the other mailing lists whenever 
> > > > someone forgets to add a CC.
> > > > 
> > > > Any comments?
> > > 
> > > an easier way to implement this is to add an extra field in the MAINTAINERS 
> > > file, something like below. All the contact info would stay the same, closely 
> > > where applicable and it would allow you to also specify specific files as well.
> > 
> > We already have that information in git.  Parse the git changelogs of the
> > affected files, find out who works on them.
> 
> I think it's quite complex to make a reliable inference of maintainership 
> information from git.

Clever people will work it out.

> Given a set of historical modifiers of a file, 
> would you take the most common commiter(s), or the most common 
> _recent_ commiter(s), or what? It's a bit fuzzy.

All the above?  Multiply frequency by recency, pick the top five?

Doesn't matter much: the cost of picking too many is high.

I shudder at the thought of manually maintaining anything like this.

> Moreover, it is slow in comparison and assumes the availability of 
> local .git db, which wouldn't be the case for some porition of patch 
> submitters.

a) precalculate the tables once per week

b) the whole thing wouldn't succeed if it requires software at
   patch-submitter's site.  It'd need to run at vger.

