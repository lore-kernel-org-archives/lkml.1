Return-Path: <linux-kernel-owner+w=401wt.eu-S1762006AbYEMWLC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762006AbYEMWLC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 18:11:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757931AbYEMWKv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 18:10:51 -0400
Received: from ns.suse.de ([195.135.220.2]:35679 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757377AbYEMWKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 18:10:50 -0400
Subject: patch usbtest-comment-on-why-this-code-expects-negative-and-positive-errnos.patch added to gregkh-2.6 tree
To: marcin.slusarz@gmail.com, david-b@pacbell.net, gregkh@suse.de,
       linux-kernel@vger.kernel.org
From: <gregkh@suse.de>
Date: Tue, 13 May 2008 15:07:33 -0700
In-Reply-To: <20080512181721.GA6031@joi>
Message-ID: <12107164531292@kroah.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

     Subject: usbtest: comment on why this code "expects" negative and positive errnos

to my gregkh-2.6 tree.  Its filename is

     usbtest-comment-on-why-this-code-expects-negative-and-positive-errnos.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From marcin.slusarz@gmail.com  Tue May 13 14:58:09 2008
From: Marcin Slusarz <marcin.slusarz@gmail.com>
Date: Mon, 12 May 2008 20:17:25 +0200
Subject: usbtest: comment on why this code "expects" negative and positive errnos
To: David Brownell <david-b@pacbell.net>, LKML <linux-kernel@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org
Message-ID: <20080512181721.GA6031@joi>
Content-Disposition: inline


On Mon, May 12, 2008 at 01:02:22AM -0700, David Brownell wrote:
> On Sunday 11 May 2008, Marcin Slusarz wrote:
> > 
> > test_ctrl_queue expects (?) positive and negative errnos.
> > what is going on here?
> 
> The sign is just a way to flag something:
> 
>                 /* some faults are allowed, not required */
> 
> The negative ones are required.  Positive codes are optional,
> in the sense that, depending on how the peripheral happens
> to be implemented, they won't necessarily be triggered.
> 
> For example, the test to fetch a device qualifier desriptor
> must succeed if the device is running at high speed.  So that
> test is marked as negative.  But when it's full speed, it
> could legitimately fail; marked as positive.  And so on for
> other tests.
> 
> Look at how the codes are *interpreted* to see it work.

Lets document it.

Based on comment from David Brownell <david-b@pacbell.net>.

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/misc/usbtest.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/usb/misc/usbtest.c
+++ b/drivers/usb/misc/usbtest.c
@@ -856,6 +856,11 @@ test_ctrl_queue (struct usbtest_dev *dev
 		struct urb		*u;
 		struct usb_ctrlrequest	req;
 		struct subcase		*reqp;
+
+		/* sign of this variable means:
+		 *  -: tested code must return this (negative) error code
+		 *  +: tested code may return this (negative too) error code
+		 */
 		int			expected = 0;
 
 		/* requests here are mostly expected to succeed on any


Patches currently in gregkh-2.6 which might be from marcin.slusarz@gmail.com are

usb.current/usbtest-comment-on-why-this-code-expects-negative-and-positive-errnos.patch
