Return-Path: <linux-kernel-owner+w=401wt.eu-S1754649AbXLGCOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649AbXLGCOo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 21:14:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753023AbXLGCOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 21:14:34 -0500
Received: from vsmtp04.dti.ne.jp ([202.216.231.139]:48099 "EHLO
	vsmtp04.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359AbXLGCOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 21:14:33 -0500
X-Greylist: delayed 1526 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Dec 2007 21:14:33 EST
From: sfjro@users.sourceforge.net
Subject: Re: [RFC PATCH 0/5] Union Mount: A Directory listing approach with lseek support 
To: bharata@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Jan Blunck <jblunck@suse.de>, Erez Zadok <ezk@cs.sunysb.edu>,
       viro@zeniv.linux.org.uk, Christoph Hellwig <hch@lst.de>,
       Dave Hansen <haveblue@us.ibm.com>
In-Reply-To: <20071205143718.GC2471@in.ibm.com>
References: <20071205143718.GC2471@in.ibm.com>
Date: Fri, 07 Dec 2007 10:48:07 +0900
Message-Id: <E1J0SJz-0000w3-Cz@jroun>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Bharata B Rao:
> - The cache can grow arbitrarily large in size for big directories thereby
> consuming lots of memory. Pruning individual cache entries is out of question
> as entire cache is needed for subsequent readdirs for duplicate elimination.

Additionally, the memory usage may be a problem too since your
implementation calls kmalloc() for every names.


> - Whenever _any_ directory that is part of the union gets
> modified (addition/deletion of entries), the dirent cache of all the unions
> which this directory is part of, needs to be purged and rebuilt. This is
> expensive not only due to re-reads of dirents but also because
> readdir(2)/getdents(2) needs to be synchronized with other operations
> like mkdir/mknod/link/unlink etc.

The cache in struct file doesn't need to be refreshed unless rewinddir()
is issued. Also you can maintain the cache in every add/del entries,
instead of discarding the cache entirely.


> After all this, I am beginning to think if it would be better to delegate
> this readdir and whiteout processing to userspace. Can this be better handled

Yes, I had such idea once. And copy-up too. They can be done in
userspace (while you need to be careful about the privilege).

Anyway I agree with you. As I wrote before, this approach consumes a lot
of memory and cpu (for comparing whiteouted names).


Junjiro Okajima
