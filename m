Return-Path: <linux-kernel-owner+w=401wt.eu-S1756487AbZKDOYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756487AbZKDOYZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 09:24:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756473AbZKDOYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 09:24:24 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:39016 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756406AbZKDOYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 09:24:23 -0500
Date: Wed, 4 Nov 2009 08:24:18 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-fsdevel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
       Benjamin LaHaise <bcrl@lhnet.ca>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 09/13] sysfs: Implement sysfs_getattr & sysfs_permission
Message-ID: <20091104142418.GB4355@us.ibm.com>
References: <m13a4vbz8r.fsf@fess.ebiederm.org> <1257249429-12384-9-git-send-email-ebiederm@xmission.com> <20091104042038.GE27639@us.ibm.com> <m1pr7ybzzb.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1pr7ybzzb.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> "Serge E. Hallyn" <serue@us.ibm.com> writes:
> 
> > So the inode->i_mutex is not needed?
> 
> Good question.  Nothing in sysfs needs it.  The VFS does not grab the
> inode mutex on this path, but the vfs does grab the inode mutex when
> writing to the inode.

All callers of fs/attr.c:notify_change() do seem to take the i_mutex,
though.  And Documentation/filesystem/Locking claims that ->setattr()
does need i_mutex.  So I assume that setting of inode->i_ctime etc,
which is what you're doing here, needs to be protected by the i_mutex.

> Since the VFs isn't grabbing the inode_mutex there is probably a race in
> here somewhere if someone looks at things just right.
> 
> I am too tired tonight to be that person.

The readers take no lock of any sort (i.e. generic_fillattr and its
callers) so IIUC they could get inconsistent data...

-serge
