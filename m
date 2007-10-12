Return-Path: <linux-kernel-owner+w=401wt.eu-S1760203AbXJLGsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760203AbXJLGsy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 02:48:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758574AbXJLGso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 02:48:44 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:17550 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757973AbXJLGsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 02:48:43 -0400
Message-ID: <470F18C3.1050208@fr.ibm.com>
Date: Fri, 12 Oct 2007 08:48:35 +0200
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: 2.6.23-mm1
References: <20071011213126.cf92efb7.akpm@linux-foundation.org> <20071012140328.f82af8e8.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20071012140328.f82af8e8.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Thu, 11 Oct 2007 21:31:26 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23/2.6.23-mm1/
>>
>> - I've been largely avoiding applying anything since rc8-mm2 in an attempt
>>   to stabilise things for the 2.6.23 merge.
>>
> On RHEL5/x86_64 environment,
> 
> ==
> [kamezawa@hannibal ref-2.6.23-mm1]$ make menuconfig
> Makefile:456: /home/kamezawa/ref-2.6.23-mm1/arch//Makefile: No such file or directory
> make: *** No rule to make target `/home/kamezawa/ref-2.6.23-mm1/arch//Makefile'.  Stop.
> ==
> 
> $(ARCH) cannot be detected automatically...
> 
> What information is useful for fixing this ?

cross compile work but native compile doesn't anymore :(

Here's a tmp fix.

Thanks,

C.

Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
---
 Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: 2.6.23-mm1/Makefile
===================================================================
--- 2.6.23-mm1.orig/Makefile
+++ 2.6.23-mm1/Makefile
@@ -191,7 +191,7 @@ SUBARCH := $(shell uname -m | sed -e s/i
 
 # The empty ARCH and CROSS_COMPILE statements exist so it is easy to
 # patch in hardcoded values for ARCH and CROSS_COMPILE
-ARCH           ?=
+ARCH           ?= $(SUBARCH)
 CROSS_COMPILE  ?=
 
 # Kbuild save the ARCH and CROSS_COMPILE setting in .kbuild



> 
> Thanks,
> -Kame
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

