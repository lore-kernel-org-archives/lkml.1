Return-Path: <linux-kernel-owner+w=401wt.eu-S1756599AbYCKMMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756599AbYCKMMx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 08:12:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753433AbYCKMMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 08:12:46 -0400
Received: from mail.zelnet.ru ([80.92.97.13]:57321 "EHLO mail.zelnet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997AbYCKMMq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 08:12:46 -0400
X-Greylist: delayed 3601 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Mar 2008 08:12:45 EDT
Message-ID: <47D66576.6030108@gmail.com>
Date: Tue, 11 Mar 2008 13:56:54 +0300
From: Edward Shishkin <edward.shishkin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060411
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       reiserfs-devel@vger.kernel.org, apw@shadowen.org,
       balbir@linux.vnet.ibm.com
Subject: Re: [Build Faliure] 2.6.25-rc5-mm1 build fails
References: <20080311011434.ad8c8d7d.akpm@linux-foundation.org> <20080311101630.GA23757@linux.vnet.ibm.com>
In-Reply-To: <20080311101630.GA23757@linux.vnet.ibm.com>
X-Enigmail-Version: 0.86.0.0
X-Enigmail-Supports: pgp-inline, pgp-mime
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wow, kgdb is enabled again..

Thanks!
Edward

Kamalesh Babulal wrote:

>Hi Andrew,
>
>The 2.6.25-rc5-mm1 kernel build fails with allyesconfig
>
>  LD      .tmp_vmlinux1
>fs/built-in.o: In function `reiser4_debugtrap':
>/root/kernels/linux-2.6.25-rc5/fs/reiser4/debug.c:295: undefined reference to `breakpoint'
>make: *** [.tmp_vmlinux1] Error 1
>
>This build failure has been introduced by reiser4.patch, i think the
>breakpoint() have been used instead of kgdb_breakpoint().
>
>
>--- linux-2.6.25-rc5/fs/reiser4/debug.c	2008-03-11 22:12:45.000000000 +0530
>+++ linux-2.6.25-rc5/fs/reiser4/~debug.c	2008-03-11 23:14:54.000000000 +0530
>@@ -291,8 +291,8 @@ void reiser4_debugtrap(void)
> {
> 	/* do nothing. Put break point here. */
> #if defined(CONFIG_KGDB) && !defined(CONFIG_REISER4_FS_MODULE)
>-	extern void breakpoint(void);
>-	breakpoint();
>+	extern void kgdb_breakpoint(void);
>+	kgdb_breakpoint();
> #endif
> }
> #endif
>  
>

