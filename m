Return-Path: <linux-kernel-owner+w=401wt.eu-S1762737AbYBGUxI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762737AbYBGUxI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 15:53:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932905AbYBGUun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 15:50:43 -0500
Received: from cantor.suse.de ([195.135.220.2]:45000 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759694AbYBGUul (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 15:50:41 -0500
Date: Thu, 7 Feb 2008 12:46:47 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, linux-usb@vger.kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: [patch 05/45] usb gadget: fix fsl_usb2_udc potential OOPS
Message-ID: <20080207204647.GF16389@suse.de>
References: <20080207204118.202098927@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-gadget-fix-fsl_usb2_udc-potential-oops.patch"
In-Reply-To: <20080207204549.GA16389@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.24-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Li Yang <leoli@freescale.com>

For fsl_usb2_udc driver, ep0 also has a descriptor.  Current code is
misleading and contains a logical mistake.  Here is the patch to fix it.

 http://bugzilla.kernel.org/show_bug.cgi?id=9595

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/gadget/fsl_usb2_udc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/gadget/fsl_usb2_udc.c
+++ b/drivers/usb/gadget/fsl_usb2_udc.c
@@ -776,7 +776,7 @@ fsl_ep_queue(struct usb_ep *_ep, struct 
 		VDBG("%s, bad params\n", __FUNCTION__);
 		return -EINVAL;
 	}
-	if (!_ep || (!ep->desc && ep_index(ep))) {
+	if (unlikely(!_ep || !ep->desc)) {
 		VDBG("%s, bad ep\n", __FUNCTION__);
 		return -EINVAL;
 	}

-- 
