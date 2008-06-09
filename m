Return-Path: <linux-kernel-owner+w=401wt.eu-S1753061AbYFIRSM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061AbYFIRSM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 13:18:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756603AbYFIRRn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 13:17:43 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:48148 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756238AbYFIRRm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 13:17:42 -0400
Date: Mon, 9 Jun 2008 12:17:41 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrew Morgan <morgan@kernel.org>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [ linus-git ] prctl(PR_SET_KEEPCAPS, ...) is broken for some
	configs, e.g. CONFIG_SECURITY_SELINUX
Message-ID: <20080609171741.GA13403@us.ibm.com>
References: <1212932321.4675.9.camel@earth> <484BF662.9070100@kernel.org> <20080608110630.08a45cc6.akpm@linux-foundation.org> <484C5E84.2020307@kernel.org> <20080608163926.56f1be3d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080608163926.56f1be3d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andrew Morton (akpm@linux-foundation.org):
> On Sun, 08 Jun 2008 15:34:44 -0700 Andrew Morgan <morgan@kernel.org> wrote:
> 
> > | On Sun, 08 Jun 2008 08:10:26 -0700 Andrew Morgan <morgan@kernel.org>
> > wrote:
> > |
> > |> Nacked-by: Andrew G. Morgan <morgan@kernel.org>
> > |>
> > |> In a configuration in which you are not using capabilities, what is the
> > |> "keep capabilities" operation supposed to do? Lie to you?
> > |>
> > |> http://bugzilla.kernel.org/show_bug.cgi?id=10748
> > |
> > | I totally agree with comment 11 there. Quite a number of people have
> > already
> > | hit this and more surely will.  How can we help them (and hence us)?
> >
> > What do people think about comment #8 from Stephen Smalley?:
> > 
> > The dummy module is generally in the untenable position of having to lie
> > to userspace or break the existing capability-related system call
> > interface.  It should just go away, and make capability the default
> > module (w/ stubs for the rest of the LSM hooks as with dummy).  Then
> > CONFIG_SECURITY=n will yield the same result as CONFIG_SECURITY=y w/o
> > any further options.
> 
> (removed pgp crap, undid top-posting.  Your emails are very hard to reply to)
> 
> It's a fine comment, but I am not knowledgeable enough in this area to
> say whether it's a desirable thing to do for 2.6.26.
> 
> I fear that nothing will happen, and we'll end up wasting a lot of
> peoples' time sending hey-why-did-my-dhcp-break reports.

If we decide to get rid of dummy long-term, then it's far less
distasteful to have it lie and claim the keepcaps worked in the
meantime.

So for 2.6.26 we could have dummy lie, then plan to make capabilities
the default for 2.6.27?

-serge
