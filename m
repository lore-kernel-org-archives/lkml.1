Return-Path: <linux-kernel-owner+w=401wt.eu-S1753471AbYFRKru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471AbYFRKru (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 06:47:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752294AbYFRKrm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 06:47:42 -0400
Received: from viefep31-int.chello.at ([62.179.121.49]:65307 "EHLO
	viefep31-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbYFRKrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 06:47:42 -0400
Subject: Re: [sched-devel, patch-rfc] rework of "prioritize
	non-migratabletasks over migratable ones"
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Gregory Haskins <ghaskins@novell.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20080618103919.GH15255@elte.hu>
References: <1213138710.26530.51.camel@earth>
	 <1213174382.31518.69.camel@twins>
	 <b647ffbd0806110305p2be38608iadc1d2e91e3be57a@mail.gmail.com>
	 <48563FDB.BA47.005A.0@novell.com>
	 <b647ffbd0806161059q7048ea40id0f4235ab19d6ca0@mail.gmail.com>
	 <1213643862.16944.142.camel@twins> <48568CCC.BA47.005A.0@novell.com>
	 <20080618103919.GH15255@elte.hu>
Content-Type: text/plain
Date: Wed, 18 Jun 2008 12:47:44 +0200
Message-Id: <1213786064.16944.209.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-06-18 at 12:39 +0200, Ingo Molnar wrote:
> * Gregory Haskins <ghaskins@novell.com> wrote:
> 
> > >>> On Mon, Jun 16, 2008 at  3:17 PM, in message
> > <1213643862.16944.142.camel@twins>, Peter Zijlstra <a.p.zijlstra@chello.nl>
> > wrote: 
> > > On Mon, 2008-06-16 at 19:59 +0200, Dmitry Adamushko wrote:
> > > 
> > >> One way or another, we have different aritifacts (and mine have likely
> > >> more) but conceptually, both "violates" POSIX if a strict round-robin
> > >> scheduling is required.
> > > 
> > > http://www.opengroup.org/onlinepubs/009695399/functions/xsh_chap02_08.html#t
> > > ag_02_08_04_01
> > > 
> > > Is quite strict on what FIFO should do, and I know of two points where
> > > we deviate and should work to match.
> > 
> > Thanks for the link, Peter.  When you read that, its pretty clear that 
> > this whole concept violates the standard.  Its probably best to just 
> > revert the patch and be done with it.
> 
> no, there's no spec violation here - the spec is silent on SMP issues.
> 
> the spec should not be read to force a global runqueue for RT tasks. 
> That would be silly beyond imagination.

Sadly, some people do read it like that.

> so ... lets apply Dmitry's nice simplification, hm?

As long as it doesn't wreck the per RQ queue model and only affects the
SMP interaction that would be acceptable I guess.

