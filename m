Return-Path: <linux-kernel-owner+w=401wt.eu-S1753548AbYCISgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548AbYCISgy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 14:36:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751659AbYCISgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 14:36:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50231 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751371AbYCISgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 14:36:46 -0400
Date: Sun, 9 Mar 2008 11:36:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Dave Young" <hidave.darkstar@gmail.com>,
       "Johannes Weiner" <hannes@saeurebad.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] add time_now_after and other macros which compare
 with jiffies
Message-Id: <20080309113601.b8552a79.akpm@linux-foundation.org>
In-Reply-To: <20080309095802.70d91c7b@core>
References: <200803080735.06984.hidave.darkstar@gmail.com>
	<877igd6vqn.fsf@saeurebad.de>
	<a8e1da0803081654l50fdda44jbbed1d1ed2caf9ae@mail.gmail.com>
	<20080309095802.70d91c7b@core>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Mar 2008 09:58:02 +0000 Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > >  > +/* time_now_before_eq(a) return true if now (jiffies) is before or equal to a */
> > >  > +#define time_now_before_eq(a) time_before_eq(jiffies, a)
> > >
> > >  How about even more obvious names like time_is_past(), time_is_future(),
> > >  ...?
> > 
> > Thanks for comment.
> > 
> > Then how do we name the _eq version?  IMHO, the time_now_* is enough.
> 
> Why do you even need them. I don't see the point of *any* of these extra
> macros as they simply obfuscate code and hide what is actually going on.

Two reasons:

a) the existing macros are (I believe) a right royal pita.  It's very
   hard to remember which order the args are supposed to be in.

   So each time I see a time_foo() when reviewing a patch I have to go
   off and re-read the implementation then have a big think to check that
   they got it right (a sure sign of a poor interface, no)?

   And I'm not the only one - people get this wrong fairly regularly.

b) around 90% of the usages of time_after() are to compare against jiffies!

The macros which Dave is developing aren't just less-error-prone,
easier-to-review transformations - they offer higher-level functionality.
Because time_after() is just a basic comparison operation, whereas
time_now_before() is an *application* of that operation.

Trust me on this - they will lead to easier-to-review code and less bugs.

> The initial macros were added because of the type safety and correct
> comparison rules being complex. They have a purpose.

They are hard to use and hard to review.

> Even if you want these you can use !time_future() if you don't want the
> _eq variants. Generally speaking drivers should be using timers not
> polled loops, and most of our loops comparing with jiffies want removing.

