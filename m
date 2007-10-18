Return-Path: <linux-kernel-owner+w=401wt.eu-S1765634AbXJRD0F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765634AbXJRD0F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 23:26:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761626AbXJRDZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 23:25:53 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49368 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761388AbXJRDZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 23:25:52 -0400
Date: Wed, 17 Oct 2007 20:20:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, sds@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, morgan@kernel.org,
       chrisw@sous-sol.org, linux-kernel@vger.kernel.org, kaigai@kaigai.gr.jp,
       casey@schaufler-ca.com
Subject: Re: [RFC] [PATCH 2/2] capabilities: implement 64-bit capabilities
Message-Id: <20071017202014.6738cbb7.akpm@linux-foundation.org>
In-Reply-To: <20071018025920.GA5067@vino.hallyn.com>
References: <20071016022730.GA8925@sergelap.austin.ibm.com>
	<20071016023100.GA10698@sergelap.austin.ibm.com>
	<1192544299.8702.78.camel@moss-spartans.epoch.ncsc.mil>
	<20071016214159.GB13294@sergelap.austin.ibm.com>
	<20071017180002.33fe4986.akpm@linux-foundation.org>
	<20071018025920.GA5067@vino.hallyn.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Oct 2007 21:59:20 -0500 "Serge E. Hallyn" <serge@hallyn.com> wrote:

> Quoting Andrew Morton (akpm@linux-foundation.org):
> > On Tue, 16 Oct 2007 16:41:59 -0500
> > "Serge E. Hallyn" <serue@us.ibm.com> wrote:
> > 
> > > To properly test this the libcap code will need to be updated first,
> > > which I'm looking at now...
> > 
> > This seems fairly significant.  I asusme that this patch won't break
> > presently-deployed libcap?
> 
> It will break libcap.

yikes, dropped!

>  And I'm not sure of the right way to address it.
> So I was hoping to hear some ideas from Andrew Morgan, Chris Wright, and
> Kaigai.
> 
> We can introduce new capget64() and capset64() calls, and have
> capget() return -EINVAL or -EAGAIN if a high bit would be needed to
> accurately get the task's capabilities.
> 
> Or we can require a new libcap, since capget and capset aren't
> required for most day-to-day function anyway.
> 
> I guess now that I've written this out, it seems pretty clear
> that capget64() and capget64() are the way to go.  Any objections?

Sounds sane.  New syscalls are cheap and it's clear separation.
