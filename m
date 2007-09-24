Return-Path: <linux-kernel-owner+w=401wt.eu-S1760593AbXIXQZ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760593AbXIXQZ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 12:25:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760043AbXIXQYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 12:24:43 -0400
Received: from canuck.infradead.org ([209.217.80.40]:47154 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759770AbXIXQYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 12:24:42 -0400
Date: Mon, 24 Sep 2007 09:19:53 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>,
       Andreas Arens <ari@goron.de>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [03/50] DVB: get_dvb_firmware: update script for new location of
	tda10046 firmware
Message-ID: <20070924161953.GD13510@kroah.com>
References: <20070924161246.983665021@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="dvb-get_dvb_firmware-update-script-for-new-location-of-tda10046-firmware.patch"
In-Reply-To: <20070924161733.GA13510@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Andreas Arens <ari@goron.de>

cherry picked from commit c545d6adbcacd296f7457bd992556feb055379de

Update get_dvb_firmware script for the new location of the
tda10046 firmware.

The old location doesn't work anymore.

Signed-off-by: Andreas Arens <ari@goron.de>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 Documentation/dvb/get_dvb_firmware |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/Documentation/dvb/get_dvb_firmware
+++ b/Documentation/dvb/get_dvb_firmware
@@ -110,21 +110,21 @@ sub tda10045 {
 }
 
 sub tda10046 {
-    my $sourcefile = "tt_budget_217g.zip";
-    my $url = "http://www.technotrend.de/new/217g/$sourcefile";
-    my $hash = "6a7e1e2f2644b162ff0502367553c72d";
-    my $outfile = "dvb-fe-tda10046.fw";
-    my $tmpdir = tempdir(DIR => "/tmp", CLEANUP => 1);
+	my $sourcefile = "TT_PCI_2.19h_28_11_2006.zip";
+	my $url = "http://technotrend-online.com/download/software/219/$sourcefile";
+	my $hash = "6a7e1e2f2644b162ff0502367553c72d";
+	my $outfile = "dvb-fe-tda10046.fw";
+	my $tmpdir = tempdir(DIR => "/tmp", CLEANUP => 1);
 
-    checkstandard();
+	checkstandard();
 
-    wgetfile($sourcefile, $url);
-    unzip($sourcefile, $tmpdir);
-    extract("$tmpdir/software/OEM/PCI/App/ttlcdacc.dll", 0x3f731, 24478, "$tmpdir/fwtmp");
-    verify("$tmpdir/fwtmp", $hash);
-    copy("$tmpdir/fwtmp", $outfile);
+	wgetfile($sourcefile, $url);
+	unzip($sourcefile, $tmpdir);
+	extract("$tmpdir/TT_PCI_2.19h_28_11_2006/software/OEM/PCI/App/ttlcdacc.dll", 0x65389, 24478, "$tmpdir/fwtmp");
+	verify("$tmpdir/fwtmp", $hash);
+	copy("$tmpdir/fwtmp", $outfile);
 
-    $outfile;
+	$outfile;
 }
 
 sub tda10046lifeview {

-- 
