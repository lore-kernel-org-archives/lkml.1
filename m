Return-Path: <linux-kernel-owner+w=401wt.eu-S1030559AbXAZQHQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030559AbXAZQHQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 11:07:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030601AbXAZQHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 11:07:15 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:18130 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030559AbXAZQHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 11:07:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=XD2Df7SVypJrWnzV7ldUpO5qVJbv8zQb5XtzTOFLGkoCtUk2jb3TGtTXdL6KrpjgVdJyOMYX5YI/Jhb9csGpfMmr5ZIggYFvkAwNA7hOzeZ3fASXnOhdYK71UukkTa9OYUsYiYDUq2w8Z0dC7XDhqgND7d2zWLmlmEpCFrP8OGc=
Message-ID: <45BA2723.3000306@googlemail.com>
Date: Fri, 26 Jan 2007 17:06:59 +0100
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       Herbert Poetzl <herbert@13thfloor.at>, Oleg Nesterov <oleg@tv-sign.ru>,
       Cedric Le Goater <clg@fr.ibm.com>,
       Daniel Hokka Zakrisson <daniel@hozac.com>
Subject: Re: mm snapshot broken-out-2007-01-26-00-36.tar.gz uploaded
References: <200701260837.l0Q8blBr011622@shell0.pdx.osdl.net> <45BA1861.4090002@googlemail.com> <20070126153329.GA12550@sergelap.austin.ibm.com> <20070126153832.GB12550@sergelap.austin.ibm.com>
In-Reply-To: <20070126153832.GB12550@sergelap.austin.ibm.com>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Serge E. Hallyn napisał(a):
> Quoting Serge E. Hallyn (serue@us.ibm.com):
>> Quoting Michal Piotrowski (michal.k.k.piotrowski@gmail.com):
>>> Hi Serge,
>>>
>>> akpm@osdl.org napisa?(a):
>>>> The mm snapshot broken-out-2007-01-26-00-36.tar.gz has been uploaded to
>>>>
>>>>    ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-2007-01-26-00-36.tar.gz
>>>>
>>>> It contains the following patches against 2.6.20-rc6:
>>>>
>>>> origin.patch
>>> [..]
>>>> namespaces-fix-exit-race-by-splitting-exit.patch
>>> [..]
>>>
>>> I'm receiving an error
>>>
>>> In file included from /mnt/md0/devel/linux-work5/include/linux/sched.h:87,
>>>                  from /mnt/md0/devel/linux-work5/include/linux/utsname.h:35,
>>>                  from include2/asm/elf.h:12,
>>>                  from /mnt/md0/devel/linux-work5/include/linux/elf.h:7,
>>>                  from /mnt/md0/devel/linux-work5/include/linux/module.h:15,
>>>                  from /mnt/md0/devel/linux-work5/include/linux/crypto.h:21,
>>>                  from /mnt/md0/devel/linux-work5/arch/i386/kernel/asm-offsets.c:7:
>>> /mnt/md0/devel/linux-work5/include/linux/nsproxy.h: In function 'preexit_task_namespaces':
>>> /mnt/md0/devel/linux-work5/include/linux/nsproxy.h:56: error: dereferencing pointer to incomplete type
>>> make[2]: *** [arch/i386/kernel/asm-offsets.s] Error 1
>>> make[1]: *** [prepare0] Error 2
>>> make: *** [_all] Error 2
>>>
>>> Regards,
>>> Michal
>> Sorry, I don't know where to get a series file for this patchset?
>>
>> It sounds like your tree doesn't #include <linux/sched.h> at the top of
>> include/linux/nsproxy.h.  That was added by a separate patch I think
>> last week - a few architectures (which i was testing) had a #include chain
>> which ended up in sched.h being included free, but some arches had a
>> different chain.
>>
>> Anyway please try #include <linux/sched.h> at the top of
>> include/linux/nsproxy.h and let me know if that doesn't fix the problem.
> 
> No, I just found Cedric's patch removing the include.
> 
> So moving preexit_task_namespaces() into nsproxy.c is the right way to
> go.
> 
> thanks,
> -serge
> 

Thanks!

Regards,
Michal

--
Michal K. K. Piotrowski
LTG - Linux Testers Group
(http://www.stardust.webpages.pl/ltg/)

Build fix.

Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

diff -uprN linux-work-clean/include/linux/nsproxy.h linux-work/include/linux/nsproxy.h
--- linux-work-clean/include/linux/nsproxy.h	2007-01-26 16:47:55.000000000 +0100
+++ linux-work/include/linux/nsproxy.h	2007-01-26 17:00:54.000000000 +0100
@@ -51,11 +51,6 @@ static inline void put_and_finalize_nspr
 	finalize_put_nsproxy(put_nsproxy(ns));
 }

-static inline struct nsproxy *preexit_task_namespaces(struct task_struct *p)
-{
-	return put_nsproxy(p->nsproxy);
-}
-
 extern void exit_task_namespaces(struct task_struct *p);

 #endif
diff -uprN linux-work-clean/kernel/nsproxy.c linux-work/kernel/nsproxy.c
--- linux-work-clean/kernel/nsproxy.c	2007-01-26 16:53:49.000000000 +0100
+++ linux-work/kernel/nsproxy.c	2007-01-26 17:01:14.000000000 +0100
@@ -196,3 +196,8 @@ struct mnt_namespace *get_task_mnt_ns(st

 	return mnt_ns;
 }
+
+static inline struct nsproxy *preexit_task_namespaces(struct task_struct *p)
+{
+	return put_nsproxy(p->nsproxy);
+}

