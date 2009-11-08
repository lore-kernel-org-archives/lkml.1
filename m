Return-Path: <linux-kernel-owner+w=401wt.eu-S1751918AbZKHHEF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918AbZKHHEF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 02:04:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751397AbZKHHEE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 02:04:04 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:36064 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbZKHHED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 02:04:03 -0500
To: Tejun Heo <tj@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       Eric Dumazet <eric.dumazet@gmail.com>, Benjamin LaHaise <bcrl@lhnet.ca>,
       Serge Hallyn <serue@us.ibm.com>
Subject: Re: [PATCH 15/13] sysfs: Protect sysfs_refresh_inode with inode mutex.
References: <m13a4vbz8r.fsf@fess.ebiederm.org>
	<m1hbta1onf.fsf@fess.ebiederm.org> <4AF4DAEC.5010503@kernel.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sat, 07 Nov 2009 23:04:03 -0800
In-Reply-To: <4AF4DAEC.5010503@kernel.org> (Tejun Heo's message of "Sat\, 07 Nov 2009 11\:26\:52 +0900")
Message-ID: <m1iqdlo5uk.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:

> Eric W. Biederman wrote:
>> In general everything that writes to vfs inodes holds the
>> inode mutex, so hold the inode mutex over sysfs_refresh_inode.
>> The sysfs data structures don't need this but it looks like the
>> vfs might.
>> 
>> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
>
> Acked-by: Tejun Heo <tj@kernel.org>
>
> Sidenote: Hmmm... Originally, sysfs completely depended on vfs locking
> but with sysfs_dirent separation, the tree structure itself and some
> attributes went under the protection of sysfs_mutex while leaving more
> vfs oriented fields under vfs locking.  This patchset makes sysfs
> lazier so it can't depend on any vfs layer locking.  I think you've
> converted all necessary places while removing dependency on
> dentry/inode from update operations but it might be a good idea to do
> a audit pass over how fields are being protected now.

You raised a good point.  I took a quick second pass through.
I did not see anything I have missed, and I did not change anything
else on the vfs path.

So at the very least I don't expect there are any locking related
regressions.

Eric
