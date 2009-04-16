Return-Path: <linux-kernel-owner+w=401wt.eu-S1758114AbZDPXqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758114AbZDPXqe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 19:46:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756361AbZDPXqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 19:46:24 -0400
Received: from fk-out-0910.google.com ([209.85.128.184]:63694 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756055AbZDPXqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 19:46:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:x-accept-language:mime-version:to
         :subject:x-enigmail-version:content-type;
        b=SE11j7HP6hfDOeMNu6+htGNGKus12vICBA7TEJ5JVygHJrlqUxkJpcRQS7nUbh3NrT
         ePB13sJLZRerq6XZfzTzwjX/WRoeMI/aon/Z9Q/4BoIWFbTEZBLbHJ8mxH2xQbg2Why7
         vI6gcAMmQFkGmB0HemiKNHUkAX/jqW9kwBi+E=
Message-ID: <49E7C34A.60007@googlemail.com>
Date: Fri, 17 Apr 2009 01:46:18 +0200
From: Michael Riepe <michael.riepe@googlemail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.7.13) Gecko/20060417
X-Accept-Language: de-de, de, en-us, en
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Enable coretemp driver on Intel Atom
X-Enigmail-Version: 0.91.0.0
Content-Type: multipart/mixed;
 boundary="------------040603040301010104070709"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040603040301010104070709
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit

Hi!

This small patch enables the coretemp driver on an Intel Atom. I'm not
sure if the readings are correct, however - on my 330, the driver
reports values between 27 and 41 °C (with core1 being about 8°C hotter
than core0, given the same load). Maybe the maximum temperature of 100
°C is wrong for Atom CPUs.

-- 
Michael "Tired" Riepe <michael.riepe@googlemail.com>
X-Tired: Each morning I get up I die a little

--------------040603040301010104070709
Content-Type: text/plain;
 name="linux-2.6.29.1-coretemp-atom.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="linux-2.6.29.1-coretemp-atom.diff"

Signed-off-by: Michael Riepe <michael.riepe@googlemail.com>

Index: drivers/hwmon/coretemp.c
===================================================================
RCS file: /var/cvs/sys/kernel/linux-2.6/drivers/hwmon/coretemp.c,v
retrieving revision 1.1.1.5
diff -u -r1.1.1.5 coretemp.c
--- drivers/hwmon/coretemp.c	11 Jan 2009 21:29:23 -0000	1.1.1.5
+++ drivers/hwmon/coretemp.c	16 Apr 2009 23:02:40 -0000
@@ -185,7 +185,7 @@
 		}
 	}
 
-	if (ismobile) {
+	if (ismobile || c->x86_model == 0x1c) {
 
 		err = rdmsr_safe_on_cpu(id, 0xee, &eax, &edx);
 		if (err) {
@@ -417,7 +417,7 @@
 		if ((c->cpuid_level < 0) || (c->x86 != 0x6) ||
 		    !((c->x86_model == 0xe) || (c->x86_model == 0xf) ||
 			(c->x86_model == 0x16) || (c->x86_model == 0x17) ||
-			(c->x86_model == 0x1A))) {
+			(c->x86_model == 0x1A) || (c->x86_model == 0x1c))) {
 
 			/* supported CPU not found, but report the unknown
 			   family 6 CPU */

--------------040603040301010104070709--
