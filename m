Return-Path: <linux-kernel-owner+w=401wt.eu-S1763423AbYBWBNl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763423AbYBWBNl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 20:13:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752266AbYBWBNd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 20:13:33 -0500
Received: from yoi5.greathalifaxhome.com ([66.180.172.116]:43205 "HELO
	vps1.tull.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with SMTP
	id S1750985AbYBWBNc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 20:13:32 -0500
X-Spam-Check-By: mail.local.tull.net
Date: Sat, 23 Feb 2008 12:12:58 +1100
From: Nick Andrew <nick@nick-andrew.net>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org,
       Pavel Emelyanov <xemul@openvz.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Paul Menage <menage@google.com>,
       Paul Jackson <pj@sgi.com>, Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Subject: Re: [PATCH 2.6.25-rc2 3/9] Kconfig: Improve init/Kconfig help	descriptions - NAMESPACES
Message-ID: <20080223011258.GH2169@tull.net>
References: <20080219140609.GA26619@tull.net> <200802220010.m1M0Auqn024414@e5.ny.us.ibm.com> <20080222221412.GA12383@sergelap.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080222221412.GA12383@sergelap.austin.ibm.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2008 at 04:14:12PM -0600, Serge E. Hallyn wrote:
> Quoting Nick Andrew (nick@nick-andrew.net):
> >  config UTS_NS
> >  	bool "UTS namespace"
> >  	depends on NAMESPACES
> >  	help
> > -	  In this namespace tasks see different info provided with the
> > -	  uname() system call
> > +	  Enable support for multiple UTS system attributes.
> > +
> > +	  Each UTS namespace provides an individual view of the
> > +	  information returned by the uname() system call including
> > +	  hostname, kernel version and domain name.
> > +
> > +	  This is used by container systems (e.g. vservers) so that
> > +	  each container has its own hostname and other attributes.
> > +	  Tasks in the container are placed in the UTS namespace
> > +	  corresponding to the container.
> 
> this paragraph reads a little weird...  really what happens is that
> each forked task is in the same UTS namespace as its parent, unless
> it was cloned with CLONE_NEWUTS or has done unshare(CLONE_NEWUTS),
> in which case it receives a copy.

You mean only the third paragraph, right? I hope the other two are
accurate.

I'm trying to describe how the feature is used by container systems
and my description is obviously inaccurate. There are subtle semantic
differences between the way the different namespaces work, which you've
pointed out. I think mentioning CLONE_NEWUTS or other flags is too
technical for help descriptions.

For UTS_NS and IPC_NS I think I could remove that paragraph because
the end user hint "Answer Y if you will be using a container system"
remains. For USER_NS and PID_NS however, these features are tagged
EXPERIMENTAL so the hint is "If unsure, say N" and I think I need
to at least mention the use in container systems or find some better
clarifying description which doesn't get too technical.

> > +	  This is used by container systems (e.g. vservers).
> > +	  Tasks in the container are placed in the IPC namespace
> > +	  corresponding to the container.
> 
> Same as with UTS, except that upon CLONE_NEWIPC the task receives a
> blank new ipc namespace, not a copy of the original.

Per above my response is to remove the paragraph.

> >  config PID_NS
> > [...]
> >  	default n
> >  	depends on NAMESPACES && EXPERIMENTAL
> >  	help
> > -	  Suport process id namespaces.  This allows having multiple
> > -	  process with the same pid as long as they are in different
> > -	  pid namespaces.  This is a building block of containers.
> > +	  Enable experimental support for hierarchical process id namespaces.
> > 
> > -	  Unless you want to work with an experimental feature
> > -	  say N here.
> > +	  This is a function used by container-based virtualisation
> > +	  systems (e.g. vservers).  Each process will have a distinct
> > +	  Process ID in each PID namespace which the process is in.
> > +	  Processes in the container are placed in the PID namespace
> > +	  corresponding to the container, and cannot see or affect
> > +	  processes in any parent PID namespace.
> 
> A cloned process inherits the pid namespace hierarchy from its
> parent.  If it was cloned with CLONE_NEWPID, the hierarchy is
> topped with one additional newly created pid namespace.  This
> is the only pid namespace in which the new process will be able
> to see processes, while it will be visible in all namespaces in
> its pidns hierarchy.

Yes, I understand that. Would you agree that your problem is with the
wording "Processes in the container are placed in the PID namespace
corresponding to the container"? And that this is the part that needs
to be fixed?

... todo = revisit these descriptions soon, not today though

Nick.
-- 
PGP Key ID = 0x418487E7                      http://www.nick-andrew.net/
PGP Key fingerprint = B3ED 6894 8E49 1770 C24A  67E3 6266 6EB9 4184 87E7
