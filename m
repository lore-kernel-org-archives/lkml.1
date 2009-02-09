Return-Path: <linux-kernel-owner+w=401wt.eu-S1755419AbZBIVtd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419AbZBIVtd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 16:49:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752700AbZBIVtY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 16:49:24 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:36515 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090AbZBIVtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 16:49:23 -0500
Message-ID: <4990A4ED.7020901@oracle.com>
Date: Mon, 09 Feb 2009 13:49:33 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Mike Frysinger <vapier.adi@gmail.com>
CC: James Morris <jmorris@namei.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, Serge Hallyn <serue@us.ibm.com>
Subject: Re: ima changes to shmem breaks !CONFIG_SHMEM
References: <8bd0f97a0902090830y11965ayc436fc1157510764@mail.gmail.com>	 <alpine.LRH.1.10.0902100823170.1282@tundra.namei.org> <8bd0f97a0902091327m3a71bf4ex46a391436481032d@mail.gmail.com>
In-Reply-To: <8bd0f97a0902091327m3a71bf4ex46a391436481032d@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt705.oracle.com [141.146.40.83]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4990A4D8.028B:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger wrote:
> On Mon, Feb 9, 2009 at 16:23, James Morris wrote:
>> On Mon, 9 Feb 2009, Mike Frysinger wrote:
>>> commit 1df9f0a73178718969ae47d813b8e7aab2cf073c broke default building
>>> for Blackfin systems:
>>>   CC      mm/shmem.o
>>> mm/shmem.c: In function 'shmem_zero_setup':
>>> mm/shmem.c:2670: error: implicit declaration of function 'ima_shm_check'
>>> make[1]: *** [mm/shmem.o] Error 1
>>>
>>> that's because the ima.h include was added behind the CONFIG_SHMEM
>>> markings rather than everywhere, just like the function is used.
>> Does this seem like the correct fix?
> 
> it converts the build error to a build warning:
>   CC      mm/shmem.o
> In file included from mm/shmem.c:32:
> include/linux/ima.h:25: warning: 'struct linux_binprm' declared inside
> parameter list
> include/linux/ima.h:25: warning: its scope is only this definition or
> declaration, which is probably not what you want

Add to the other patch:

--- linux-next-20090209.orig/include/linux/ima.h
+++ linux-next-20090209/include/linux/ima.h
@@ -8,6 +8,7 @@
  */
 
 #include <linux/fs.h>
+struct linux_binprm;
 
 #ifndef _LINUX_IMA_H
 #define _LINUX_IMA_H



and it builds for me.

-- 
~Randy
