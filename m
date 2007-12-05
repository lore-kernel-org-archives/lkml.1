Return-Path: <linux-kernel-owner+w=401wt.eu-S1752969AbXLEDJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969AbXLEDJp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 22:09:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750937AbXLEDJg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 22:09:36 -0500
Received: from fmailhost02.isp.att.net ([207.115.11.52]:34546 "EHLO
	fmailhost02.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbXLEDJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 22:09:36 -0500
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Dec 2007 22:09:36 EST
X-Originating-IP: [74.227.55.164]
Date: Tue, 4 Dec 2007 21:04:33 -0600
From: Jay Cliburn <jacliburn@bellsouth.net>
To: sam@ravnborg.org
Cc: linux-kernel@vger.kernel.org
Subject: Allow (O=...) from file
Message-ID: <20071204210433.4d7ee66c@osprey.hogchain.net>
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam,

This piece of the top-level Makefile in current git causes an
out-of-tree driver Makefile to fail.

101 ifdef O
102   ifeq ("$(origin O)", "command line")
103     KBUILD_OUTPUT := $(O)
104   endif
105 endif

The out-of-tree driver Makefile contains an O=... directive that
(correctly) does _not_ specify the kernel source dir, and apparently
isn't overridden by the command line either. If in the above Makefile
snippet I change "command line" to "file", my out-of-tree make
succeeds. What do you think about allowing O= to come from a file in
addition to the command line?

Here are my attempts:

[jcliburn@osprey atl1-2.0.7-20071202]$ make
make -C /lib/modules/2.6.24-rc3/source O=/lib/modules/2.6.24-rc3/build SUBDIRS=/home/jcliburn/atl1/atl1-2.0.7-20071202 modules
make[1]: Entering directory `/home/jcliburn/kernel-work/netdev/netdev-2.6.git'
Makefile:119: *** Output directory (O=...) specifies kernel src dir.  Stop.
make[1]: Leaving directory `/home/jcliburn/kernel-work/netdev/netdev-2.6.git'
make: *** [default] Error 2

[jcliburn@osprey atl1-2.0.7-20071202]$ make O=/lib/modules/2.6.24-rc3/build
make -C /lib/modules/2.6.24-rc3/source O=/lib/modules/2.6.24-rc3/build SUBDIRS=/home/jcliburn/atl1/atl1-2.0.7-20071202 modules
make[1]: Entering directory `/home/jcliburn/kernel-work/netdev/netdev-2.6.git'
Makefile:119: *** Output directory (O=...) specifies kernel src dir.  Stop.
make[1]: Leaving directory `/home/jcliburn/kernel-work/netdev/netdev-2.6.git'
make: *** [default] Error 2

Thanks for your help.

Jay
