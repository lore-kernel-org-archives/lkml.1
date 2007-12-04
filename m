Return-Path: <linux-kernel-owner+w=401wt.eu-S1752948AbXLDJbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948AbXLDJbz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 04:31:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752065AbXLDJbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 04:31:48 -0500
Received: from sacred.ru ([62.205.161.221]:43036 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751216AbXLDJbr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 04:31:47 -0500
Message-ID: <47551E79.6080802@openvz.org>
Date: Tue, 04 Dec 2007 12:31:37 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: ebiederm@xmission.com, linux-kernel@vger.kernel.org, devel@openvz.org
Subject: Re: [PATCH 1/7][QUOTA] Move sysctl management code under ifdef CONFIG_SYSCTL
References: <475008F5.3000506@openvz.org>	<475009FA.20409@openvz.org>	<20071203133844.40804dab.akpm@linux-foundation.org>	<475516B6.5000504@openvz.org> <20071204012301.4349bbd0.akpm@linux-foundation.org>
In-Reply-To: <20071204012301.4349bbd0.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Tue, 04 Dec 2007 12:31:36 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Tue, 04 Dec 2007 11:58:30 +0300 Pavel Emelyanov <xemul@openvz.org> wrote:
> 
>>>> +#ifdef CONFIG_SYSCTL
>>>>  	register_sysctl_table(sys_table);
>>>> +#endif
>>>>  
>>>>  	dquot_cachep = kmem_cache_create("dquot",
>>>>  			sizeof(struct dquot), sizeof(unsigned long) * 4,
>>> We should avoid the ifdefs around the register_sysctl_table() call.
>>>
>>> At present the !CONFIG_SYSCTL implementation of register_sysctl_table() is
>>> a non-inlined NULL-returning stub.  All we have to do is to inline that stub
>>> then these ifdefs can go away.
>> What if some code checks for the return value to be not-NULL? In case
>> CONFIG_SYSCTL=n this code will always think, that the registration failed.
> 
> The stub function should return success?

Well, I think yes. If some functionality is turned off, then the 
caller should think that everything is going fine (or he should
explicitly removes the call to it with some other ifdef). 

At least this is true for stubs that return the error code, not 
the pointer. E.g. copy_semundo() always returns success if SYSVIPC 
is off, or namespaces cloning routines act in a similar way.

Thus I though, that routines, that return pointers should better
report that everything is OK (somehow) to reduce the number of 
"helpers" in the outer code. No?

Thanks,
Pavel

