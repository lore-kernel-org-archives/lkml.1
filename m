Return-Path: <linux-kernel-owner+w=401wt.eu-S965194AbXCPOdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965194AbXCPOdW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 10:33:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965277AbXCPOdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 10:33:22 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:44274 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965194AbXCPOdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 10:33:21 -0400
X-Sasl-enc: ZNAFn/C/tWgl2TQNFIki8cayo8hlAJsKJfQz8FdOd0cV 1174055600
Subject: Re: [PATCH 2/2] Replace pid_t in autofs with struct pid reference
From: Ian Kent <raven@themaw.net>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: sukadev@us.ibm.com, Andrew Morton <akpm@osdl.org>,
       Cedric Le Goater <clg@fr.ibm.com>, Dave Hansen <haveblue@us.ibm.com>,
       Serge Hallyn <serue@us.ibm.com>, Herbert Poetzl <herbert@13thfloor.at>,
       containers@lists.osdl.org, linux-kernel@vger.kernel.org
In-Reply-To: <m1ird1o243.fsf@ebiederm.dsl.xmission.com>
References: <20070313045100.GC8993@us.ibm.com>
	 <Pine.LNX.4.64.0703161300520.4188@raven.themaw.net>
	 <m1ird1o243.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain
Date: Fri, 16 Mar 2007 23:31:07 +0900
Message-Id: <1174055467.3397.17.camel@raven.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-32.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-16 at 05:32 -0600, Eric W. Biederman wrote:
> Ian Kent <raven@themaw.net> writes:
> 
> > On Mon, 12 Mar 2007, sukadev@us.ibm.com wrote:
> >
> >> 
> >> From: Sukadev Bhattiprolu <sukadev@us.ibm.com>
> >> Subject: [PATCH 2/2] Replace pid_t in autofs with struct pid reference.
> >> 
> >> Make autofs container-friendly by caching struct pid reference rather
> >> than pid_t and using pid_nr() to retreive a task's pid_t.
> >> 
> >> ChangeLog:
> >> 	- Fix Eric Biederman's comments - Use find_get_pid() to hold a
> >> 	  reference to oz_pgrp and release while unmounting; separate out
> >> 	  changes to autofs and autofs4.
> >
> > What changes to autofs4?
> > Do you intend this change to be made for autofs4 also?
> > Perhaps you expected me to do them, in which case you probably should 
> > ask me to do the patch.
> 
> The review history goes something like this.
> - That's a big patch why are you touching autofs and autofs4 at the
>   same time?
> <split>
> - Hmm.  That change in the autofs4 patch looks fishy.
> <patch postponed until the issue was addressed>
> 
> autofs4 uses pids more extensively than autofs and so the change is
> correspondingly larger.
> 
> If you would like to look at what it would take to get autofs4 to only
> store values as struct pid * instead of storing pid_t that would be great.
> But for the most part I this is a massive global change that those of us
> pushing it are responsible for changing as fixing up as much of the code
> as we can, as is usual kernel practice.

How about you send over the autofs4 bit and I'll have a look (the autofs
patch looked fine). That would save me a bit of time and if there are
any changes needed I can send an updated patch for you guys to review. I
don't think autofs4 uses pids differently, in principle, than autofs so
it "should" be straight forward.

Ian


