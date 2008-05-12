Return-Path: <linux-kernel-owner+w=401wt.eu-S1757219AbYELSSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757219AbYELSSV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 14:18:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754198AbYELSSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 14:18:12 -0400
Received: from hu-out-0506.google.com ([72.14.214.227]:58046 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754165AbYELSSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 14:18:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=fFBag6TzwII1EyOTVqznrisiV4eZBvhUf7XXNdGuqU/LhDqGmzD1uJXf5EKnyxditM24myi5hCeOj/UfPJSfjP8aRJQK1au5hCspdf+Uq6kAzJrho0+4Mjr78qaoz2Rf6NQSFW6tk5M2EZPQrdl1Rf8VWg8PYkI/6i0kTmYvVXM=
Date: Mon, 12 May 2008 20:17:25 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: David Brownell <david-b@pacbell.net>, LKML <linux-kernel@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org
Subject: [PATCH] usb/usbtest: comment on why this code "expects" negative
	and positive errnos
Message-ID: <20080512181721.GA6031@joi>
References: <20080511202222.GP19058@joi> <200805120102.23320.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805120102.23320.david-b@pacbell.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Thanks for a response!
Lets document it.

---
Based on comment from David Brownell <david-b@pacbell.net>.

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: David Brownell <david-b@pacbell.net>
---
 drivers/usb/misc/usbtest.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/misc/usbtest.c b/drivers/usb/misc/usbtest.c
index 742be3c..054dedd 100644
--- a/drivers/usb/misc/usbtest.c
+++ b/drivers/usb/misc/usbtest.c
@@ -856,6 +856,11 @@ test_ctrl_queue (struct usbtest_dev *dev, struct usbtest_param *param)
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
-- 
1.5.4.5
