Return-Path: <linux-kernel-owner+w=401wt.eu-S1755780AbYARHji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755780AbYARHji (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 02:39:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752788AbYARHjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 02:39:31 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48683 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751519AbYARHja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 02:39:30 -0500
Date: Thu, 17 Jan 2008 23:38:53 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Sam Ravnborg <sam@ravnborg.org>,
       Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: 2.6.24-rc8-mm1 build failure on headers_check
Message-Id: <20080117233853.1b782123.akpm@linux-foundation.org>
In-Reply-To: <479050BF.1090107@linux.vnet.ibm.com>
References: <20080117023514.9df393cf.akpm@linux-foundation.org>
	<479050BF.1090107@linux.vnet.ibm.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jan 2008 12:39:51 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:

> Hi Andrew,
> 
> The kernel build fails during the headers_check on power box
> 
>   CHECK   include/asm/nvram.h
> /usr/local/autobench/autotest/tmp/build/linux/usr/include/asm/nvram.h requires linux/list.h, which does not exist in exported headers
> make[3]: *** [/usr/local/autobench/autotest/tmp/build/linux/usr/include/asm/.check.nvram.h] Error 1

doh.

--- a/include/asm-powerpc/nvram.h~include-asm-powerpc-nvramh-needs-listh-fix
+++ a/include/asm-powerpc/nvram.h
@@ -11,7 +11,6 @@
 #define _ASM_POWERPC_NVRAM_H
 
 #include <linux/errno.h>
-#include <linux/list.h>
 
 #define NVRW_CNT 0x20
 #define NVRAM_HEADER_LEN 16 /* sizeof(struct nvram_header) */
@@ -59,6 +58,9 @@ struct nvram_header {
 };
 
 #ifdef __KERNEL__
+
+#include <linux/list.h>
+
 struct nvram_partition {
 	struct list_head partition;
 	struct nvram_header header;
_

