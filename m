Return-Path: <linux-kernel-owner+w=401wt.eu-S1754845AbYAXCDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845AbYAXCDm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 21:03:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750994AbYAXCDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 21:03:35 -0500
Received: from SpacedOut.fries.net ([67.64.210.234]:42865 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbYAXCDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 21:03:34 -0500
Date: Wed, 23 Jan 2008 20:03:30 -0600
From: David Fries <david@fries.net>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH] W1: w1_therm.c standardize units to millidegrees C
Message-ID: <20080124020330.GA19155@spacedout.fries.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Wed, 23 Jan 2008 20:03:31 -0600 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the patch to standardize the temperature units to millidegrees
C for the two sensor conversion routines.  Previously the routines
were,

w1_DS18B20_convert_temp degrees C
w1_DS18S20_convert_temp millidegrees C

Unfortunately this will break any program using the ds18b20 value as
it will now be 1000 times bigger.  Fortunately there can't be that
many users out there, or some of these bugs will have been fixed by
now, such as the negative C error (see previous patch) that makes me
think the ds18b20 is the better choice to change because of the
current bugs.

Signed-off-by: David Fries <david@fries.net>

Index: slaves/w1_therm.c
===================================================================
RCS file: /home/david/kernel/k/spacedout/patches/linux/drivers/w1/slaves/w1_therm.c,v
retrieving revision 1.5
diff -u -p -r1.5 w1_therm.c
--- slaves/w1_therm.c	24 Jan 2008 01:23:46 -0000	1.5
+++ slaves/w1_therm.c	24 Jan 2008 01:57:39 -0000
@@ -92,6 +92,7 @@ struct w1_therm_family_converter
 	int			(*convert)(u8 rom[9]);
 };
 
+/* The return value is millidegrees Centigrade. */
 static inline int w1_DS18B20_convert_temp(u8 rom[9]);
 static inline int w1_DS18S20_convert_temp(u8 rom[9]);
 
@@ -113,7 +114,7 @@ static struct w1_therm_family_converter 
 static inline int w1_DS18B20_convert_temp(u8 rom[9])
 {
 	s16 t = (rom[1] << 8) | rom[0];
-	t /= 16;
+	t = t*1000/16;
 	return t;
 }
 

-- 
David Fries <david@fries.net>
http://fries.net/~david/ (PGP encryption key available)
