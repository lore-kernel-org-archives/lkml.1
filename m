Return-Path: <linux-kernel-owner+w=401wt.eu-S1756189AbXFKSLn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189AbXFKSLn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 14:11:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752734AbXFKSLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 14:11:35 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55814 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751322AbXFKSLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 14:11:33 -0400
Date: Mon, 11 Jun 2007 11:11:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Albert Cahalan <acahalan@gmail.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       torvalds@linux-foundation.org, Badari Pulavarty <pbadari@us.ibm.com>
Subject: Re: [PATCH] shm: Fix the filename of hugetlb sysv shared memory
Message-Id: <20070611111111.2345470d.akpm@linux-foundation.org>
In-Reply-To: <m1vedyqaft.fsf_-_@ebiederm.dsl.xmission.com>
References: <787b0d920706062027s5a8fd35q752f8da5d446afc@mail.gmail.com>
	<20070606204432.b670a7b1.akpm@linux-foundation.org>
	<787b0d920706062153u7ad64179p1c4f3f663c3882f@mail.gmail.com>
	<20070607162004.GA27802@vino.hallyn.com>
	<m1ir9zrtwe.fsf@ebiederm.dsl.xmission.com>
	<46697EDA.9000209@us.ibm.com>
	<m1vedyqaft.fsf_-_@ebiederm.dsl.xmission.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 08 Jun 2007 17:43:34 -0600
ebiederm@xmission.com (Eric W. Biederman) wrote:

> Some user space tools need to identify SYSV shared memory when
> examining /proc/<pid>/maps.  To do so they look for a block device
> with major zero, a dentry named SYSV<sysv key>, and having the minor of
> the internal sysv shared memory kernel mount.
> 
> To help these tools and to make it easier for people just browsing
> /proc/<pid>/maps this patch modifies hugetlb sysv shared memory to
> use the SYSV<key> dentry naming convention.
> 
> User space tools will still have to be aware that hugetlb sysv
> shared memory lives on a different internal kernel mount and so
> has a different block device minor number from the rest of sysv
> shared memory.

So..  I am sitting here believing that this patch and Badari's
restore-shmid-as-inode-to-fix-proc-pid-maps-abi-breakage.patch are both
needed in 2.6.22 and that they will fix all these issues up.

If that is untrue, someone please let us know..
