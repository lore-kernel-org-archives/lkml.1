Return-Path: <linux-kernel-owner+w=401wt.eu-S1761198AbXHFGzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761198AbXHFGzA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 02:55:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754011AbXHFGyx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 02:54:53 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:45018 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753818AbXHFGyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 02:54:52 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Michael Kerrisk <mtk-manpages@gmx.net>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
       Kirill Korotaev <dev@openvz.org>, Herbert Poetzl <herbert@13thfloor.at>,
       Andrey Savochkin <saw@sw.ru>, Adrian Bunk <bunk@stusta.de>,
       Cedric Le Goater <clg@fr.ibm.com>, Chris Wright <chrisw@sous-sol.org>,
       Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
       Andrew Morgan <agm@google.com>
Subject: Re: CLONE_NEWUSER documentation
References: <46B599C6.7040201@gmx.net>
	<m1643ukviw.fsf@ebiederm.dsl.xmission.com> <46B6C180.3020004@gmx.net>
Date: Mon, 06 Aug 2007 00:48:47 -0600
In-Reply-To: <46B6C180.3020004@gmx.net> (Michael Kerrisk's message of "Mon, 06
	Aug 2007 08:36:48 +0200")
Message-ID: <m11wehkvjk.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Kerrisk <mtk-manpages@gmx.net> writes:

>
> And again: is CLONE_NEWUSER (to be)implemented for unshare()?

They all should be.  Only the pid namespace (not yet merged) looks
like a problem for unshare.

> Thanks Eric.  I'm still not so clear though.  What is a user name space
> intended to be, and how is it to be used?
>
> Also, when will the implementation be complete?  If not by the 2.6.23 final
> release, it seems unfortunate to expose this flag to userspace, since
> further down the road, it will be difficult for userspace to tell whether
> the kernel below it really supports the flag or not.  Or am I missing
> something?

Currently the code depends on CONFIG_USER_NS it is CONFIG_EXPERIMENTAL
and defaulting to N.

So no one should be shipping a production with it enabled, hopefully
that is enough, to avoid problems.  I think the current implementation
is usable for some small subset of usable.

The basic idea is so that you have different mappings between uid and
gid values (i.e. /etc/passwd stuff) and struct user in the kernel.
Allowing the kernel to know two users with the same uid are distinct.

When you combined all of the namespaces (and when the are finished)
you have what is effective a chroot jail that looks like it has
the kernel all to itself despite other programs running.

Eric
