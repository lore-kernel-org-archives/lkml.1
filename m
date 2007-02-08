Return-Path: <linux-kernel-owner+w=401wt.eu-S1423432AbXBHWSJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423432AbXBHWSJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 17:18:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423433AbXBHWSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 17:18:08 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:51673 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423432AbXBHWSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 17:18:06 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       tglx@linutronix.de, linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       James Morris <jmorris@namei.org>
Subject: Re: [PATCH 2/2] sysctl: Restore the selinux path based label lookup for sysctls.
References: <200701280106.l0S16CG3019873@shell0.pdx.osdl.net>
	<20070127172410.2b041952.akpm@osdl.org>
	<1169972718.17469.164.camel@localhost.localdomain>
	<20070128003549.2ca38dc8.akpm@osdl.org>
	<20070128093358.GA2071@elte.hu> <20070128095712.GA6485@elte.hu>
	<20070128100627.GA8416@elte.hu>
	<20070128104548.a835d859.akpm@osdl.org>
	<m1r6tfq7nv.fsf_-_@ebiederm.dsl.xmission.com>
	<1170075866.8720.15.camel@moss-spartans.epoch.ncsc.mil>
	<m17iuvrnpk.fsf_-_@ebiederm.dsl.xmission.com>
	<m13b5jrngt.fsf_-_@ebiederm.dsl.xmission.com>
	<1170872654.11912.87.camel@moss-spartans.epoch.ncsc.mil>
	<1170882738.11912.144.camel@moss-spartans.epoch.ncsc.mil>
	<m17iutmmwh.fsf@ebiederm.dsl.xmission.com>
	<1170946871.11912.250.camel@moss-spartans.epoch.ncsc.mil>
	<m14ppwa64j.fsf@ebiederm.dsl.xmission.com>
	<1170958404.11912.313.camel@moss-spartans.epoch.ncsc.mil>
Date: Thu, 08 Feb 2007 15:17:24 -0700
In-Reply-To: <1170958404.11912.313.camel@moss-spartans.epoch.ncsc.mil>
	(Stephen Smalley's message of "Thu, 08 Feb 2007 13:13:24 -0500")
Message-ID: <m1mz3o8fbf.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Smalley <sds@tycho.nsa.gov> writes:

> Possibly, during setup upon initial policy load (initiated by /sbin/init
> these days) from selinux_complete_init, as early userspace may have
> already been accessing them.

I believe if we chose we could walk the dentry tree under the root inode
and find all of these.

>>   If all of the accesses
>> that we care about go through inode_doinit_with_dentry we can just
>> walk the dcache to get the names, and that should work for the normal
>> proc case as well.
>
> Walking the proc_dir_entry tree (or the ctl_table tree) is preferable as
> it is a stable, user-immutable representation.  Also avoids taking the
> dcache lock.

The dcache lock is valid.  Since the per filesystem dentry tree is just
a mirror of the filesystem data there is no advantage over using
the proc_dir_entry or ctl_table tree.  (If you start messing with mounts
that is another matter.

>> If it doesn't look easy to solve this another way I will certainly
>> go with marking the inodes private.

I hereby conclude this doesn't look easy enough to solve another way,
to get it solved in a timely manner.  Since the cost is only 2 lines
of code to use private inodes if we want to fix this later it should
not be difficult.

Eric
