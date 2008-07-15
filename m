Return-Path: <linux-kernel-owner+w=401wt.eu-S932383AbYGOBNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932383AbYGOBNd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 21:13:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756150AbYGOBNY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 21:13:24 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52739 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754454AbYGOBNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 21:13:24 -0400
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from
	in-kernel, use it in more drivers.
From: David Woodhouse <dwmw2@infradead.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
In-Reply-To: <86802c440807141750m937c824kf37c5adf490c8e4a@mail.gmail.com>
References: <1216077806.27455.85.camel@shinybook.infradead.org>
	 <20080714164119.99c33d5b.akpm@linux-foundation.org>
	 <1216079223.27455.92.camel@shinybook.infradead.org>
	 <86802c440807141653s22b91c72gadd6f51ea4a477a@mail.gmail.com>
	 <1216081404.27455.97.camel@shinybook.infradead.org>
	 <86802c440807141750m937c824kf37c5adf490c8e4a@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 14 Jul 2008 18:13:10 -0700
Message-Id: <1216084390.27455.135.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-07-14 at 17:50 -0700, Yinghai Lu wrote:
>   MK_FW   firmware/tigon/tg3.bin.gen.S
> make[1]: *** No rule to make target `firmware/tigon/tg3.bin', needed
> by `firmware/tigon/tg3.bin.gen.o'.  Stop.
> make: *** [firmware] Error 2

I apologise; a line intended for the tg3 conversion accidentally slipped
into firmware/Makefile along with the dabusb patch, when I cherry-picked
from the old tree to omit the drivers/net patches. Again, it didn't show
up in my own testing because I already _had_ the file in question.

(Sorry, Linus. This and the previous fix are now in the for-2.6.27
branch of the same repo as before:
	git://git.infradead.org/users/dwmw2/firmware-2.6.git for-2.6.27
)

----
Subject: Fix accidental reference to tg3 firmware

We're not updating the tg3 driver to use request_firmware() yet, but a
reference to its firmware accidentally slipped in as part of commit
c4667746 ("dabusb: use request_firmware()"). Remove it again.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>

diff --git a/firmware/Makefile b/firmware/Makefile
index 10028ac..8dbdd3f 100644
--- a/firmware/Makefile
+++ b/firmware/Makefile
@@ -34,8 +34,6 @@ fw-shipped-$(CONFIG_SND_SB16_CSP) += sb16/mulaw_main.csp sb16/alaw_main.csp \
 				     sb16/ima_adpcm_capture.csp
 fw-shipped-$(CONFIG_SND_YMFPCI) += yamaha/ds1_ctrl.fw yamaha/ds1_dsp.fw \
 				   yamaha/ds1e_ctrl.fw
-fw-shipped-$(CONFIG_TIGON3) += tigon/tg3.bin tigon/tg3_tso.bin \
-			       tigon/tg3_tso5.bin
 fw-shipped-$(CONFIG_USB_DABUSB) += dabusb/firmware.fw dabusb/bitstream.bin
 fw-shipped-$(CONFIG_USB_EMI26) += emi26/loader.fw emi26/firmware.fw \
 				  emi26/bitstream.fw


-- 
dwmw2

