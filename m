Return-Path: <linux-kernel-owner+w=401wt.eu-S1759812AbYJINha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759812AbYJINha (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 09:37:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758694AbYJINhW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 09:37:22 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:32773 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758484AbYJINhV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 09:37:21 -0400
Subject: Re: [RFC v6][PATCH 0/9] Kernel based checkpoint/restart
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Oren Laadan <orenl@cs.columbia.edu>, jeremy@goop.org, arnd@arndb.de,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Alexander Viro <viro@zeniv.linux.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20081009131701.GA21112@elte.hu>
References: <1223461197-11513-1-git-send-email-orenl@cs.columbia.edu>
	 <20081009124658.GE2952@elte.hu> <1223557122.11830.14.camel@nimitz>
	 <20081009131701.GA21112@elte.hu>
Content-Type: text/plain
Date: Thu, 09 Oct 2008 06:34:06 -0700
Message-Id: <1223559246.11830.23.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-09 at 15:17 +0200, Ingo Molnar wrote:
> * Dave Hansen <dave@linux.vnet.ibm.com> wrote
> > On Thu, 2008-10-09 at 14:46 +0200, Ingo Molnar wrote:
> > > i'm wondering about the following productization aspect: it would be 
> > > very useful to applications and users if they knew whether it is safe to 
> > > checkpoint a given app. I.e. whether that app has any state that cannot 
> > > be stored/restored yet.
> > 
> > Absolutely!
> > 
> > My first inclination was to do this at checkpoint time: detect and 
> > tell users why an app or container can't actually be checkpointed.  
> > But, if I get you right, you're talking about something that happens 
> > more during the runtime of the app than during the checkpoint.  This 
> > sounds like a wonderful approach to me, and much better than what I 
> > was thinking of.
> > 
> > What kind of mechanism do you have in mind?
> > 
> > int sys_remap_file_pages(...)
> > {
> >       ...
> >       oh_crap_we_dont_support_this_yet(current);
> > }
> > 
> > Then the oh_crap..() function sets a task flag or something?
> 
> yeah, something like that. A key aspect of it is that is has to be very 
> low-key on the source code level - we dont want to sprinkle the kernel 
> with anything ugly. Perhaps something pretty explicit:
> 
>   current->flags |= PF_NOCR;

Am I miscounting, or are we out of these suckers on 32-bit platforms?

> as we do the same thing today for certain facilities:
> 
>   current->flags |= PF_NOFREEZE;
> 
> you probably want to hide it behind:
> 
>   set_current_nocr();

Yeah, that all looks reasonable.  Letting this be a dynamic thing where
you can move back and forth between the two states would make a lot of
sense too.  But, for now, I guess it can be a one-way trip.

I'll cook something up real fast.

-- Dave

