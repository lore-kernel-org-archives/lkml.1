Return-Path: <linux-kernel-owner+w=401wt.eu-S1764011AbZFOQes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764011AbZFOQes (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 12:34:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762839AbZFOQeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 12:34:31 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:48912 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761717AbZFOQeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 12:34:31 -0400
Message-ID: <4A367744.2050207@oracle.com>
Date: Mon, 15 Jun 2009 09:31:00 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jiri Slaby <jirislaby@gmail.com>
CC: samr <sam@ravnborg.org>
Subject: kbuild docs regression
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt010.oracle.com [141.146.116.19]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4A36780F.015D:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

make htmldocs
without using "O=dir" now (as of 2.6.30-git8) fails with

  HOSTCC  scripts/basic/fixdep
  HOSTCC  scripts/basic/docproc
  HOSTCC  scripts/basic/hash
  DOCPROC Documentation/DocBook/alsa-driver-api.xml
  DOCPROC Documentation/DocBook/debugobjects.xml
exec /scripts/kernel-doc: No such file or directory
exec /scripts/kernel-doc: No such file or directory
make[1]: *** [Documentation/DocBook/debugobjects.xml] Error 1
make[1]: *** Waiting for unfinished jobs....
  DOCPROC Documentation/DocBook/deviceiobook.xml
  DOCPROC Documentation/DocBook/device-drivers.xml
exec /scripts/kernel-doc: No such file or directory
exec /scripts/kernel-doc: No such file or directory
exec /scripts/kernel-doc: No such file or directory
exec /scripts/kernel-doc: No such file or directory
exec /scripts/kernel-doc: No such file or directory
exec /scripts/kernel-doc: No such file or directory
exec /scripts/kernel-doc: No such file or directory
exec /scripts/kernel-doc: No such file or directory
exec /scripts/kernel-doc: No such file or directory
exec /scripts/kernel-doc: No such file or directory
exec /scripts/kernel-doc: No such file or directory
make[1]: *** [Documentation/DocBook/deviceiobook.xml] Error 1

(+ more)

Using V=1 shows that SRCTREE is set but KBUILD_SRC is not set:


make -f scripts/Makefile.build obj=scripts/basic
make -f scripts/Makefile.build obj=Documentation/DocBook htmldocs
  SRCTREE=/lnx/src/TMP/linux-2.6.30-git8/ /lnx/src/TMP/linux-2.6.30-git8/scripts/basic/docproc doc Documentation/DocBook/alsa-driver-api.tmpl >Documentation/DocBook/alsa-driver-api.xml
exec /scripts/kernel-doc: No such file or directory

and one additional fprintf() in docproc.c shows that kernsrctree is empty:

docproc: srctree='/lnx/src/TMP/linux-2.6.30-git8/', kernsrctree=''



-- 
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
