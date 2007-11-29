Return-Path: <linux-kernel-owner+w=401wt.eu-S1757179AbXK2K3B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757179AbXK2K3B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 05:29:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751191AbXK2K2v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 05:28:51 -0500
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:61224 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbXK2K2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 05:28:50 -0500
Message-ID: <474E943F.40804@fr.ibm.com>
Date: Thu, 29 Nov 2007 11:28:15 +0100
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Pavel Emelyanov <xemul@openvz.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [patch -mm 2/4] mqueue namespace : add unshare support
References: <20071128163728.177495768@fr.ibm.com>> <20071128164349.196734045@fr.ibm.com>> <474DA61B.5030301@openvz.org>
In-Reply-To: <474DA61B.5030301@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>> Index: 2.6.24-rc3-mm2/kernel/fork.c
>> ===================================================================
>> --- 2.6.24-rc3-mm2.orig/kernel/fork.c
>> +++ 2.6.24-rc3-mm2/kernel/fork.c
>> @@ -1004,6 +1004,13 @@ static struct task_struct *copy_process(
>>  	if ((clone_flags & CLONE_SIGHAND) && !(clone_flags & CLONE_VM))
>>  		return ERR_PTR(-EINVAL);
>>  
>> +	/*
>> +	 * mount namespace cannot be unshared when the mqueue
>> +	 * namespace is not
> 
> vice versa - mqueue namespace cannot be unshared when the mount one is not ;)

arg. yes :) 

Thanks !

C.


Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
---
 kernel/fork.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: 2.6.24-rc3-mm2/kernel/fork.c
===================================================================
--- 2.6.24-rc3-mm2.orig/kernel/fork.c
+++ 2.6.24-rc3-mm2/kernel/fork.c
@@ -1005,7 +1005,7 @@ static struct task_struct *copy_process(
                return ERR_PTR(-EINVAL);
 
        /*
-        * mount namespace cannot be unshared when the mqueue
+        * mqueue namespace cannot be unshared when the mount
         * namespace is not
         */
        if ((clone_flags & CLONE_NEWMQ) && !(clone_flags & CLONE_NEWNS))

