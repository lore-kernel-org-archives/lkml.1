Return-Path: <linux-kernel-owner+w=401wt.eu-S1755970AbYGOIZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970AbYGOIZx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 04:25:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754461AbYGOIZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 04:25:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43945 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753580AbYGOIZg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 04:25:36 -0400
Date: Tue, 15 Jul 2008 10:24:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from
	in-kernel, use it in more drivers.
Message-ID: <20080715082446.GA8628@elte.hu>
References: <20080714165956.7fe2d4ee@infradead.org> <487C0365.5030203@garzik.org> <alpine.LFD.1.10.0807141911270.3017@woody.linux-foundation.org> <487C09EB.1050903@garzik.org> <alpine.LFD.1.10.0807141928540.3017@woody.linux-foundation.org> <487C1648.5070409@garzik.org> <alpine.LFD.1.10.0807142027140.3017@woody.linux-foundation.org> <487C500F.8000109@garzik.org> <1216107418.27455.236.camel@shinybook.infradead.org> <20080715081431.GB16600@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080715081431.GB16600@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> If there's a fix i can apply and test i'm a happy camper, but all this 
> arguing in these threads with zero patches posted makes me quite 
> nervous.

ah, Yinghai forwarded me the fix below - i am a happy camper :-)

btw.:

| from the old tree to omit the drivers/net patches. Again, it didn't 
| show up in my own testing because I already _had_ the file in 
| question.

6 out of 7 test-distros i have didnt have the tg3.bin file.

	Ingo

---------- Forwarded message ----------
From: David Woodhouse <dwmw2@infradead.org>
Date: Mon, Jul 14, 2008 at 6:13 PM
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from
in-kernel, use it in more drivers.
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
torvalds@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
linux-kernel@vger.kernel.org


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
@@ -34,8 +34,6 @@ fw-shipped-$(CONFIG_SND_SB16_CSP) +=
sb16/mulaw_main.csp sb16/alaw_main.csp \
                                    sb16/ima_adpcm_capture.csp
 fw-shipped-$(CONFIG_SND_YMFPCI) += yamaha/ds1_ctrl.fw yamaha/ds1_dsp.fw \
                                  yamaha/ds1e_ctrl.fw
-fw-shipped-$(CONFIG_TIGON3) += tigon/tg3.bin tigon/tg3_tso.bin \
-                              tigon/tg3_tso5.bin
 fw-shipped-$(CONFIG_USB_DABUSB) += dabusb/firmware.fw dabusb/bitstream.bin
 fw-shipped-$(CONFIG_USB_EMI26) += emi26/loader.fw emi26/firmware.fw \
                                 emi26/bitstream.fw


--
dwmw2
