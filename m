Return-Path: <linux-kernel-owner+w=401wt.eu-S1755553AbZBIVYK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553AbZBIVYK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 16:24:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754103AbZBIVX4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 16:23:56 -0500
Received: from tundra.namei.org ([65.99.196.166]:2210 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754091AbZBIVX4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 16:23:56 -0500
Date: Tue, 10 Feb 2009 08:23:49 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Mike Frysinger <vapier.adi@gmail.com>
cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Serge Hallyn <serue@us.ibm.com>
Subject: Re: ima changes to shmem breaks !CONFIG_SHMEM
In-Reply-To: <8bd0f97a0902090830y11965ayc436fc1157510764@mail.gmail.com>
Message-ID: <alpine.LRH.1.10.0902100823170.1282@tundra.namei.org>
References: <8bd0f97a0902090830y11965ayc436fc1157510764@mail.gmail.com>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Feb 2009, Mike Frysinger wrote:

> commit 1df9f0a73178718969ae47d813b8e7aab2cf073c broke default building
> for Blackfin systems:
>   CC      mm/shmem.o
> mm/shmem.c: In function 'shmem_zero_setup':
> mm/shmem.c:2670: error: implicit declaration of function 'ima_shm_check'
> make[1]: *** [mm/shmem.o] Error 1
> 
> that's because the ima.h include was added behind the CONFIG_SHMEM
> markings rather than everywhere, just like the function is used.

Does this seem like the correct fix?

--- 

diff --git a/mm/shmem.c b/mm/shmem.c
index 7519988..8135fac 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -28,6 +28,7 @@
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/swap.h>
+#include <linux/ima.h>
 
 static struct vfsmount *shm_mnt;
 
@@ -59,7 +60,6 @@ static struct vfsmount *shm_mnt;
 #include <linux/highmem.h>
 #include <linux/seq_file.h>
 #include <linux/magic.h>
-#include <linux/ima.h>
 
 #include <asm/uaccess.h>
 #include <asm/div64.h>


