Return-Path: <linux-kernel-owner+w=401wt.eu-S1751930AbYFWXHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751930AbYFWXHq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 19:07:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751424AbYFWXHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 19:07:07 -0400
Received: from ns2.suse.de ([195.135.220.15]:39057 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752697AbYFWXHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 19:07:06 -0400
Date: Mon, 23 Jun 2008 16:04:45 -0700
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
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "Mark M. Hoffman" <mhoffman@lightlink.com>,
       Jean Delvare <khali@linux-fr.org>
Subject: [patch 08/10] hwmon: (lm85) Fix function RANGE_TO_REG()
Message-ID: <20080623230445.GB29853@suse.de>
References: <20080623225737.837265824@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="hwmon-fix-function-range_to_reg.patch"
In-Reply-To: <20080623230417.GA29853@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25.9-stable review patch.  If anyone has any objections, please let
us know.

------------------ 
From: Jean Delvare <khali@linux-fr.org>

Function RANGE_TO_REG() is broken. For a requested range of 2000 (2
degrees C), it will return an index value of 15, i.e. 80.0 degrees C,
instead of the expected index value of 0. All other values are handled
properly, just 2000 isn't.

The bug was introduced back in November 2004 by this patch:
http://git.kernel.org/?p=linux/kernel/git/tglx/history.git;a=commit;h=1c28d80f1992240373099d863e4996cdd5d646d0

In Linus' kernel I decided to rewrite the whole function in a way
which was more obviously correct. But for -stable let's just do the
minimal fix.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hwmon/lm85.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwmon/lm85.c
+++ b/drivers/hwmon/lm85.c
@@ -192,7 +192,7 @@ static int RANGE_TO_REG( int range )
 {
 	int i;
 
-	if ( range < lm85_range_map[0] ) { 
+	if (range <= lm85_range_map[0]) {
 		return 0 ;
 	} else if ( range > lm85_range_map[15] ) {
 		return 15 ;

-- 
