Return-Path: <linux-kernel-owner+w=401wt.eu-S1754452AbXJWQcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754452AbXJWQcd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 12:32:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753306AbXJWQcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 12:32:25 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52176 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753043AbXJWQcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 12:32:25 -0400
Date: Tue, 23 Oct 2007 09:32:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Cc: Anas Nashif <nashif@linux.intel.com>, linux-kernel@vger.kernel.org,
       Marek Dabek <marek.dabek@intel.com>
Subject: Re: [PATCH] Intel Manageability Engine Interface driver
Message-Id: <20071023093216.06d8f415.akpm@linux-foundation.org>
In-Reply-To: <20071023150429.GK4003@csclub.uwaterloo.ca>
References: <471CDC5E.4010300@linux.intel.com>
	<20071022114001.40470c15.akpm@linux-foundation.org>
	<20071023150429.GK4003@csclub.uwaterloo.ca>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Oct 2007 11:04:29 -0400 lsorense@csclub.uwaterloo.ca (Lennart Sorensen) wrote:

> On Mon, Oct 22, 2007 at 11:40:01AM -0700, Andrew Morton wrote:
> > - Here:
> > 
> > +		if (0 == memcmp(&heci_wd_guid,
> > 
> >   we boringly prefer "if (foo == 0)" rather than "if (0 == foo)".  (lots
> >   of places).
> 
> But 0 == blah is safer.  If you accidentally do 0 = blah the compiler
> will tell you.

If you do 'if (blah = 0)' then compiler will tell you too.  To all intents
and purposes this invalidates the reasons for doing `if (0 == blah)'.

>  Just because people have always done it the other way
> around doesn't make it the right way to do it.  I have noticed many
> people have started to realize this in the last few years.
> 
> It is also much clearer that you are comparing against a constant and
> not doing an assignment when the constant comes before the variable.
> 
> I think to encourage people doing it the less safe way is just silly.

It isn't less safe.

> Some places in the kernel that already uses the constant first are:

It impacts readability.  All the aio code was implemented that way for a
few years and it drove everyone so batty that we undid it.
