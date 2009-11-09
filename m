Return-Path: <linux-kernel-owner+w=401wt.eu-S1755996AbZKIOPB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996AbZKIOPB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 09:15:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755929AbZKIOPB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 09:15:01 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:46417 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755926AbZKIOPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 09:15:00 -0500
Date: Mon, 9 Nov 2009 08:14:39 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       Eric Dumazet <eric.dumazet@gmail.com>, Benjamin LaHaise <bcrl@lhnet.ca>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 12/13] sysfs: Propagate renames to the vfs on demand
Message-ID: <20091109141439.GA10927@us.ibm.com>
References: <m13a4vbz8r.fsf@fess.ebiederm.org>
 <1257249429-12384-12-git-send-email-ebiederm@xmission.com>
 <20091104214938.GA21033@us.ibm.com>
 <m13a4ux86v.fsf@fess.ebiederm.org>
 <4AF4D76C.6090008@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AF4D76C.6090008@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Tejun Heo (tj@kernel.org):
> Hello,
> 
> Eric W. Biederman wrote:
> > It isn't what I want but it is what the VFS requires.  If let the vfs
> > continue on it's delusional state we will leak the vfs mount and
> > everything mounted on top of it, with no way to remove the mounts.
> 
> This is caused by not having any way to prevent deletion on
> directories with submounts, right?  How does other distributed
> filesystems deal with directories with submounts going away underneath
> it?

Ooooh.  I see, I was thinking only about the rename case, and forgot
this was the path for deleted files, too.  For the rename case it
should be ok to let the dentry be put since the submounts will be
accessible at the new location, right?  Should that be handled
separately?

-serge
