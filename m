Return-Path: <linux-kernel-owner+w=401wt.eu-S1755080AbYJOVmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755080AbYJOVmT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 17:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752706AbYJOVmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 17:42:11 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:39884 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670AbYJOVmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 17:42:11 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Christoph Hellwig <hch@infradead.org>
Cc: viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] vfs: add d_ancestor()
References: <fcaad2cb3e848f5f6f1126623.ps@mail.parknet.co.jp>
	<e015bca83e848f5f6f2226623.ps@mail.parknet.co.jp>
	<20081015195318.GA28349@infradead.org>
Date: Thu, 16 Oct 2008 06:42:07 +0900
In-Reply-To: <20081015195318.GA28349@infradead.org> (Christoph Hellwig's
	message of "Wed, 15 Oct 2008 15:53:18 -0400")
Message-ID: <87skqxmt74.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@infradead.org> writes:

> This change looks good, but a slightly more detailed changelog would be
> good.

tweaked...

>>  /*
>> - * Helper that returns 1 if p1 is a parent of p2, else 0
>> + * Helper that returns the ancestor dentry of p2 which is a child of
>> + * p1, if p1 is an ancestor of p2, else NULL.
>>   */
>> -static int d_isparent(struct dentry *p1, struct dentry *p2)
>> +struct dentry *d_ancestor(struct dentry *p1, struct dentry *p2)
>
> Given that d_ancestor is non-static a kerneldoc comment describing it
> instead of a plain one would be good.

Yes.

>>  int is_subdir(struct dentry * new_dentry, struct dentry * old_dentry)
>>  {
>>  	int result;
>> -	struct dentry * saved = new_dentry;
>>  	unsigned long seq;
>>  
>> +	if (new_dentry == old_dentry)
>> +		return 1;
>
> Maybe a comment like in your commit description here would be good?

Sure, thanks.

> 	/*
> 	 * Need rcu_readlock to protect against the d_parent trashing due to
> 	 * d_move.
> 	 */
> 	rcu_read_lock();
> 	do {
> 		/* for restarting inner loop in case of seq retry */
>  		seq = read_seqbegin(&rename_lock);
> 		if (d_ancestor(old_dentry, new_dentry))
> 			result = 1;
> 		else
> 			result = 0;
> 	} while (read_seqretry(&rename_lock, seq));
>  	rcu_read_unlock();

I'll borrow your version. Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
