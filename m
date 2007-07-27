Return-Path: <linux-kernel-owner+w=401wt.eu-S937220AbXG0OxI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937220AbXG0OxI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 10:53:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933350AbXG0Ow4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 10:52:56 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:1386 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933595AbXG0Owz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 10:52:55 -0400
Date: Fri, 27 Jul 2007 18:52:35 +0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, devel@openvz.org
Subject: Re: [PATCH] Remove CTL_UNNUMBERED
Message-ID: <20070727145235.GC6924@localhost.sw.ru>
References: <20070726164518.GB16937@localhost.sw.ru> <m13azbulhf.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m13azbulhf.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2007 at 11:24:12AM -0600, Eric W. Biederman wrote:
> Alexey Dobriyan <adobriyan@sw.ru> writes:
> 
> > CTL_UNNUMBERED is unneeded, because it expands to
> >
> > 	.ctl_name = 0
> >
> > The same effect can be achieved by skipping .ctl_name initialization,
> > saving one line per sysctl.
> >
> > Update docs and headers telling people to not add CTL_ numbers and
> > giving example.
> >
> > This is probably all we can do to stop the flow of new CTL_ numbers,
> > because most of sysctls are copy-pasted. CTL_UNNUMBERED doesn't solve
> > this problem at all.
> >
> > Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
> 
> Nack.  Not unless you update the documentation and explanations
> properly.

They are left in place:

	Assigning binary sysctl numbers is an endless source of conflicts in
	sysctl.h, breaking of the user space ABI (because of those conflicts),
	and maintenance problems.  A complete pass through all of the sysctl
	users revealed multiple instances where the sysctl binary interface
	was broken and had gone undetected for years.

> The important part is that we stop assigning binary numbers.  You
> are removing part of the description of why we can not assign bianry
> numbers and how that is important.

You want me to rewrite that paragraph actually mentioning
CTL_UNNUMBERED?

> CTL_UNNUMBERED may be an irritant to you but as for actually using the
> code I have look and it is about 6 of 1 half dozen of the other.

Sorry, -EPARSE.

