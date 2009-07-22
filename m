Return-Path: <linux-kernel-owner+w=401wt.eu-S1752814AbZGVAzL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814AbZGVAzL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 20:55:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751127AbZGVAzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 20:55:10 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49290 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750804AbZGVAzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 20:55:09 -0400
Message-ID: <4A66630C.3030303@cn.fujitsu.com>
Date: Wed, 22 Jul 2009 08:53:32 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: balbir@linux.vnet.ibm.com
CC: Zefan Li <lizf.kernel@gmail.com>, Xiaotian Feng <dfeng@redhat.com>,
       menage@google.com, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cgroup: fix reverse unlock sequence in cgroup_get_sb
References: <1248171926-20232-1-git-send-email-dfeng@redhat.com> <20090721111019.GV24157@balbir.in.ibm.com> <8522a3d30907210438u6fce081fi835bf964d0c01e8a@mail.gmail.com> <20090721120106.GW24157@balbir.in.ibm.com>
In-Reply-To: <20090721120106.GW24157@balbir.in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Seems reasonable to me. You might also want to mention that elsewhere
>>> the sequence is unlock cgroup_mutex followed by inode->i_mutex.
>>>
>>> Acked-by: Balbir Singh balbir@linux.vnet.ibm.com
>>
>> No, the unlock order is irrelevant. It's the lock order that matters. So
>> this patch
>> fixes nothing.
>>
>> Xiaotian, you didn't run into deadlock, did you?
>>
> 
> 
> Li, Consider the following
> 
> 
> lock(A)
> lock(B)
> unlock(A) 
> unlock(B)
> 
> Tomorrow if a unsuspecting programmer does this
> 
> lock(A)
> lock(B)
> unlock(A) 
> 
> code block 
> 
> unlock(B)
> 
> 
> What protects code block? lock B? Is that the intention?
> 

I won't worry about that. If unlock order is a concern,
we should have taught lockdep to detect it.

Here's a reply from Linus on this issue:

	http://lkml.org/lkml/2008/10/8/150
