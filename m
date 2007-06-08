Return-Path: <linux-kernel-owner+w=401wt.eu-S969878AbXFHQ0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969878AbXFHQ0k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 12:26:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968241AbXFHQ01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 12:26:27 -0400
Received: from co202.xi-lite.net ([149.6.83.202]:33906 "EHLO
	toronto.xi-lite.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756433AbXFHQ00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 12:26:26 -0400
X-Greylist: delayed 1510 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Jun 2007 12:26:25 EDT
Message-ID: <46697C5E.9060607@parrot.com>
Date: Fri, 08 Jun 2007 17:57:18 +0200
From: Matthieu CASTET <matthieu.castet@parrot.com>
User-Agent: IceDove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Tom <fivemiletom@gmail.com>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: RE : Building kernel 2.6.21.3 for arm on cygwin
References: <4660971E.5020609@gmail.com>	<12D4B80525C5B744A216276E209921D9CE8016@MIAMI.xi-lite.lan>	<46645DC9.8080003@gmail.com> <20070607204707.GB16634@uranus.ravnborg.org>
In-Reply-To: <20070607204707.GB16634@uranus.ravnborg.org>
Content-Type: multipart/mixed;
 boundary="------------060907090109000805030703"
X-OriginalArrivalTime: 08 Jun 2007 15:59:47.0297 (UTC) FILETIME=[09A8AD10:01C7A9E6]
X-AV-Checked: No Virus Found
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060907090109000805030703
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

Hi,

Sam Ravnborg a écrit :
> On Mon, Jun 04, 2007 at 11:45:29AM -0700, Tom wrote:
>> Hi Sam
>>
>>
>> enclosed is the 'k_smf.patch' which modifies three files to enable the 
>> kernel 2.6.21.3 to be built under cygwin:
>> host:  cygwin 1.5.24, hostcc= gcc 3.4.4
>> cross: arm-linux-uclibcgnueabi-gcc (GCC) 4.1.2
>> cmd:   make ARCH=arm CROSS_COMPILE=arm-linux- \
>>        HOST_LOADLIBES="-lcurses -lintl" at91rm9200dk_defconfig
>>
>> I verified that this does not break building on a linux-host on this config:
>> host:  FC5, gcc 4.1.1-1
>> cross: arm-none-linux-gnueabi-gcc 4.1.1
>> cmd:   make ARCH=arm CROSS_COMPILE=arm-none-linux-gnueabi-
>>
>>
>> Let me know if I can help any further.
> Hi Tom.
> 
> Patch looks good. The last bit touching sumversion.c is not
> needed in latest kernel - we already include limits.h.
> 
What about something like that for ncurses stuff ?


Matthieu

--------------060907090109000805030703
Content-Type: text/x-patch;
 name="cygwin.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="cygwin.patch"

Index: scripts/kconfig/Makefile
===================================================================
RCS file: /soft/cvs/Linux/kernel/linux/scripts/kconfig/Makefile,v
retrieving revision 1.1.1.1
retrieving revision 1.2
diff -u -r1.1.1.1 -r1.2
--- scripts/kconfig/Makefile	5 Mar 2007 13:02:59 -0000	1.1.1.1
+++ scripts/kconfig/Makefile	6 Mar 2007 10:08:36 -0000	1.2
@@ -148,6 +148,13 @@
      else echo no ; fi)
 ifeq ($(KBUILD_HAVE_NLS),no)
 HOSTCFLAGS	+= -DKBUILD_NO_NLS
+else
+HOST_OS := $(shell uname -o)
+ifeq ($(HOST_OS),Cygwin)
+HOSTLOADLIBES_conf	= -lintl
+endif
+
+
 endif
 
 # generated files seem to need this to find local include files
Index: scripts/kconfig/lxdialog/check-lxdialog.sh
===================================================================
RCS file: /soft/cvs/Linux/kernel/linux/scripts/kconfig/lxdialog/check-lxdialog.sh,v
retrieving revision 1.1.1.1
retrieving revision 1.2
diff -u -r1.1.1.1 -r1.2
--- scripts/kconfig/lxdialog/check-lxdialog.sh	5 Mar 2007 13:02:59 -0000	1.1.1.1
+++ scripts/kconfig/lxdialog/check-lxdialog.sh	6 Mar 2007 10:08:36 -0000	1.2
@@ -19,6 +19,11 @@
 		echo '-lcurses'
 		exit
 	fi
+	$cc -print-file-name=libncurses.a | grep -q /
+	if [ $? -eq 0 ]; then
+		echo '-lintl -lncurses'
+		exit
+	fi
 	exit 1
 }
 

--------------060907090109000805030703--
