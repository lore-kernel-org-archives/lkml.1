Return-Path: <linux-kernel-owner+w=401wt.eu-S1756790AbXL3ULt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790AbXL3ULt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 15:11:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751033AbXL3ULl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 15:11:41 -0500
Received: from fmmailgate05.web.de ([217.72.192.243]:64993 "EHLO
	fmmailgate05.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946AbXL3ULl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 15:11:41 -0500
Date: Sun, 30 Dec 2007 21:11:40 +0100
Message-Id: <77171111@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: linux-kernel@vger.kernel.org
Subject: allmodconfig:  udev won`t start due to CONFIG_UNIX=m
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX19gs0mV9EMgX6AtF2lAujD30VI8l0012gCajQM+lFo95dmUi
 m+404h5VQ5SlCBK13w9xEPOu5lig88s/xtJSjLnJTErPTJGmkA=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi !

i build a kernel with allmodconfig and didn`t get my system to boot with that.

after some investigation i found that it was due to udev:

udevd[1226]: init_udev_socket: error getting socket: Address family not supported by protocol 

this was missing support UNIX DOMAIN SOCKETS at boot time.
easy - so i added unix.ko to my initrd.

but that didn`t make a difference. Still same error with udev.

seems, there are others who stepped into this trap and someone telling, unix domain sockets cannot be modular
https://forums.gentoo.org/viewtopic-t-476363-highlight-.html
https://forums.gentoo.org/viewtopic-t-463793-highlight-.html


since we have 1206 options set to "Y" anyway, would it make sense to remove module support for Unix Domain Sockets ?
opensuse103:/home/kernel/linux-2.6.23 # cat .config.allmodconfig |grep "=y" |wc -l
1206
opensuse103:/home/kernel/linux-2.6.23 # cat .config.allmodconfig |grep "=m" |wc -l
2098

i also came across this one:

http://readlist.com/lists/vger.kernel.org/linux-kernel/41/205717.html






______________________________________________________________________
XXL-Speicher, PC-Virenschutz, Spartarife & mehr: Nur im WEB.DE Club!		
Jetzt testen! http://produkte.web.de/club/?mc=021130

