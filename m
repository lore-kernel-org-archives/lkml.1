Return-Path: <linux-kernel-owner+w=401wt.eu-S1753979AbZH3SzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979AbZH3SzX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 14:55:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753960AbZH3SzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 14:55:23 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:49505 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753952AbZH3SzW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 14:55:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:message-id
         :content-type:content-transfer-encoding;
        b=D5Bq82voCOQV/Dj7VJv1BwWSUT7NGjf+PS+tZzCs0/nx5yetqQWGv6OyMNg5JR8CnY
         0tq/ImH2PQrxCgx6qXTO2PfX6Uwqjgt0RfuwHdIdWyxIJvyLMSBStWy01okmBM6g8EZR
         rn2PAaGNb/45xRILsrNguPNDRJqX9CfwEkk10=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH] powermac: thermal control turns system off in normal temperature conditions
Date: Sun, 30 Aug 2009 20:54:20 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc8-00015-gadda766-dirty; KDE/4.3.0; i686; ; )
Cc: Lyonel Vincent <lyonel@ezix.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200908302054.20498.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lyonel Vincent <lyonel@ezix.org>
Subject: [PATCH] powermac: thermal control turns system off in normal temperature conditions

On certain PowerMacs, a module (therm_windtunnel) controls various
thermal settings (it can report CPU/case temperature, change speed
of internal fans, etc.)

By default, the hardware thermal control has a temperature limit to
protect the computer from damages (the default limit seems to be 80°C)
but therm_windtunnel.c reduces it to an anormaly low value (65°C),
which means that he computer will shut down randomly when hit by direct
sun light or during summer (summer in France can be quite hot), actually
possibly losing data instead of protecting it.

The overheat limit in therm_windtunnel.c:253-254 should be set to 75°C
and 70°C instead of 65°C and 60°C respectively.

From: Lyonel Vincent <lyonel@ezix.org>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
Resurrected from Fedora's bugzilla (aka The Big Black Hole):
https://bugzilla.redhat.com/show_bug.cgi?id=171937

The patch itself seems perfectly valid to me
(especially given comments in therm_windtunnel.c).

 drivers/macintosh/therm_windtunnel.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: b/drivers/macintosh/therm_windtunnel.c
===================================================================
--- a/drivers/macintosh/therm_windtunnel.c
+++ b/drivers/macintosh/therm_windtunnel.c
@@ -239,8 +239,8 @@ setup_hardware( void )
 	 * to be on the safe side (OSX doesn't)...
 	 */
 	if( x.overheat_temp == (80 << 8) ) {
-		x.overheat_temp = 65 << 8;
-		x.overheat_hyst = 60 << 8;
+		x.overheat_temp = 75 << 8;
+		x.overheat_hyst = 70 << 8;
 		write_reg( x.thermostat, 2, x.overheat_hyst, 2 );
 		write_reg( x.thermostat, 3, x.overheat_temp, 2 );
 
