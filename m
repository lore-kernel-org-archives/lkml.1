Return-Path: <linux-kernel-owner+w=401wt.eu-S939222AbXFHHql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939222AbXFHHql (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 03:46:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938371AbXFHHYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 03:24:46 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:55267 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937120AbXFHHYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 03:24:44 -0400
Message-Id: <20070608072200.572760000@sous-sol.org>
References: <20070608072127.352723000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 08 Jun 2007 00:21:45 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Oliver Endriss <o.endriss@gmx.de>, e9hack <e9hack@googlemail.com>,
       Thomas Kaiser <linux-dvb@kaiser-linux.li>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 18/54] V4L/DVB (5593): Budget-ci: Fix tuning for TDM 1316 (160..200 MHz)
Content-Disposition: inline; filename=v4l-dvb-budget-ci-fix-tuning-for-tdm-1316.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Oliver Endriss <o.endriss@gmx.de>

Revert changeset
  http://linuxtv.org/hg/v4l-dvb?cmd=changeset;node=e7c424bbf9aa;style=gitweb

Petri Helin found that this changeset broke tuning:

'Well, after going through the changes that might have had effect on
tuning, I found out the one which had caused this problem. I do not know
the actual reason behind the change, but the changelog says that it
was meant to "Fix TD1316 tuner for DVBC". But at least in my case it
seams to have broken the tuner instead.'

Signed-off-by: Oliver Endriss <o.endriss@gmx.de>
Thanks-to: Petri Helin <phelin@googlemail.com>
Acked-by: e9hack <e9hack@googlemail.com>
Acked-by: Thomas Kaiser <linux-dvb@kaiser-linux.li>
Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
Acked-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/media/dvb/ttpci/budget-ci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.21.4.orig/drivers/media/dvb/ttpci/budget-ci.c
+++ linux-2.6.21.4/drivers/media/dvb/ttpci/budget-ci.c
@@ -926,7 +926,7 @@ static int dvbc_philips_tdm1316l_tuner_s
 		band = 1;
 	} else if (tuner_frequency < 200000000) {
 		cp = 6;
-		band = 2;
+		band = 1;
 	} else if (tuner_frequency < 290000000) {
 		cp = 3;
 		band = 2;

-- 
