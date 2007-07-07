Return-Path: <linux-kernel-owner+w=401wt.eu-S1754259AbXGGBBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259AbXGGBBS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 21:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751923AbXGGBBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 21:01:05 -0400
Received: from styx.suse.cz ([82.119.242.94]:56746 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751760AbXGGBBE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 21:01:04 -0400
Date: Sat, 7 Jul 2007 03:05:03 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Dmitry Torokhov <dtor@insightbb.com>
Cc: Marcel Holtmann <marcel@holtmann.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>
Subject: Re: [1/2] 2.6.22-rc7: known regressions
In-Reply-To: <200707062033.18211.dtor@insightbb.com>
Message-ID: <Pine.LNX.4.64.0707070257040.11634@jikos.suse.cz>
References: <468A7D14.1050505@googlemail.com>
 <d120d5000707051403r1d946375nb119ff86b26580ef@mail.gmail.com>
 <Pine.LNX.4.64.0707070019110.11634@jikos.suse.cz> <200707062033.18211.dtor@insightbb.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jul 2007, Dmitry Torokhov wrote:

> This is for devices using boot protocol, not full HID as far as I 
> understand.

David,

could you please try with the trivial patch below and report the output? 
I'd be interested to know whether we are by any chance really seeing 
double input_unregister_device() for the same input_dev somehow. Thanks.

diff --git a/drivers/input/input.c b/drivers/input/input.c
index ccd8aba..ed5adb4 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -1160,6 +1160,9 @@ void input_unregister_device(struct input_dev *dev)
 	struct input_handle *handle, *next;
 	int code;
 
+	printk(KERN_DEBUG "input_unregister_device for %p\n", dev);
+	dump_stack();
+
 	for (code = 0; code <= KEY_MAX; code++)
 		if (test_bit(code, dev->key))
 			input_report_key(dev, code, 0);
