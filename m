Return-Path: <linux-kernel-owner+w=401wt.eu-S1761387AbYGKTZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761387AbYGKTZy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 15:25:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760952AbYGKTYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 15:24:10 -0400
Received: from ns2.suse.de ([195.135.220.15]:40566 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761177AbYGKTYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 15:24:07 -0400
Message-ID: <4877B339.4080103@suse.com>
Date: Fri, 11 Jul 2008 15:23:37 -0400
From: Jeff Mahoney <jeffm@suse.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ReiserFS Mailing List <reiserfs-devel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>
Subject: Re: [PATCH] reiserfs: discard prealloc in reiserfs_delete_inode
References: <4873B3D2.1090101@suse.com> <20080711121850.dfd60681.akpm@linux-foundation.org>
In-Reply-To: <20080711121850.dfd60681.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Andrew Morton wrote:
> On Tue, 08 Jul 2008 14:37:06 -0400 Jeff Mahoney <jeffm@suse.com> wrote:
> 
>>  With the removal of struct file from the xattr code, reiserfs_file_release()
>>  isn't used anymore, so the prealloc isn't discarded. This causes hangs
>>  later down the line.
>>
>>  This patch adds it to reiserfs_delete_inode. In most cases it will be
>>  a no-op due to it already having been called, but will avoid hangs with xattrs.
>>
>> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
>> ---
>>  fs/reiserfs/inode.c |    2 ++
>>  1 file changed, 2 insertions(+)
>>
>> --- a/fs/reiserfs/inode.c
>> +++ b/fs/reiserfs/inode.c
>> @@ -45,6 +45,8 @@ void reiserfs_delete_inode(struct inode
>>  			goto out;
>>  		reiserfs_update_inode_transaction(inode);
>>  
>> +		reiserfs_discard_prealloc(&th, inode);
>> +
>>  		err = reiserfs_delete_object(&th, inode);
>>  
>>  		/* Do quota update inside a transaction for journaled quotas. We must do that
> 
> Can you please remind us when "the removal of struct file from the xattr
> code" happened?
> 
> Because hangs aren't good, and 2.6.25 might want this.

You're right. It was added in 2.6.25-rc7. I'll ping Greg about including
it in the stable tree.

- -Jeff

- --
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkh3szkACgkQLPWxlyuTD7IOyACZAd0+kO4D+bPjx1W1pX/APgl+
eKgAoJ75yKu/IlmHxvlmyWM5DThyKCQL
=BLAB
-----END PGP SIGNATURE-----
