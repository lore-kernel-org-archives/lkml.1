Return-Path: <linux-kernel-owner+w=401wt.eu-S1758979AbXIXMtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758979AbXIXMtc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 08:49:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757268AbXIXMtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 08:49:10 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:43192 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756590AbXIXMtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 08:49:08 -0400
Message-ID: <46F7B23D.7080101@fr.ibm.com>
Date: Mon, 24 Sep 2007 14:49:01 +0200
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Andy Whitcroft <apw@shadowen.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
       linux-s390@vger.kernel.org, David Rientjes <rientjes@google.com>
Subject: Re: 2.6.23-rc7-mm1 -- s390 compile failures
References: <20070924021716.9bfe7dfb.akpm@linux-foundation.org> <20070924123207.GB30855@shadowen.org>
In-Reply-To: <20070924123207.GB30855@shadowen.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Whitcroft wrote:
> Getting compile errors on S390:
> 
>     CC      arch/s390/mm/cmm.o
>   arch/s390/mm/cmm.c: In function `cmm_init':
>   arch/s390/mm/cmm.c:431: error: implicit declaration of function
>   				`register_oom_notifier'
>   arch/s390/mm/cmm.c:443: error: implicit declaration of function
>   				`unregister_oom_notifier'
>   make[1]: *** [arch/s390/mm/cmm.o] Error 1
>   make: *** [arch/s390/mm] Error 2

yes. It's from oom-move-prototypes-to-appropriate-header-file.patch.

I think this patch fixes it.

C.

Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
---
 arch/s390/mm/cmm.c |    1 +
 1 file changed, 1 insertion(+)

Index: 2.6.23-rc7-mm1/arch/s390/mm/cmm.c
===================================================================
--- 2.6.23-rc7-mm1.orig/arch/s390/mm/cmm.c
+++ 2.6.23-rc7-mm1/arch/s390/mm/cmm.c
@@ -17,6 +17,7 @@
 #include <linux/ctype.h>
 #include <linux/swap.h>
 #include <linux/kthread.h>
+#include <linux/oom.h>
 
 #include <asm/pgalloc.h>
 #include <asm/uaccess.h>
