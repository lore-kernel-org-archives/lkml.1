Return-Path: <linux-kernel-owner+w=401wt.eu-S932078AbZBNBFE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078AbZBNBFE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 20:05:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754942AbZBNBBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 20:01:33 -0500
Received: from kroah.org ([198.145.64.141]:39493 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754800AbZBNBBc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 20:01:32 -0500
Date: Fri, 13 Feb 2009 16:58:24 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Ian Dall <ian@beware.dropbear.id.au>,
       Evgeniy Polyakov <zbr@ioremap.net>
Subject: [patch 10/47] w1: w1 temp calculation overflow fix
Message-ID: <20090214005824.GK11282@kroah.com>
References: <20090214005130.617401075@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="w1-w1-temp-calculation-overflow-fix.patch"
In-Reply-To: <20090214005726.GA11282@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ian Dall <ian@beware.dropbear.id.au>

commit 507e2fbaaacb6f164b4125b87c5002f95143174b upstream.

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=12646

When the temperature exceeds 32767 milli-degrees the temperature overflows
to -32768 millidegrees.  These are bothe well within the -55 - +125 degree
range for the sensor.

Fix overflow in left-shift of a u8.

Signed-off-by: Ian Dall <ian@beware.dropbear.id.au>
Signed-off-by: Evgeniy Polyakov <zbr@ioremap.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/w1/slaves/w1_therm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/w1/slaves/w1_therm.c
+++ b/drivers/w1/slaves/w1_therm.c
@@ -113,7 +113,7 @@ static struct w1_therm_family_converter 
 
 static inline int w1_DS18B20_convert_temp(u8 rom[9])
 {
-	s16 t = (rom[1] << 8) | rom[0];
+	int t = ((s16)rom[1] << 8) | rom[0];
 	t = t*1000/16;
 	return t;
 }

