Return-Path: <linux-kernel-owner+w=401wt.eu-S1754675AbZKDE6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675AbZKDE6U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 23:58:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753491AbZKDE6T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 23:58:19 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:45246 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259AbZKDE6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 23:58:18 -0500
Date: Tue, 3 Nov 2009 22:58:21 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-fsdevel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
       Benjamin LaHaise <bcrl@lhnet.ca>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 07/13] sysfs: Update s_iattr on link and unlink.
Message-ID: <20091104045821.GB774@us.ibm.com>
References: <m13a4vbz8r.fsf@fess.ebiederm.org> <1257249429-12384-7-git-send-email-ebiederm@xmission.com> <20091104035413.GD27639@us.ibm.com> <m1pr7zc4j7.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1pr7zc4j7.fsf@fess.ebiederm.org>
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
> >> Currently sysfs updates the timestamps on the vfs directory
> >> inode when we create or remove a directory entry but doesn't
> >> update the cached copy on the sysfs_dirent, fix that oversight.
> >
> > confused... why not do this in sysfs_addrm_finish()?
> >
> > I guess you'd have to do at it at top before dropping sysfs_mutex
> > so it wouldn't be as pretty as I was thinking, but at least you
> > could just do it once.
> 
> Well sysfs_addrm_finish doesn't really know if you did anything.

Oh right - well it used to through cnt right?  but not after your
last patch.

> Beyond that my ultimate goal is to kill sysfs_addrm_start and
> sysfs_addrm_finish.  Of course that requires fixing all of the
> sysfs users that depend on the impossible to get right recursive
> directory removal in sysfs, so it is not the subject of this patchset.

I didn't see the patch nixing inode->i_mtime (and cnt) changing from
sysfs_addrm_finish() until after responding.  Got it now.

Acked-by: Serge Hallyn <serue@us.ibm.com>

-serge
