Return-Path: <linux-kernel-owner+w=401wt.eu-S1755282AbYFWLqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282AbYFWLqR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 07:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752385AbYFWLqE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 07:46:04 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37093 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202AbYFWLqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 07:46:02 -0400
Subject: Re: [PATCH] dabusb: use request_firmware()
From: David Woodhouse <dwmw2@infradead.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Deti Fliegl <deti@fliegl.de>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-kernel@vger.kernel.org, jaswinder@infradead.org, bunk@kernel.org
In-Reply-To: <20080623112004.GA26516@infradead.org>
References: <1214219201.27974.21.camel@shinybook.infradead.org>
	 <20080623112004.GA26516@infradead.org>
Content-Type: text/plain
Date: Mon, 23 Jun 2008 12:45:58 +0100
Message-Id: <1214221558.27974.33.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-06-23 at 07:20 -0400, Christoph Hellwig wrote:
> > +config USB_DABUSB_FIRMWARE
> > +	bool "Include firmware images for DABUSB driver"
> > +	depends on USB_DABUSB
> > +	---help---
> > +	Include the firmware for the DABUSB device in the kernel image.
> > +	Say 'N' and let it get loaded from userspace.
> 
> Sorry if I missed a discussion on it in the intial firmware threads, but
> what is the point of all these FOO_FIRMWARE options?  I think we should
> include all firmware that we have a driver for if people want firmware
> built-in and non if not.

That makes a certain amount of sense, I suppose, and would certainly
reduce the litter of new _FIRMWARE options, as well as the pointless
whining that some people like to repeat at _each_ patch when we default
them to 'N'. I could do it something like below...

What was the final conclusion on the need to add 'select FW_LOADER'?
Is that going to go away, too?

--- a/firmware/Makefile
+++ b/firmware/Makefile
@@ -48,10 +48,13 @@
-fw-shipped-$(CONFIG_USB_TI_3410_FIRMWARE) += ti_3410.fw
-fw-shipped-$(CONFIG_USB_TI_5052_FIRMWARE) += ti_5052.fw
+fw-shipped-$(CONFIG_USB_TI) += ti_3410.fw ti_5052.fw
-fw-shipped-$(CONFIG_USB_SERIAL_WHITEHEAT_FIRMWARE) += whiteheat_loader.fw \
+fw-shipped-$(CONFIG_USB_SERIAL_WHITEHEAT) += whiteheat_loader.fw \
 		whiteheat.fw # whiteheat_loader_debug.fw
-fw-shipped-$(CONFIG_ATM_AMBASSADOR_FIRMWARE) += atmsar11.fw
+fw-shipped-$(CONFIG_ATM_AMBASSADOR) += atmsar11.fw
-fw-shipped-$(CONFIG_COMPUTONE_FIRMWARE) += intelliport2.bin
+fw-shipped-$(CONFIG_COMPUTONE) += intelliport2.bin
-fw-shipped-$(CONFIG_VIDEO_CPIA2_FIRMWARE) += cpia2/stv0672_vp4.bin
+fw-shipped-$(CONFIG_VIDEO_CPIA2) += cpia2/stv0672_vp4.bin
+
+ifeq ($(CONFIG_INCLUDE_FIRMWARE),n)
+fw-shipped-y := 
+endif
 
 firmware-y    := $(fw-external-y) $(fw-shipped-y)
 firmware-dirs := $(sort $(patsubst %,$(objtree)/$(obj)/%/,$(dir $(firmware-y))))


-- 
dwmw2

