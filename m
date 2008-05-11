Return-Path: <linux-kernel-owner+w=401wt.eu-S1761367AbYEKVSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761367AbYEKVSY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 17:18:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756812AbYEKVSG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 17:18:06 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:57505 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752885AbYEKVSE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 17:18:04 -0400
Date: Sun, 11 May 2008 23:18:39 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@vger.kernel.org, marcel@holtmann.org,
       linux-kernel@vger.kernel.org, anssi.hannula@gmail.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH 9/9] HID: add compat support
Message-ID: <20080511211839.GA1641@uranus.ravnborg.org>
References: <1210536043-19812-2-git-send-email-jirislaby@gmail.com> <1210536043-19812-3-git-send-email-jirislaby@gmail.com> <1210536043-19812-4-git-send-email-jirislaby@gmail.com> <1210536043-19812-5-git-send-email-jirislaby@gmail.com> <1210536043-19812-6-git-send-email-jirislaby@gmail.com> <1210536043-19812-7-git-send-email-jirislaby@gmail.com> <1210536043-19812-8-git-send-email-jirislaby@gmail.com> <1210536043-19812-9-git-send-email-jirislaby@gmail.com> <20080511204807.GB850@uranus.ravnborg.org> <48275FFC.9060305@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48275FFC.9060305@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 11, 2008 at 11:07:08PM +0200, Jiri Slaby wrote:
> On 05/11/2008 10:48 PM, Sam Ravnborg wrote:
> >On Sun, May 11, 2008 at 10:00:43PM +0200, Jiri Slaby wrote:
> >>diff --git a/drivers/hid/Makefile b/drivers/hid/Makefile
> >>index 8a5cbbe..c5bca8f 100644
> >>--- a/drivers/hid/Makefile
> >>+++ b/drivers/hid/Makefile
> >>@@ -15,3 +15,25 @@ obj-$(CONFIG_USB_HID)		+= usbhid/
> >> obj-$(CONFIG_USB_MOUSE)		+= usbhid/
> >> obj-$(CONFIG_USB_KBD)		+= usbhid/
> >> 
> >>+targets := hid-dummy.h
> >>+
> >>+ifdef CONFIG_HID_COMPAT
> >>+
> >>+obj-m		+= hid-dummy.o
> >>+
> >>+$(srctree)/$(src)/hid-dummy.c: $(obj)/hid-dummy.h
> >>+
> >>+$(obj)/hid-dummy.h: $(filter-out 
> >>$(srctree)/drivers/hid/hid-dummy.c,$(wildcard $(srctree)/drivers/hid/*.c))
> >>+	@echo -e 'static void __always_inline hid_dummy_load(void)\n{' > $@
> >>+	@FUNS=`grep -h 'HID_COMPAT_LOAD_DRIVER(' $(srctree)/drivers/hid/*.c 
> >>| \
> >>+	sed -e 's/HID_COMPAT_LOAD_DRIVER( *\([^ ]*\) *) *;/\1/'`; \
> >>+	for FUN in $$FUNS; do \
> >>+		echo -e "\textern void hid_compat_$$FUN(void);"; \
> >>+	done >> $@; \
> >>+	echo >> $@; \
> >>+	for FUN in $$FUNS; do \
> >>+		echo -e "\thid_compat_$$FUN();"; \
> >>+	done >> $@
> >>+	@echo "}" >> $@
> >
> >I would prefer to see this done explicit in favour of some magic
> >makefile fragment as the above.
> >It is much simpler to understand if done explicit.
> >And it is not like we are talking 10 or 50 files here.
> 
> Sorry, I don't understand you at all. Could you re-formulate what do you 
> want to see rather than this? Maybe an example would be good.

The code above generates the file hid-dummy.h based on
the HID_COMPAT_LOAD_DRIVER(*) text in a few .c files.
So what I try to say is that we should replace the above with
a hid-dummy.h file that is handedited.

We could stick a few comments in the .h file explaining the usage too.


Or maybe I'm just confused and misunderstood what the code does?


	Sam


