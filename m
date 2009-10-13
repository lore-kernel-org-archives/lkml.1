Return-Path: <linux-kernel-owner+w=401wt.eu-S933894AbZJMQJO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933894AbZJMQJO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 12:09:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759741AbZJMQJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 12:09:14 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:47260 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753401AbZJMQJN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 12:09:13 -0400
Date: Tue, 13 Oct 2009 10:24:53 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Oren Laadan <orenl@cs.columbia.edu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@osdl.org>,
       torvalds@linux-foundation.org, mikew@google.com, mingo@elte.hu,
       hpa@zytor.com, Nathan Lynch <nathanl@austin.ibm.com>, arnd@arndb.de,
       peterz@infradead.org, Louis.Rilling@kerlabs.com, roland@redhat.com,
       kosaki.motohiro@jp.fujitsu.com, randy.dunlap@oracle.com,
       linux-api@vger.kernel.org,
       Containers <containers@lists.linux-foundation.org>, sukadev@us.ibm.com
Subject: Re: [RFC][v8][PATCH 3/10]: Make pid_max a pid_ns property
Message-ID: <20091013152453.GA9994@us.ibm.com>
References: <20091013044925.GA28181@us.ibm.com> <20091013045041.GC28435@us.ibm.com> <4AD47C1F.7040703@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AD47C1F.7040703@openvz.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Pavel Emelyanov (xemul@openvz.org):
> Sukadev Bhattiprolu wrote:
> > 
> > From: Serge Hallyn <serue@us.ibm.com>
> > Subject: [RFC][v8][PATCH 3/10]: Make pid_max a pid_ns property
> > 
> > Remove the pid_max global, and make it a property of the
> > pid_namespace.  When a pid_ns is created, it inherits
> > the parent's pid_ns.
> > 
> > Fixing up sysctl (trivial akin to ipc version, but
> > potentially tedious to get right for all CONFIG*
> > combinations) is left for later.
> > 
> > Changelog[v2]:
> > 	- Port to newer kernel
> > 	- Make pid_max a local variable in alloc_pidmap() to simplify code/patch
> > 
> > Signed-off-by: Serge Hallyn <serue@us.ibm.com>
> > Signed-off-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
> 
> Not that I'm about to slow down or block the process, but...

This patch isn't a core part of the clone_with_pid functionality,
just something Eric has asked for.  So I don't object to dropping
it.  But I disagree with Alexey's claim that this isn't a namespace
property.  It should be.

> frankly I don't see the reason for doing so. Why should we?
> Especially taking into account, that we essentially cannot
> change thin in the namespace level 3 and deeper?

What do you mean by that?  With this patchset we're not, it's
true, but we trivially can - even now, userspace can simply not
give the container CAP_SYS_ADMIN or write access to the sysctl
so they can't do any more CLONE_NEWPIDS or change the sysctl.

-serge
