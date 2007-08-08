Return-Path: <linux-kernel-owner+w=401wt.eu-S1761292AbXHHIXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761292AbXHHIXl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 04:23:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752973AbXHHIX0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 04:23:26 -0400
Received: from jericho.provo.novell.com ([137.65.248.124]:32627 "EHLO
	jericho.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbXHHIXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 04:23:24 -0400
Message-ID: <46B97D6F.8040504@suse.de>
Date: Wed, 08 Aug 2007 17:23:11 +0900
From: Tejun Heo <teheo@suse.de>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, satyam@infradead.org,
       cornelia.huck@de.ibm.com, stern@rowland.harvard.edu,
       Linux Containers <containers@lists.osdl.org>, gregkh@suse.de
Subject: Re: [PATCH 12/25] sysfs: Introduce sysfs_rename_mutex
References: <11860582832964-git-send-email-htejun@gmail.com>	<m1643rkqb6.fsf@ebiederm.dsl.xmission.com>	<m11wefkq88.fsf_-_@ebiederm.dsl.xmission.com>	<m1wsw7jbml.fsf_-_@ebiederm.dsl.xmission.com>	<m1sl6vjbjw.fsf_-_@ebiederm.dsl.xmission.com>	<m1odhjjbij.fsf_-_@ebiederm.dsl.xmission.com>	<m1k5s7jbh9.fsf_-_@ebiederm.dsl.xmission.com>	<m1fy2vjbf9.fsf_-_@ebiederm.dsl.xmission.com>	<m1bqdjjbcf.fsf_-_@ebiederm.dsl.xmission.com>	<m17io7jba4.fsf_-_@ebiederm.dsl.xmission.com>	<m13ayvjb82.fsf_-_@ebiederm.dsl.xmission.com>	<m1y7gnhwm4.fsf_-_@ebiederm.dsl.xmission.com>	<m1tzrbhwkc.fsf_-_@ebiederm.dsl.xmission.com> <m1ps1zhwhp.fsf_-_@ebiederm.dsl.xmission.com> <46B97C94.8090209@gmail.com>
In-Reply-To: <46B97C94.8090209@gmail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Hello, Eric.
> 
> Eric W. Biederman wrote:
>> Looking carefully at the rename code we have a subtle dependency
>> that the structure of sysfs not change while we are performing
>> a rename.  If the parent directory of the object we are renaming
>> changes while the rename is being performed nasty things could
>> happen when we go to release our locks.
>>
>> So introduce a sysfs_rename_mutex to prevent this highly
>> unlikely theoretical issue.
> 
> Yeah, it's a theoretical issue.  Rename/move implementation has always
> depended on the parent structure not changing beneath it, but it's nice
> to tighten up loose ends.
> 
>> +DEFINE_MUTEX(sysfs_rename_mutex);
> 
> Probably doesn't really matter but wouldn't a rwsem fit better?
> 
>> @@ -774,7 +775,7 @@ static struct dentry *__sysfs_get_dentry(struct super_block *sb, struct sysfs_di
>>   *	down from there looking up dentry for each step.
>>   *
>>   *	LOCKING:
>> - *	Kernel thread context (may sleep)
>> + *	mutex_lock(sysfs_rename_mutex)
> 
> LOCKING describes what locks should be held when entering the function,
> so proper description would be something like...
> 
> 	Kernel thread context, grabs sysfs_rename_mutex

Oops, forget about the above.  Thought the comment was added to
sysfs_rename_dir().

-- 
tejun
