Return-Path: <linux-kernel-owner+w=401wt.eu-S1754031AbXIYV70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031AbXIYV70 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 17:59:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751931AbXIYV7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 17:59:18 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:55750 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbXIYV7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 17:59:17 -0400
Subject: Re: 2.6.23-rc8-mm1 - powerpc memory hotplug link failure
From: Badari Pulavarty <pbadari@gmail.com>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       kamezawa.hiroyu@jp.fujitsu.com, Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
In-Reply-To: <46F968C2.7080900@linux.vnet.ibm.com>
References: <20070925014625.3cd5f896.akpm@linux-foundation.org>
	 <46F968C2.7080900@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Tue, 25 Sep 2007 15:01:54 -0700
Message-Id: <1190757715.13955.40.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-09-26 at 01:30 +0530, Kamalesh Babulal wrote:
> Hi Andrew,
> 
> The 2.6.23-rc8-mm1 kernel linking fails on the powerpc (P5+) box
> 
>   CC      init/version.o
>   LD      init/built-in.o
>   LD      .tmp_vmlinux1
> drivers/built-in.o: In function `memory_block_action':
> /root/scrap/linux-2.6.23-rc8/drivers/base/memory.c:188: undefined reference to `.remove_memory'
> make: *** [.tmp_vmlinux1] Error 1
> 

I ran into the same thing earlier. Here is the fix I made.

Thanks,
Badari

Memory hotplug remove is currently supported only on IA64

Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>

Index: linux-2.6.23-rc8/mm/Kconfig
===================================================================
--- linux-2.6.23-rc8.orig/mm/Kconfig	2007-09-25 14:44:03.000000000 -0700
+++ linux-2.6.23-rc8/mm/Kconfig	2007-09-25 14:44:48.000000000 -0700
@@ -143,6 +143,7 @@ config MEMORY_HOTREMOVE
 	bool "Allow for memory hot remove"
 	depends on MEMORY_HOTPLUG
 	depends on MIGRATION
+	depends on (IA64)
 
 # Heavily threaded applications may benefit from splitting the mm-wide
 # page_table_lock, so that faults on different parts of the user address


