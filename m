Return-Path: <linux-kernel-owner+w=401wt.eu-S1762723AbYB1T4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762723AbYB1T4l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 14:56:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932379AbYB1TwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 14:52:06 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:51959 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932366AbYB1TwC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 14:52:02 -0500
Date: Thu, 28 Feb 2008 13:51:18 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Ian Kent <raven@themaw.net>, Andrew Morton <akpm@linux-foundation.org>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>,
       autofs mailing list <autofs@linux.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Pavel Emelyanov <xemul@openvz.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 3/4] autofs4 - track uid and gid of last mount requestor
Message-ID: <20080228195118.GA16634@sergelap.austin.ibm.com>
References: <Pine.LNX.4.64.0802261151400.8490@raven.themaw.net> <Pine.LNX.4.64.0802261208400.8490@raven.themaw.net> <20080227204546.72e16e8d.akpm@linux-foundation.org> <1204179747.3501.21.camel@raven.themaw.net> <20080227223734.caab0165.akpm@linux-foundation.org> <1204182500.3501.49.camel@raven.themaw.net> <20080227232339.af6e904a.akpm@linux-foundation.org> <1204185623.3501.84.camel@raven.themaw.net> <x494pbtxaup.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x494pbtxaup.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Jeff Moyer (jmoyer@redhat.com):
> Ian Kent <raven@themaw.net> writes:
> 
> > On Wed, 2008-02-27 at 23:23 -0800, Andrew Morton wrote:
> >> On Thu, 28 Feb 2008 16:08:20 +0900 Ian Kent <raven@themaw.net> wrote:
> >> > which includes the process uid and gid, and as part of
> >> > the lookup we set macros for several mount map substitution variables,
> >> > derived from the uid and gid of the process requesting the mount and
> >> > they can be used within autofs maps.
> >> 
> >> yeah, could be a problem.  Hopefully the namespace people can advise. 
> >> Perhaps we need a concept of an exportable-to-userspace namespace-id+uid,
> >> namespace-id+gid, namespace-id+pid, etc for this sort of thing.  It has
> >> come up before.  Recently, but I forget what the context was.
> >
> > I'm all ears to any feedback from others on this, please.
> 
> I think there is some confusion surrounding what the UID and GID are
> used for in this context.  I'll try to explain it as best I can.
> 
> When the automount daemon parses a map entry, it will do some amount of
> variable substitution.  So, let's say you're running on an i386 box, and
> you want to mount a library directory from a server.  You might have a
> map entry that looks like this:
> 
> lib	server:/export/$ARCH/lib
> 
> In this case, the automount daemon will replace $ARCH with i386, and
> will try the following mount command:
> 
> mount -t nfs server:/export/i386/lib /automountdir/lib
> 
> There are cases where it would be helpful to use the requesting
> process's UID in such a variable substitution.  Consider the case of a
> CIFS share, where the automount daemon runs as user root, but we want to
> mount the share using the credentials of the requesting user.  In this
> case, the UID and GID can be helpful in formatting the mount options for
> mounting the share.
> 
> So, the UID and GID are used only for map substitutions.  Now, having
> said all of that, I'll have to look more closely at why we even need to
> keep track of it, given that it only needs to be used when performing
> the lookup, and at that time we have information on the requesting UID
> and GID.

Thanks Jeff.  If that's the case then user namespaces don't affect this
at all.

(Still trying to follow the rest of the thread bc i definately feel like
I'm missing something.  I swear I understood autofs 10+ years ago :)

thanks,
-serge
