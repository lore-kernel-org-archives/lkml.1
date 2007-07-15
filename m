Return-Path: <linux-kernel-owner+w=401wt.eu-S1755755AbXGODDF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755755AbXGODDF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 23:03:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751440AbXGODCy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 23:02:54 -0400
Received: from perninha.conectiva.com.br ([200.140.247.100]:53229 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350AbXGODCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 23:02:54 -0400
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Organization: Mandriva
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] Include serial_reg.h with userspace headers
Date: Sun, 15 Jul 2007 00:02:39 -0300
User-Agent: KMail/1.9.6
Cc: Gustavo de Nardin <gustavodn@mandriva.com.br>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200707150002.39321.herton@mandriva.com.br>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

As reported by Gustavo de Nardin <gustavodn@mandriva.com.br>, while trying to 
compile xosview (http://xosview.sourceforge.net/) with upstream kernel 
headers being used you get the following errors:
serialmeter.cc:48:30: error: linux/serial_reg.h: No such file or directory
serialmeter.cc: In member function 'virtual void 
SerialMeter::checkResources()':
serialmeter.cc:71: error: 'UART_LSR' was not declared in this scope
serialmeter.cc:71: error: 'UART_MSR' was not declared in this scope
...

I don't know if it's right to provide serial_reg.h with userspace headers, may 
be serial_reg.h isn't included for some reason. But if it's ok, the following 
patch adds serial_reg.h to be installed with user space kernel headers:

=================================================

  Add serial_reg.h to userspace kernel headers

  Include serial_reg.h in kernel headers for user space, it is at least
  needed for one program, xosview.

  Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>

diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index 127d2d1..eba0ccb 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -137,6 +137,7 @@ header-y += radeonfb.h
 header-y += raw.h
 header-y += resource.h
 header-y += rose.h
+header-y += serial_reg.h
 header-y += smbno.h
 header-y += snmp.h
 header-y += sockios.h

--
[]'s
Herton.
