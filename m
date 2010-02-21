Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122Ab0BUSK7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 13:10:59 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:44629 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010Ab0BUSK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 13:10:58 -0500
Message-ID: <4B8176CC.40506@oracle.com>
Date: Sun, 21 Feb 2010 10:09:16 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
CC: Joel Becker <joel.becker@oracle.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] Re: How to disable configfs_example modules
References: <1266765484.2192.5.camel@localhost>
In-Reply-To: <1266765484.2192.5.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4B817729.0054:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/10 07:18, Jaswinder Singh Rajput wrote:
> Hello Randy,

Hi Jaswinder,

> I am trying to build no modules but unfortunately I am getting 3 modules
> with http://userweb.kernel.org/~jaswinder/Corei7/config-i7-64.txt :
> 
>   INSTALL Documentation/filesystems/configfs/configfs_example_explicit.ko
>   INSTALL Documentation/filesystems/configfs/configfs_example_macros.ko
>   INSTALL drivers/scsi/scsi_wait_scan.ko
> 
> How can I get rid of configfs_example modules.
> 
> What is the magic in 'ifneq ($(CONFIG_CONFIGFS_FS),)' :

That just says: if CONFIG_CONFIGFS_FS neq empty_string
  [where the empty_string is between the ",)"]

> Documentation/filesystems/configfs/Makefile :
> ifneq ($(CONFIG_CONFIGFS_FS),)
> obj-m += configfs_example_explicit.o configfs_example_macros.o
> endif


I think that this patch will do it.  Please let me know if it
does not work.

---
From: Randy Dunlap <randy.dunlap@oracle.com>

Documentation/ source files that are kernel modules should
not be built when CONFIG_MODULES is not enabled, so change
the Makefile to enforce that.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/filesystems/configfs/Makefile |    2 ++
 1 file changed, 2 insertions(+)

--- lnx-2633-rc8.orig/Documentation/filesystems/configfs/Makefile
+++ lnx-2633-rc8/Documentation/filesystems/configfs/Makefile
@@ -1,3 +1,5 @@
+ifeq ($(CONFIG_MODULES),1)
 ifneq ($(CONFIG_CONFIGFS_FS),)
 obj-m += configfs_example_explicit.o configfs_example_macros.o
 endif
+endif
