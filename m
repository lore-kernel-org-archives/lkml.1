Return-Path: <linux-kernel-owner+w=401wt.eu-S1765158AbZBNBaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765158AbZBNBaA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 20:30:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763316AbZBNBQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 20:16:07 -0500
Received: from kroah.org ([198.145.64.141]:50192 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763324AbZBNBQE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 20:16:04 -0500
Date: Fri, 13 Feb 2009 17:12:31 -0800
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
       alan@lxorguk.ukuu.org.uk, Hin-Tak Leung <htl10@users.sourceforge.net>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 06/48] zd1211rw: treat MAXIM_NEW_RF(0x08) as
	UW2453_RF(0x09) for TP-Link WN322/422G
Message-ID: <20090214011231.GG17706@kroah.com>
References: <20090214010805.419403436@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="zd1211rw-treat-maxim_new_rf-as-uw2453_rf-for-tp-link-wn322-422g.patch"
In-Reply-To: <20090214011208.GA17706@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Hin-Tak Leung <hintak.leung@gmail.com>

commit efb43f4b2ccf8066abc3920a0e6858e4350a65c7 upstream.

Three people (Petr Mensik <pihhan@cipis.net>
["si" should be U+0161 U+00ED], Stephen Ho <stephenhoinhk@gmail.com>
on zd1211-devs and Ismael Ojeda Perez <iojedaperez@gmail.com>
on linux-wireless) reported success in getting TP-Link WN322G/WN422G
working by treating MAXIM_NEW_RF(0x08) as UW2453_RF(0x09) for rf
chip hardware initialization.

Signed-off-by: Hin-Tak Leung <htl10@users.sourceforge.net>
Tested-by: Petr Mensik <pihhan@cipis.net>
Tested-by: Stephen Ho <stephenhoinhk@gmail.com>
Tested-by: Ismael Ojeda Perez <iojedaperez@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/zd1211rw/zd_rf.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/zd1211rw/zd_rf.c
+++ b/drivers/net/wireless/zd1211rw/zd_rf.c
@@ -86,6 +86,7 @@ int zd_rf_init_hw(struct zd_rf *rf, u8 t
 	case AL7230B_RF:
 		r = zd_rf_init_al7230b(rf);
 		break;
+	case MAXIM_NEW_RF:
 	case UW2453_RF:
 		r = zd_rf_init_uw2453(rf);
 		break;

