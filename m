Return-Path: <linux-kernel-owner+w=401wt.eu-S1755403AbZHKScu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403AbZHKScu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 14:32:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754443AbZHKSct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 14:32:49 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:33440 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075AbZHKScs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 14:32:48 -0400
Date: Tue, 11 Aug 2009 11:31:31 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
       Felipe Balbi <felipe.balbi@nokia.com>, gregkh@suse.de
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>
Subject: [PATCH -next] usb/otg: fix twl4030-usb build
Message-Id: <20090811113131.44db4177.randy.dunlap@oracle.com>
In-Reply-To: <20090811183434.28afaf80.sfr@canb.auug.org.au>
References: <20090811183434.28afaf80.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt003.oracle.com [141.146.116.12]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010205.4A81B93D.0008:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

subsys_initcall_sync() is only defined for built-in code, not for
loadable modules, so this driver build fails when built as a module.
However, the _sync() forms of the initcalls are not implemented,
so this should not be used -- just use the non-sync form of it.

drivers/usb/otg/twl4030-usb.c:777: warning: data definition has no type or storage class
drivers/usb/otg/twl4030-usb.c:777: warning: type defaults to 'int' in declaration of 'subsys_initcall_sync'
drivers/usb/otg/twl4030-usb.c:777: warning: parameter names (without types) in function declaration

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Felipe Balbi <felipe.balbi@nokia.com>
---
 drivers/usb/otg/twl4030-usb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20090811.orig/drivers/usb/otg/twl4030-usb.c
+++ linux-next-20090811/drivers/usb/otg/twl4030-usb.c
@@ -774,7 +774,7 @@ static int __init twl4030_usb_init(void)
 {
 	return platform_driver_register(&twl4030_usb_driver);
 }
-subsys_initcall_sync(twl4030_usb_init);
+subsys_initcall(twl4030_usb_init);
 
 static void __exit twl4030_usb_exit(void)
 {



---
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
