Return-Path: <linux-kernel-owner+w=401wt.eu-S1764981AbXHFNJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764981AbXHFNJS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 09:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763857AbXHFNJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 09:09:09 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:51480 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754274AbXHFNJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 09:09:08 -0400
Date: Mon, 6 Aug 2007 08:09:04 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Michael Kerrisk <mtk-manpages@gmx.net>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>, Kirill Korotaev <dev@openvz.org>,
       Herbert Poetzl <herbert@13thfloor.at>, Andrey Savochkin <saw@sw.ru>,
       Adrian Bunk <bunk@stusta.de>, Cedric Le Goater <clg@fr.ibm.com>,
       Chris Wright <chrisw@sous-sol.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>, Andrew Morgan <agm@google.com>
Subject: Re: CLONE_NEWUSER documentation
Message-ID: <20070806130904.GC23642@sergelap.austin.ibm.com>
References: <46B599C6.7040201@gmx.net> <m1643ukviw.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1643ukviw.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> Michael Kerrisk <mtk-manpages@gmx.net> writes:
> 
> > Hello Serge,
> >
> > In 2.6.23-rc, your patch to add support for CLONE_NEWUSER is included.  Is
> > there there some for-userland-programmers documentation of this flag
> > somewhere?  Would you be able to send some documentation to me (ideally as
> > a patch to the clone.2 man page, but otherwise some plain text will do).
> >
> > If this flag is also supported for unshare(), then could you please send me
> > a patch/text for that too?
> 
> Currently this namespace is a work in progress marked with CONFIG_EXPERIMENTAL
> because it is very much still experimental and under development.
> 
> There may be other omissions but the one I am most aware of is that
> the in kernel user and group equality comparisons have not become been
> transformed from the form uid1 == uid2 to user_namespace1 == user_namespace2 &&
> uid1 == uid2.

I think the two main omissions are that one, and the fact that there is
no concept of a capability mask or per-namespace/cross-namespace
capabilities.  What is implemented is separate accounting for the same
uid in different namespaces.

Until the shortcomings are addressed, depending on one's use case, one
may want to use selinux to control access across user namespaces.

> Until that happens that user namespace remains incomplete and not very
> useful.  So the advice to users for now that unless they want to help
> finish this up do not use.

thanks,
-serge
