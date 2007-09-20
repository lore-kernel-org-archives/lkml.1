Return-Path: <linux-kernel-owner+w=401wt.eu-S1757394AbXITPxi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757394AbXITPxi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 11:53:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756268AbXITPxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 11:53:31 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:4809 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755004AbXITPxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 11:53:31 -0400
Date: Thu, 20 Sep 2007 16:53:02 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Satyam Sharma <satyam@infradead.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: error from checkpatch.pl version 0.10
Message-ID: <20070920155302.GA29224@shadowen.org>
References: <200709202156.GFC11109.HOFQLOVOFFtSJM@I-love.SAKURA.ne.jp> <alpine.LFD.0.999.0709201916400.17093@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0709201916400.17093@enigma.security.iitk.ac.in>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SPF-Guess: neutral
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2007 at 07:19:59PM +0530, Satyam Sharma wrote:
> 
> 
> On Thu, 20 Sep 2007, Tetsuo Handa wrote:
> > 
> > I checked my patch using checkpatch.pl version 0.10
> > and I got the following error.
> > 
> >   ERROR: need consistent spacing around '*' (ctx:WxV)
> >   #2334: FILE: security/tomoyo/common.c:2306:
> >   +static unsigned int tmy_poll(struct file *file, poll_table *wait)
> >                                                               ^
> 
> Looks like a checkpatch.pl bug to me -- that was nothing to warn about.

Hmm yeah this is a false positive, its hard to detect correctly.  Some
fool decided to use * as both a unary and binary operator and made life
very hard indeed.  Most kernel defined types end _t to aid recognition.
This one does no.  I may special case it.  Either way ignore its
moaning!

> > What action should I take?
> > Ignore this error because "poll_table" is used everywhere?
> > Replace "poll_table" with "struct poll_table_struct" according to
> > definition of "poll_table"?
> 
> Yeah, this would be better to do anyway (and rename poll_table_struct
> to just poll_table).
> 
> >   typedef struct poll_table_struct {
> >           poll_queue_proc qproc;
> >   } poll_table;
> 
> So:
> 
> 	struct poll_table {
> 		poll_queue_proc qproc;
> 	};
> 
> In general the kernel's codingstyle consensus is to avoid adding typedefs.

-apw
