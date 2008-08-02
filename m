Return-Path: <linux-kernel-owner+w=401wt.eu-S1756776AbYHBQDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776AbYHBQDw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 12:03:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751057AbYHBQDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 12:03:44 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:56294 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476AbYHBQDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 12:03:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:content-type:date:message-id
         :mime-version:x-mailer:content-transfer-encoding:sender;
        b=LnckKme75nrjDXfqcB1UdrYZ8asfJxdB2yGZNv1LEutnTT9JEBXAmtuLiffw6Xr1PJ
         e1DaSl6xaMJxNo+klXqdc6CoC0EgP8xHnfMyJqqVE7lrvyy/7wkUwBKGSqj+HctlnB1R
         u7hstgeFQtx88yi829Nn1D+gzr+k1KnNnyBNA=
Subject: Kconfig no longer outputs a .config with freshly updated defconfigs
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Reply-To: jwboyer@linux.vnet.ibm.com
To: sam@ravnborg.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Date: Sat, 02 Aug 2008 12:03:33 -0400
Message-Id: <1217693013.2328.22.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was going through the somewhat tedious task of updating the 4xx
defconfigs today, and I noticed some odd behavior from Kconfig.
Basically, I would do:

	make ppc44x_defconfig
	make oldconfig
	<build>
	cp .config arch/powerpc/configs/ppc44x_defconfig
	make distclean

I did this for a number of configs.  Then I went back and tried to build
ppc44x_defconfig again and I got this result:

[jwboyer@localhost linux-2.6]$ make ppc44x_defconfig
  HOSTCC  scripts/basic/fixdep
  HOSTCC  scripts/basic/docproc
  HOSTCC  scripts/kconfig/conf.o
  HOSTCC  scripts/kconfig/kxgettext.o
  SHIPPED scripts/kconfig/zconf.tab.c
  SHIPPED scripts/kconfig/lex.zconf.c
  SHIPPED scripts/kconfig/zconf.hash.c
  HOSTCC  scripts/kconfig/zconf.tab.o
scripts/kconfig/lex.zconf.c:1628: warning: ‘input’ defined but not used
  HOSTLD  scripts/kconfig/conf
[jwboyer@localhost linux-2.6]$ make oldconfig
scripts/kconfig/conf -o arch/powerpc/Kconfig
#
# using defaults found in /boot/config-2.6.25.13-104.fc9.ppc64
#

There was no .config file present after the initial 'make
ppc44x_defconfig', so it defaulted to using something in /boot.  I'm a
bit baffled here, but that seems to be common to any newly updated
defconfig I've done.

Was there a change to Kconfig recently that won't copy the defconfig
file to .config if there are no symbol changes or something like that?

josh

