Return-Path: <linux-kernel-owner+w=401wt.eu-S1755630AbXLKBYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755630AbXLKBYR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 20:24:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752119AbXLKBYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 20:24:08 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:43758 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751613AbXLKBYG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 20:24:06 -0500
Date: Mon, 10 Dec 2007 20:24:01 -0500
From: Amos Waterland <apw@us.ibm.com>
To: akpm@osdl.org
Cc: horms@verge.net.au, linux-kernel@vger.kernel.org, andi@firstfloor.org
Subject: [PATCH] Updates to nfsroot documentation (take 3)
Message-ID: <20071211012401.GA25642@us.ibm.com>
References: <20071205045932.GA7160@us.ibm.com> <p73k5ntjsw7.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p73k5ntjsw7.fsf@bingen.suse.de>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The difference between ip=off and ip=::::::off has been a cause of much
confusion.  Document how each behaves, and do not contradict ourselves
by saying that "off" is the default when in fact "any" is the default
and is descibed as being so lower in the file.

Signed-off-by: Amos Waterland <apw@us.ibm.com>

 Documentation/nfsroot.txt |   12 +++++++++---
 net/ipv4/ipconfig.c       |   20 +-------------------
 2 files changed, 10 insertions(+), 22 deletions(-)

diff --git a/Documentation/nfsroot.txt b/Documentation/nfsroot.txt
index 16a7cae..0e87890 100644
--- a/Documentation/nfsroot.txt
+++ b/Documentation/nfsroot.txt
@@ -92,8 +92,14 @@ ip=<client-ip>:<server-ip>:<gw-ip>:<netmask>:<hostname>:<device>:<autoconf>
   autoconfiguration.
 
   The <autoconf> parameter can appear alone as the value to the `ip'
-  parameter (without all the ':' characters before) in which case auto-
-  configuration is used.
+  parameter (without all the ':' characters before).  If the value is
+  "ip=off" or "ip=none", no autoconfiguration will take place, otherwise
+  autoconfiguration will take place.  The most common way to use this 
+  is "ip=dhcp".
+
+  Note that "ip=off" is not the same thing as "ip=::::::off", because in 
+  the latter autoconfiguration will take place if any of DHCP, BOOTP or RARP
+  are compiled in the kernel.
 
   <client-ip>	IP address of the client.
 
@@ -142,7 +148,7 @@ ip=<client-ip>:<server-ip>:<gw-ip>:<netmask>:<hostname>:<device>:<autoconf>
 		into the kernel will be used, regardless of the value of
 		this option.
 
-                  off or none: don't use autoconfiguration (default)
+                  off or none: don't use autoconfiguration
 		  on or any:   use any protocol available in the kernel
 		  dhcp:        use DHCP
 		  bootp:       use BOOTP
diff --git a/net/ipv4/ipconfig.c b/net/ipv4/ipconfig.c
index c5c107a..96400b0 100644
--- a/net/ipv4/ipconfig.c
+++ b/net/ipv4/ipconfig.c
@@ -1396,25 +1396,7 @@ late_initcall(ip_auto_config);
 
 /*
  *  Decode any IP configuration options in the "ip=" or "nfsaddrs=" kernel
- *  command line parameter. It consists of option fields separated by colons in
- *  the following order:
- *
- *  <client-ip>:<server-ip>:<gw-ip>:<netmask>:<host name>:<device>:<PROTO>
- *
- *  Any of the fields can be empty which means to use a default value:
- *	<client-ip>	- address given by BOOTP or RARP
- *	<server-ip>	- address of host returning BOOTP or RARP packet
- *	<gw-ip>		- none, or the address returned by BOOTP
- *	<netmask>	- automatically determined from <client-ip>, or the
- *			  one returned by BOOTP
- *	<host name>	- <client-ip> in ASCII notation, or the name returned
- *			  by BOOTP
- *	<device>	- use all available devices
- *	<PROTO>:
- *	   off|none	    - don't do autoconfig at all (DEFAULT)
- *	   on|any           - use any configured protocol
- *	   dhcp|bootp|rarp  - use only the specified protocol
- *	   both             - use both BOOTP and RARP (not DHCP)
+ *  command line parameter.  See Documentation/nfsroot.txt.
  */
 static int __init ic_proto_name(char *name)
 {
