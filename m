Return-Path: <linux-kernel-owner+w=401wt.eu-S1760868AbXJaP2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760868AbXJaP2t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 11:28:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760049AbXJaPZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 11:25:00 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33597 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760045AbXJaPY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 11:24:59 -0400
Date: Wed, 31 Oct 2007 08:12:01 -0700
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
       Jeff Garzik <jeff@garzik.org>, Karsten Keil <kkeil@suse.de>
Subject: [patch 18/26] netdrvr: natsemi: Fix device removal bug
Message-ID: <20071031151201.GS2437@kroah.com>
References: <20071031150535.967437651@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline; filename="netdrvr-natsemi-fix-device-removal-bug.patch"
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071031151015.GA2437@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.22-stable review patch.  If anyone has any objections, please let us
know.

------------------
This episode illustrates how an overused warning can train people to
ignore that warning, which winds up hiding bugs.

The warning

drivers/net/natsemi.c: In function ‘natsemi_remove1’:
drivers/net/natsemi.c:3222: warning: ignoring return value of
‘device_create_file’, declared with attribute warn_unused_result

is oft-ignored, even though at close inspection one notices this occurs
in the /remove/ function, not normally where creation occurs.  A quick
s/create/remove/ and we are fixed, with the warning gone.

Signed-off-by: Jeff Garzik <jeff@garzik.org>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/natsemi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/natsemi.c
+++ b/drivers/net/natsemi.c
@@ -671,7 +671,7 @@ static ssize_t natsemi_show_##_name(stru
 #define NATSEMI_CREATE_FILE(_dev, _name) \
          device_create_file(&_dev->dev, &dev_attr_##_name)
 #define NATSEMI_REMOVE_FILE(_dev, _name) \
-         device_create_file(&_dev->dev, &dev_attr_##_name)
+         device_remove_file(&_dev->dev, &dev_attr_##_name)
 
 NATSEMI_ATTR(dspcfg_workaround);
 

-- 
