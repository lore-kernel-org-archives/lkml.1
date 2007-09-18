Return-Path: <linux-kernel-owner+w=401wt.eu-S1756673AbXIRJ14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673AbXIRJ14 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 05:27:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754253AbXIRJ1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 05:27:47 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47198 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754265AbXIRJ1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 05:27:46 -0400
Date: Tue, 18 Sep 2007 02:27:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: 2.6.23-rc6-mm1
Message-Id: <20070918022739.f25c2846.akpm@linux-foundation.org>
In-Reply-To: <46EF96CC.1080807@linux.vnet.ibm.com>
References: <20070918011841.2381bd93.akpm@linux-foundation.org>
	<46EF96CC.1080807@linux.vnet.ibm.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Sep 2007 14:43:48 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:

> Andrew Morton wrote:
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc6/2.6.23-rc6-mm1/
> >
> > 2.6.23-rc6-mm1 is a 29MB diff against 2.6.23-rc6.
> >
> >   
> <snip>
> 
> Hi Andrew,
> 
> The 2.6.23-rc6-mm1build fails at
> 
>   CC      drivers/pci/hotplug/rpadlpar_core.o
>   CC      drivers/pci/hotplug/rpadlpar_sysfs.o
> drivers/pci/hotplug/rpadlpar_sysfs.c:132: error: unknown field `name' specified in initializer
> drivers/pci/hotplug/rpadlpar_sysfs.c: In function `dlpar_sysfs_init':
> drivers/pci/hotplug/rpadlpar_sysfs.c:142: error: structure has no member named `name'
> make[3]: *** [drivers/pci/hotplug/rpadlpar_sysfs.o] Error 1
> make[2]: *** [drivers/pci/hotplug] Error 2
> make[1]: *** [drivers/pci] Error 2
> make: *** [drivers] Error 2
> 

Probably this:

--- a/drivers/pci/hotplug/rpadlpar_sysfs.c~a
+++ a/drivers/pci/hotplug/rpadlpar_sysfs.c
@@ -129,8 +129,7 @@ struct kobj_type ktype_dlpar_io = {
 };
 
 struct kset dlpar_io_kset = {
-	.kobj = {.name = DLPAR_KOBJ_NAME,
-		 .ktype = &ktype_dlpar_io,
+	.kobj = {.ktype = &ktype_dlpar_io,
 		 .parent = &pci_hotplug_slots_subsys.kobj},
 	.ktype = &ktype_dlpar_io,
 };
_

But I'm fed up with fixing that patch.  It's Greg's turn.
