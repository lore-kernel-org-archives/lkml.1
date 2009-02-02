Return-Path: <linux-kernel-owner+w=401wt.eu-S1756787AbZBBRDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756787AbZBBRDS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 12:03:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752749AbZBBRDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 12:03:07 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:46774 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752685AbZBBRDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 12:03:06 -0500
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, gregkh@suse.de,
       linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk,
       cornelia.huck@de.ibm.com
References: <m13afch1sw.fsf@fess.ebiederm.org>
	<m1k58nffqm.fsf@fess.ebiederm.org> <497964CC.8070004@kernel.org>
	<20090127154437.9e7118f7.akpm@linux-foundation.org>
	<497FAB17.3080607@kernel.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 02 Feb 2009 09:03:11 -0800
In-Reply-To: <497FAB17.3080607@kernel.org> (Tejun Heo's message of "Wed\, 28 Jan 2009 09\:47\:19 +0900")
Message-ID: <m1pri04vqo.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=67.180.49.163;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.180.49.163
X-SA-Exim-Rcpt-To: tj@kernel.org, cornelia.huck@de.ibm.com, viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org, gregkh@suse.de, akpm@linux-foundation.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Tejun Heo <tj@kernel.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH] sysfs: Reference sysfs_dirent from sysfs inodes.
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:

> Andrew Morton wrote:
>> On Fri, 23 Jan 2009 15:33:48 +0900
>> Tejun Heo <tj@kernel.org> wrote:
>> 
>>> Eric W. Biederman wrote:
>>>> The sysfs_dirent serves as both an inode and a directory entry
>>>> for sysfs.  To prevent the sysfs inode numbers from being freed
>>>> prematurely hold a reference to sysfs_dirent from the sysfs inode.
>>>>
>>>> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
>>> Thanks for working on this.  Can you please add a comment explaining
>>> it on top of sysfs_delete_inode()?
>> 
>> Like this?
>> 
>> --- a/fs/sysfs/inode.c~sysfs-reference-sysfs_dirent-from-sysfs-inodes-fix
>> +++ a/fs/sysfs/inode.c
>> @@ -215,6 +215,13 @@ struct inode * sysfs_get_inode(struct sy
>>  	return inode;
>>  }
>>  
>> +/*
>> + * The sysfs_dirent serves as both an inode and a directory entry for sysfs.
>> + * To prevent the sysfs inode numbers from being freed prematurely we take a
>> + * reference to sysfs_dirent from the sysfs inode.  A
>> + * super_operations.delete_inode() implementation is needed to drop that
>> + * reference upon inode destruction.
>> + */
>>  void sysfs_delete_inode(struct inode *inode)
>>  {
>>  	struct sysfs_dirent *sd  = inode->i_private;
>
> Yeap, looks good to me.  :-)

Thanks guys.

Eric

