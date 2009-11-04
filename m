Return-Path: <linux-kernel-owner+w=401wt.eu-S1754490AbZKDDmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490AbZKDDmu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 22:42:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754301AbZKDDmt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 22:42:49 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:34097 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754014AbZKDDms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 22:42:48 -0500
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-fsdevel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
       Benjamin LaHaise <bcrl@lhnet.ca>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 04/13] sysfs: Simplify sysfs_chmod_file semantics
References: <m13a4vbz8r.fsf@fess.ebiederm.org>
	<1257249429-12384-4-git-send-email-ebiederm@xmission.com>
	<20091104024332.GA27639@us.ibm.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 03 Nov 2009 19:42:40 -0800
In-Reply-To: <20091104024332.GA27639@us.ibm.com> (Serge E. Hallyn's message of "Tue\, 3 Nov 2009 20\:43\:32 -0600")
Message-ID: <m17hu7ez0v.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Exit with error (see exim mainlog)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serue@us.ibm.com> writes:

> Quoting Eric W. Biederman (ebiederm@xmission.com):
>> From: Eric W. Biederman <ebiederm@xmission.com>
>> 
>> Currently every caller of sysfs_chmod_file happens at either
>> file creation time to set a non-default mode or in response
>> to a specific user requested space change in policy.  Making
>> timestamps of when the chmod happens and notification of
>> a file changing mode uninteresting.
>
> But these changes can occur by togging values in sysfs files
> (i.e. f71805f.c), right?  Is this (specifically not doing inotify)
> definately uncontroversial?

The fs_notify_change was not introduced to deliberately support
a feature but as a side effect of other cleanups.  So there
is no indication that anyone cares about inotify support.

> I can't exactly picture an admin sitting there watching
> nautilus for a sysfs file to become writeable, but could
> imagine some site's automation getting hung...  Or am I way
> off base?

I would be stunned if the shell script in the automation that writes
to a sysfs file to make things writeable doesn't on it's next line
kick off whatever needs it to be writable.

With no benefit to using inotify and with only a handful of sysfs
files affected I don't expect this change to break anything in
userspace and I have been happily running with it for a year or so on
all of our machines at work with no one problems.

The reason I am making the change is that the goal of this patchset is
to get sysfs to act like any other distributed filesystem in linux,
and to use the same interfaces in roughly the same ways as other
distributed filesystems.  Unfortunately there is not a good interface
for distributed filesystems to support inotify or I would use it.

Eric
