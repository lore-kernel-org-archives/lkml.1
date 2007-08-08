Return-Path: <linux-kernel-owner+w=401wt.eu-S937150AbXHHQ40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937150AbXHHQ40 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 12:56:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765154AbXHHQ4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 12:56:15 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:52297 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765091AbXHHQ4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 12:56:13 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Tejun Heo <htejun@gmail.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       satyam@infradead.org, cornelia.huck@de.ibm.com,
       stern@rowland.harvard.edu, Linux Containers <containers@lists.osdl.org>,
       gregkh@suse.de
Subject: Re: [PATCH 20/25] sysfs: Rename Support multiple superblocks
References: <m1tzrbhwkc.fsf_-_@ebiederm.dsl.xmission.com>
	<m1ps1zhwhp.fsf_-_@ebiederm.dsl.xmission.com>
	<m1lkcnhwfu.fsf_-_@ebiederm.dsl.xmission.com>
	<m1hcnbhwcy.fsf_-_@ebiederm.dsl.xmission.com>
	<m1d4xzhwb2.fsf_-_@ebiederm.dsl.xmission.com>
	<m18x8nhw8r.fsf_-_@ebiederm.dsl.xmission.com>
	<m14pjbhw6y.fsf_-_@ebiederm.dsl.xmission.com>
	<m1zm13ghlh.fsf_-_@ebiederm.dsl.xmission.com>
	<m1vebrghjg.fsf_-_@ebiederm.dsl.xmission.com>
	<m1r6mfghg9.fsf_-_@ebiederm.dsl.xmission.com>
	<20070808093505.GL13674@htj.dyndns.org>
	<m1643qdo7e.fsf@ebiederm.dsl.xmission.com>
	<46B9E660.6030702@gmail.com>
	<m1lkcmc7c5.fsf@ebiederm.dsl.xmission.com>
	<46B9F25B.6020804@gmail.com>
Date: Wed, 08 Aug 2007 10:55:10 -0600
In-Reply-To: <46B9F25B.6020804@gmail.com> (Tejun Heo's message of "Thu, 09 Aug
	2007 01:42:03 +0900")
Message-ID: <m18x8mc6fl.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <htejun@gmail.com> writes:

> Eric W. Biederman wrote:
>>> 	/* Find the first parent which has valid dentry.
>>> 	 */
>>> 	dentry = NULL;
>>> 	cur = sd;
>>> 	while (!(dentry = __sysfs_get_dentry(sb, cur))) {
>>> 		if (cur->s_flags & SYSFS_FLAG_REMOVED) {
>>> 			dentry = ERR_PTR(-ENOENT);
>>> 			break;
>>> 		}
>>> 		cur = cur->s_parent;
>>> 	}
>> 
>> Here we depend on the fact that sysfs_root is pointed to
>> by sb->s_root so we know it will always have a dentry.
>
> Hmmm... dentry could be ERR_PTR(-ENOENT) here if the REMOVED flag test
> succeeded, right?

Ugh right.  Now that I don't have the locking it probably makes
sense to have that path just return or branch to the exit.

>
>>> 	/* from the found dentry, look up depth times */
>>> 	while (dentry->d_fsdata != sd) {
>
> And then dereferenced.  The REMOVED test should never succeed there, so
> we're probably in the clear but still the code looks a bit scary.

Agreed.  That is a bug.  Either the removed test needs to
be removed because it can't happen or that case needs to be handled.

Thanks for spotting this one.

Mental blind spots are the worst.

Eric
