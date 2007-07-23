Return-Path: <linux-kernel-owner+w=401wt.eu-S1765906AbXGWXk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765906AbXGWXk1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 19:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757958AbXGWXkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 19:40:15 -0400
Received: from mga09.intel.com ([134.134.136.24]:11018 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753301AbXGWXkN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 19:40:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,572,1175497200"; 
   d="scan'208";a="109113522"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: __unsafe() usage
Date: Mon, 23 Jul 2007 16:40:10 -0700
Message-ID: <BAE9DCEF64577A439B3A37F36F9B691C02BBDE39@orsmsx418.amr.corp.intel.com>
In-Reply-To: <1185232601.1803.41.camel@localhost.localdomain>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: __unsafe() usage
Thread-Index: AcfNf5ltZ/kIh2ZTQmyfgfFUAAlMygAAhDWg
From: "Nelson, Shannon" <shannon.nelson@intel.com>
To: "Rusty Russell" <rusty@rustcorp.com.au>, "Adrian Bunk" <bunk@stusta.de>
Cc: "Gabriel C" <nix.or.die@googlemail.com>,
       "lkml" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       <lksctp-developers@lists.sourceforge.net>,
       "Williams, Dan J" <dan.j.williams@intel.com>
X-OriginalArrivalTime: 23 Jul 2007 23:40:11.0061 (UTC) FILETIME=[CF4B4E50:01C7CD82]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell [mailto:rusty@rustcorp.com.au] 
>> If this is true, and since the MOD_INC_USE_COUNT compat code is long 
>> gone, shouldn't we be able to completely remove __unsafe() and the 
>> struct member "unsafe"?
>
>Yes, indeed, something like this:
>==
>Remove "unsafe" from module struct
>
>Adrian Bunk points out that "unsafe" was used to mark modules 
>touched by
>the deprecated MOD_INC_USE_COUNT interface, which has long gone.  It's
>time to remove the member from the module structure, as well.
>
>If you want a module which can't unload, don't register an exit
>function.
>
>Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
>
>diff -r d7af727512fd drivers/dma/ioatdma.c
>--- a/drivers/dma/ioatdma.c	Tue Jul 24 08:30:05 2007 +1000
>+++ b/drivers/dma/ioatdma.c	Tue Jul 24 09:11:11 2007 +1000
>@@ -811,18 +811,17 @@ MODULE_AUTHOR("Intel Corporation");
> 
> static int __init ioat_init_module(void)
> {
>-	/* it's currently unsafe to unload this module */
>-	/* if forced, worst case is that rmmod hangs */
>-	__unsafe(THIS_MODULE);
>-
> 	return pci_register_driver(&ioat_pci_driver);
> }
> 
> module_init(ioat_init_module);
> 
>+/* it's currently unsafe to unload this module */
>+#if 0
> static void __exit ioat_exit_module(void)
> {
> 	pci_unregister_driver(&ioat_pci_driver);
> }
> 
> module_exit(ioat_exit_module);
>+#endif


Acked-by: Shannon Nelson <shannon.nelson@intel.com>
