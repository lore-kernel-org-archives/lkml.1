Return-Path: <linux-kernel-owner+w=401wt.eu-S1760573AbZC3UAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760573AbZC3UAz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 16:00:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760501AbZC3UAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 16:00:15 -0400
Received: from cantor.suse.de ([195.135.220.2]:59408 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757850AbZC3UAL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 16:00:11 -0400
Message-ID: <49D124B4.4040500@suse.com>
Date: Mon, 30 Mar 2009 15:59:48 -0400
From: Jeff Mahoney <jeffm@suse.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>
Subject: Re: [patch 00/35] Jeff's ReiserFS Patch Queue
References: <20090330180215.951354436@suse.com> <alpine.LFD.2.00.0903301236280.4093@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0903301236280.4093@localhost.localdomain>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Linus Torvalds wrote:
> 
> On Mon, 30 Mar 2009, Jeff Mahoney wrote:
>> I'd like to submit my reiserfs patch queue for inclusion into 2.6.30.
> 
> Hmm. Looks fine, and I merged it. I had a number of mostly trivial 
> conflicts (most due to the quota name cleanup to lower-case, with some 
> header file export cleanup conflicts added in), but they looked fairly 
> straightforward and I compile-tested the end result.
> 
> I don't have any reiserfs filesystems left, though, so you should really 
> double-check the end result.

Great, thanks! I realized just after I submitted that I didn't adjust
context to the last few days of mainline. The merge looks good except
for an added space in reiserfs_delete_inode. I've appended the patch for that.

>> Once this is applied, I expect reiserfs to be in deep maintenance-only 
>> mode.
> 
> Heh, I hadn't expected even this.

Hopefully it won't be. I still have to support reiserfs for our
enterprise releases, though. :)

- -Jeff

- ---
 fs/reiserfs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

- --- a/fs/reiserfs/inode.c
+++ b/fs/reiserfs/inode.c
@@ -52,7 +52,7 @@ void reiserfs_delete_inode(struct inode
 		/* Do quota update inside a transaction for journaled quotas. We must do that
 		 * after delete_object so that quota updates go into the same transaction as
 		 * stat data deletion */
- -		if (!err) 
+		if (!err)
 			vfs_dq_free_inode(inode);
 
 		if (journal_end(&th, inode->i_sb, jbegin_count))

- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAknRJLQACgkQLPWxlyuTD7IuOgCbBmWsC7seMVyE7TLD2gejcHgz
c9EAn2Ey64m2xNZ8R53lWqvAiWlX4UcP
=Ugl0
-----END PGP SIGNATURE-----
