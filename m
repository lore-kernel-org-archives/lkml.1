Return-Path: <linux-kernel-owner+w=401wt.eu-S1754533AbZKDEzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533AbZKDEzq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 23:55:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752756AbZKDEzp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 23:55:45 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:34379 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbZKDEzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 23:55:45 -0500
Date: Tue, 3 Nov 2009 22:55:47 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-fsdevel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
       Benjamin LaHaise <bcrl@lhnet.ca>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 04/13] sysfs: Simplify sysfs_chmod_file semantics
Message-ID: <20091104045547.GA774@us.ibm.com>
References: <m13a4vbz8r.fsf@fess.ebiederm.org> <1257249429-12384-4-git-send-email-ebiederm@xmission.com> <20091104024332.GA27639@us.ibm.com> <m17hu7ez0v.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m17hu7ez0v.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> "Serge E. Hallyn" <serue@us.ibm.com> writes:
> 
> > Quoting Eric W. Biederman (ebiederm@xmission.com):
> >> From: Eric W. Biederman <ebiederm@xmission.com>
> >> 
> >> Currently every caller of sysfs_chmod_file happens at either
> >> file creation time to set a non-default mode or in response
> >> to a specific user requested space change in policy.  Making
> >> timestamps of when the chmod happens and notification of
> >> a file changing mode uninteresting.
> >
> > But these changes can occur by togging values in sysfs files
> > (i.e. f71805f.c), right?  Is this (specifically not doing inotify)
> > definately uncontroversial?
> 
> The fs_notify_change was not introduced to deliberately support
> a feature but as a side effect of other cleanups.  So there
> is no indication that anyone cares about inotify support.
> 
> > I can't exactly picture an admin sitting there watching
> > nautilus for a sysfs file to become writeable, but could
> > imagine some site's automation getting hung...  Or am I way
> > off base?
> 
> I would be stunned if the shell script in the automation that writes
> to a sysfs file to make things writeable doesn't on it's next line
> kick off whatever needs it to be writable.
> 
> With no benefit to using inotify and with only a handful of sysfs
> files affected I don't expect this change to break anything in
> userspace and I have been happily running with it for a year or so on
> all of our machines at work with no one problems.
> 
> The reason I am making the change is that the goal of this patchset is
> to get sysfs to act like any other distributed filesystem in linux,
> and to use the same interfaces in roughly the same ways as other
> distributed filesystems.  Unfortunately there is not a good interface
> for distributed filesystems to support inotify or I would use it.
> 
> Eric

Ok - I personally agree, but I know there are admins out there with
very different mindsets from mine

Acked-by: Serge Hallyn <serue@us.ibm.com>

-serge
