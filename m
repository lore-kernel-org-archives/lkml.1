Return-Path: <linux-kernel-owner+w=401wt.eu-S1756975AbZAYE5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756975AbZAYE5y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 23:57:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755705AbZAYE5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 23:57:45 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:1410 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755683AbZAYE5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 23:57:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=dPfL6s4ItCtJrqSJDCoFlrSP9AxFO7DnUx7g1fkMgwOV0G8TXJ7cP7pbinc8Ig+svO
         rfhher8T0kGCeW6DS0Wc3K+PYamvCNhn5jLn4hjIwqyeSUdSkv66hDMl9Z2csUOoKPaB
         MqbuHMJdrJct2T9iQIB57tkKeslGaN6GgJAAA=
MIME-Version: 1.0
Date: Sun, 25 Jan 2009 10:27:43 +0530
Message-ID: <93655eb70901242057n7e0e3757p467f91352cbae932@mail.gmail.com>
Subject: building custom module on 2.6.28 fails
From: Satish Eerpini <eerpini@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

I tried to compile build the following sample kernel module on 2.6.28 :

______________________________________________________________________
#include <linux/module.h>
/* Defines the license for this LKM */
MODULE_LICENSE("GPL");
/* Init function called on module entry */

int my_module_init( void )
{
  printk(KERN_INFO "my_module_init called.  Module is now loaded.\n");
  return 0;
}

/* Cleanup function called on module exit */
void my_module_cleanup( void )
{
  printk(KERN_INFO "my_module_cleanup called.  Module is now unloaded.\n");
  return;
}

/* Declare entry and exit functions */
module_init( my_module_init );
module_exit( my_module_cleanup );
____________________________________________________________________

but it fails with the following error :

_____________________________________________________________________
make -C /lib/modules/`uname -r`/build
SUBDIRS=/home/satish/prog/kernel/modules modules
make[1]: Entering directory `/usr/src/kernels/linux-2.6.28'
  CC [M]  /home/satish/prog/kernel/modules/simple-mod.o
In file included from include/linux/gfp.h:4,
                 from include/linux/kmod.h:22,
                 from include/linux/module.h:13,
                 from /home/satish/prog/kernel/modules/simple-mod.c:1:
include/linux/mmzone.h:18:26: error: linux/bounds.h: No such file or directory
include/linux/mmzone.h:256:5: warning: "MAX_NR_ZONES" is not defined
In file included from include/linux/gfp.h:4,
                 from include/linux/kmod.h:22,
                 from include/linux/module.h:13,
                 from /home/satish/prog/kernel/modules/simple-mod.c:1:
include/linux/mmzone.h:277: error: 'MAX_NR_ZONES' undeclared here (not
in a function)
make[2]: *** [/home/satish/prog/kernel/modules/simple-mod.o] Error 1
make[1]: *** [_module_/home/satish/prog/kernel/modules] Error 2
make[1]: Leaving directory `/usr/src/kernels/linux-2.6.28'
make: *** [all] Error 2
__________________________________________________________________

any hints what could be wrong ?


Thanks
Satish

-- 
http://satish.playdrupal.com
