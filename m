Return-Path: <linux-kernel-owner+w=401wt.eu-S1759898AbZKGC07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759898AbZKGC07 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 21:26:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755955AbZKGC06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 21:26:58 -0500
Received: from hera.kernel.org ([140.211.167.34]:36034 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755373AbZKGC06 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 21:26:58 -0500
Message-ID: <4AF4DAEC.5010503@kernel.org>
Date: Sat, 07 Nov 2009 11:26:52 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       Eric Dumazet <eric.dumazet@gmail.com>, Benjamin LaHaise <bcrl@lhnet.ca>,
       Serge Hallyn <serue@us.ibm.com>
Subject: Re: [PATCH 15/13] sysfs: Protect sysfs_refresh_inode with inode mutex.
References: <m13a4vbz8r.fsf@fess.ebiederm.org> <m1hbta1onf.fsf@fess.ebiederm.org>
In-Reply-To: <m1hbta1onf.fsf@fess.ebiederm.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> In general everything that writes to vfs inodes holds the
> inode mutex, so hold the inode mutex over sysfs_refresh_inode.
> The sysfs data structures don't need this but it looks like the
> vfs might.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>

Acked-by: Tejun Heo <tj@kernel.org>

Sidenote: Hmmm... Originally, sysfs completely depended on vfs locking
but with sysfs_dirent separation, the tree structure itself and some
attributes went under the protection of sysfs_mutex while leaving more
vfs oriented fields under vfs locking.  This patchset makes sysfs
lazier so it can't depend on any vfs layer locking.  I think you've
converted all necessary places while removing dependency on
dentry/inode from update operations but it might be a good idea to do
a audit pass over how fields are being protected now.

Thanks for your patience.

-- 
tejun
