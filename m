Return-Path: <linux-kernel-owner+w=401wt.eu-S1754206AbXFIEcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206AbXFIEcT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 00:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751665AbXFIEcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 00:32:09 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:47763 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919AbXFIEcH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 00:32:07 -0400
Message-ID: <466A2D4F.3040300@us.ibm.com>
Date: Fri, 08 Jun 2007 21:32:15 -0700
From: Badari Pulavarty <pbadari@us.ibm.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:0.9.4.1) Gecko/20020508 Netscape6/6.2.3
X-Accept-Language: en-us
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Serge E. Hallyn" <serge@hallyn.com>,
       Albert Cahalan <acahalan@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, torvalds@linux-foundation.org
Subject: Re: [PATCH] shm: Fix the filename of hugetlb sysv shared memory
References: <787b0d920706062027s5a8fd35q752f8da5d446afc@mail.gmail.com> <20070606204432.b670a7b1.akpm@linux-foundation.org> <787b0d920706062153u7ad64179p1c4f3f663c3882f@mail.gmail.com> <20070607162004.GA27802@vino.hallyn.com> <m1ir9zrtwe.fsf@ebiederm.dsl.xmission.com> <46697EDA.9000209@us.ibm.com> <m1vedyqaft.fsf_-_@ebiederm.dsl.xmission.com> <20070608165505.aa15fcdb.akpm@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Andrew Morton wrote:

>On Fri, 08 Jun 2007 17:43:34 -0600
>ebiederm@xmission.com (Eric W. Biederman) wrote:
>
>>Some user space tools need to identify SYSV shared memory when
>>examining /proc/<pid>/maps.  To do so they look for a block device
>>with major zero, a dentry named SYSV<sysv key>, and having the minor of
>>the internal sysv shared memory kernel mount.
>>
>>To help these tools and to make it easier for people just browsing
>>/proc/<pid>/maps this patch modifies hugetlb sysv shared memory to
>>use the SYSV<key> dentry naming convention.
>>
>>User space tools will still have to be aware that hugetlb sysv
>>shared memory lives on a different internal kernel mount and so
>>has a different block device minor number from the rest of sysv
>>shared memory.
>>
>
>I assume this fix is preferred over Badari's?  If so, why?
>
No. You still need my patch to fix the current breakage.

This patch makes hugetlbfs also use same naming convention as regular 
shmem for its
name. This is not absolutely needed, its a nice to have. Currently, user 
space tools
can't depend on the filename alone, since its not unique (based on kry).

Thanks,
Badari

>


