Return-Path: <linux-kernel-owner+w=401wt.eu-S1763913AbXKNTAf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763913AbXKNTAf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 14:00:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754465AbXKNTAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 14:00:25 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:65082 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756412AbXKNTAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 14:00:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:organization:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=BLz4DiS8JzrUzla3tTm/lCiCxfqR9k4RRh7I1NZPELKtXcHtFQGYHfI5UuqnhWad+JkO1hiZosOp0LrxY9WbluJWPGV+EbfXKOp/3qlLq9z7P5htyqf+zB1iHKG4VTU2VS8A/iKYDRG96XAOFa4McPru6n9Rxi8isf98lbVa6xQ=
Message-ID: <473B45C1.8070607@gmail.com>
Date: Wed, 14 Nov 2007 22:00:17 +0300
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Organization: DmVo Home
User-Agent: Thunderbird 1.5.0.14pre (X11/20071022)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, tigran@aivazian.fsnet.co.uk,
       apw@shadowen.org
Subject: Re: [PATCH] 2.6.24-rc2-mm1 - Build Fail - fs/bfs/inode.c
References: <20071114050054.GB12453@linux.vnet.ibm.com> <20071113212547.495f24dd.akpm@linux-foundation.org>
In-Reply-To: <20071113212547.495f24dd.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton пишет:
> On Wed, 14 Nov 2007 10:30:54 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
> 
>> Hi Andrew,
>>
>> The kernel build fails, with following error
>>
>> fs/bfs/inode.c: In function ‘bfs_iget’:
>> fs/bfs/inode.c:37: error: ‘ino’ redeclared as different kind of symbol
>> fs/bfs/inode.c:35: error: previous definition of ‘ino’ was here
>> fs/bfs/inode.c:37: error: ‘inode’ undeclared (first use in this function)
>> fs/bfs/inode.c:37: error: (Each undeclared identifier is reported onlyonce
>> fs/bfs/inode.c:37: error: for each function it appears in.)
>> make[2]: *** [fs/bfs/inode.o] Error 1
>> make[1]: *** [fs/bfs] Error 2
>> make: *** [fs] Error 2
>>
>> Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
>> --
>> --- linux-2.6.24-rc2/fs/bfs/inode.c	2007-11-14 09:53:41.000000000 +0530
>> +++ linux-2.6.24-rc2/fs/bfs/~inode.c	2007-11-14 10:21:06.000000000 +0530
>> @@ -34,7 +34,6 @@ void dump_imap(const char *prefix, struc
>>  
>>  struct inode *bfs_iget(struct super_block *sb, unsigned long ino)
>>  {
>> -	unsigned long ino = inode->i_ino;
>>  	struct bfs_inode *di;
>>  	struct inode *inode;
>>  	struct buffer_head *bh;
>>
> 
> bah.  That's what happens when I apply patches and fix rejects after doing
> all my compile-coverage testing.
> 
> Thanks.  I put your two fixes into the hot-fixes/ directory.

Andrew, I tested the BFS driver using the 2.6.24-rc2-mm1 kernel and I can confirm that the bugs I reported earlier are gone now.

Frankly, I was not expecting that my fixes would be applied on top of the "stop using iget() and read_inode()" patches, that is why I prepared my patch against the Linus tree. Thank you for your work in merging the modifications.

Dmitri

> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

