Return-Path: <linux-kernel-owner+w=401wt.eu-S969649AbXFHQIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969649AbXFHQIS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 12:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968310AbXFHQHt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 12:07:49 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:50122 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S969908AbXFHQHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 12:07:47 -0400
Message-ID: <46697EDA.9000209@us.ibm.com>
Date: Fri, 08 Jun 2007 09:07:54 -0700
From: Badari Pulavarty <pbadari@us.ibm.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:0.9.4.1) Gecko/20020508 Netscape6/6.2.3
X-Accept-Language: en-us
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: "Serge E. Hallyn" <serge@hallyn.com>, Albert Cahalan <acahalan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, torvalds@linux-foundation.org
Subject: Re: [RFC][PATCH] /proc/pid/maps doesn't match "ipcs -m" shmid
References: <787b0d920706062027s5a8fd35q752f8da5d446afc@mail.gmail.com> <20070606204432.b670a7b1.akpm@linux-foundation.org> <787b0d920706062153u7ad64179p1c4f3f663c3882f@mail.gmail.com> <20070607162004.GA27802@vino.hallyn.com> <m1ir9zrtwe.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Eric W. Biederman wrote:

>
>At this point given that we actually have a small user space dependency
>and the fact that after I have reviewed the code it looks harmless to
>change the inode number of those inodes, in both cases they are just
>anonymous inodes generated with new_inode, and anything that we wrap
>is likely to be equally so.
>
>So it looks to me like we need to do three things:
>- Fix the inode number
>
Okay. its already done.

>
>- Fix the name on the hugetlbfs dentry to hold the key
>
I don't see need for doing this for hugetlbfs inodes. Currently, they 
don't base their
name on "key" + basing on the "key" is kind of useless anyway (its not 
unique).

>
>- Add a big fat comment that user space programs depend on this
>  behavior of both the dentry name and the inode number.
>
I don't think, the user-space can depend on the dentry-name. It can only 
depend
on inode# to match shmid. (since key is not unique esp. for key=0x00000000).

BTW, I agree that shmid is not unique even without namespaces as its 
based on
seq# and we wrap seq#.

Thanks,
Badari




