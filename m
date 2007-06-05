Return-Path: <linux-kernel-owner+w=401wt.eu-S1763223AbXFENRQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763223AbXFENRQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 09:17:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757734AbXFENRD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 09:17:03 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:50275 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756484AbXFENRB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 09:17:01 -0400
Date: Tue, 5 Jun 2007 08:16:55 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Pavel Emelianov <xemul@openvz.org>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, menage@google.com,
       Andrew Morton <akpm@linux-foundation.org>, dev@sw.ru, vatsa@in.ibm.com,
       ebiederm@xmission.com, svaidy@linux.vnet.ibm.com, balbir@in.ibm.com,
       pj@sgi.com, cpw@sgi.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org,
       mbligh@google.com, rohitseth@google.com, devel@openvz.org
Subject: Re: [PATCH 1/1] containers: implement nsproxy containers subsystem
Message-ID: <20070605131655.GA31663@sergelap.austin.ibm.com>
References: <20070604185034.GA17970@sergelap.austin.ibm.com> <4665346F.20200@openvz.org> <20070605121358.GB22230@sergelap.austin.ibm.com> <46656051.2060207@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46656051.2060207@openvz.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Pavel Emelianov (xemul@openvz.org):
> Serge E. Hallyn wrote:
> > Quoting Pavel Emelianov (xemul@openvz.org):
> >> Serge E. Hallyn wrote:
> >>> >From 190ea72d213393dd1440643b2b87b5b2128dff87 Mon Sep 17 00:00:00 2001
> >>> From: Serge E. Hallyn <serue@us.ibm.com>
> >>> Date: Mon, 4 Jun 2007 14:18:52 -0400
> >>> Subject: [PATCH 1/1] containers: implement nsproxy containers subsystem
> >>>
> >>> When a task enters a new namespace via a clone() or unshare(), a new
> >>> container is created and the task moves into it.  This enables
> >> I have a design question.
> >>
> >> How the child that has a new namespace guesses what id
> >> this namespace has in containers?
> > 
> > parse /proc/$$/container
> 
> Ok.
> 
> > So more likely the parent would have to grab the cloned pid of the
> > child, parse /proc/$$/container, then rename the container.
> 
> Child can happen to die before this and we'll have an orphaned
> container. I mean, it will be deletable, but its name will be unknown.

Can we address that with a release_agent?

Or, the program which did the unshare() (or the fn which was cloned())
can print out it's /proc/getpid()/container before it (optionally resets
stdout and) executes the actual program to be run in the container.

> Maybe its better to get the containers id from the pid of new task?

Hmm, that seems reasonable.  In fact I like it.

Good idea, thanks.  I think I'll go ahead and implement that.

-serge
