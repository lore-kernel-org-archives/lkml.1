Return-Path: <linux-kernel-owner+w=401wt.eu-S1756442AbZCEWkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756442AbZCEWkh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 17:40:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753566AbZCEWk2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 17:40:28 -0500
Received: from fifo99.com ([67.223.236.141]:60051 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753162AbZCEWk2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 17:40:28 -0500
Subject: Re: [tip:x86/doc] x86/doc: mini-howto for using earlyprintk=dbgp
From: Daniel Walker <dwalker@fifo99.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       stern@rowland.harvard.edu, randy.dunlap@oracle.com,
       ebiederm@xmission.com, akpm@linux-foundation.org, gregkh@suse.de,
       tglx@linutronix.de, sarah.a.sharp@intel.com, mingo@elte.hu,
       linux-tip-commits@vger.kernel.org
In-Reply-To: <49B02692.3000500@kernel.org>
References: <49AF18B7.4050305@kernel.org>
	 <tip-a1aade478862fca8710904532cbc6efed97fd05a@git.kernel.org>
	 <1236267366.5937.56.camel@desktop>  <49B02692.3000500@kernel.org>
Content-Type: text/plain
Date: Thu, 05 Mar 2009 14:40:23 -0800
Message-Id: <1236292823.5937.84.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-03-05 at 11:22 -0800, Yinghai Lu wrote:

> 
> thanks for checking it.
> 
> can you submit patch to Ingo according to tip/master?


Hows this?

--

Fix up some typos, and make the requirements section slightly cleaner.

Signed-Off-By: Daniel Walker dwalker@fifo99.com

diff --git a/Documentation/x86/earlyprintk.txt b/Documentation/x86/earlyprintk.txt
index 607b1a0..5b51aef 100644
--- a/Documentation/x86/earlyprintk.txt
+++ b/Documentation/x86/earlyprintk.txt
@@ -9,7 +9,9 @@ and two USB cables, connected like this:
 
 1. There are three specific hardware requirements:
 
- a.) Host/target system needs to have USB debug port capability.
+ a.) You will need two USB ports. One on the client/console system and one one the target system.
+ 
+ b.) The client/console and target USB ports must have the debug port capability.
 
  You can check this capability by looking at a 'Debug port' bit in
  the lspci -vvv output:
@@ -35,15 +37,13 @@ and two USB cables, connected like this:
 ( If your system does not list a debug port capability then you probably
   wont be able to use the USB debug key. )
 
- b.) You also need a Netchip USB debug cable/key:
+ c.) You also need a Netchip USB debug cable/key:
 
         http://www.plxtech.com/products/NET2000/NET20DC/default.asp
 
      This is a small blue plastic connector with two USB connections,
      it draws power from its USB connections.
 
- c.) Thirdly, you need a second client/console system with a regular USB port.
-
 2. Software requirements:
 
  a.) On the host/target system:
@@ -54,7 +54,7 @@ and two USB cables, connected like this:
 
     And you need to add the boot command line: "earlyprintk=dbgp".
     (If you are using Grub, append it to the 'kernel' line in
-     /etc/grub.conf)
+     grub.conf (i.e. /boot/grub/grub.conf) )
 
     NOTE: normally earlyprintk console gets turned off once the
     regular console is alive - use "earlyprintk=dbgp,keep" to keep
@@ -72,7 +72,7 @@ and two USB cables, connected like this:
 
     Now this channel of kernel messages is ready to be used: start
     your favorite terminal emulator (minicom, etc.) and set
-    it up to use /dev/ttyUSB0 - or use a raw 'cat /dev/ttyUSBx' to
+    it up to use /dev/ttyUSBx - or use a raw 'cat /dev/ttyUSBx' to
     see the raw output.
 
  c.) On Nvidia Southbridge based systems: the kernel will try to probe
@@ -92,7 +92,7 @@ and two USB cables, connected like this:
 
    On the client/console system do:
 
-       cat /dev/ttyUSB0
+       cat /dev/ttyUSBx
 
    And you should see the help line above displayed shortly after you've
    provoked it on the host system.


