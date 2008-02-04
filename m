Return-Path: <linux-kernel-owner+w=401wt.eu-S1754883AbYBDI2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883AbYBDI2d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 03:28:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753724AbYBDI2Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 03:28:25 -0500
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:34874 "EHLO
	mk-filter-3-a-4.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751340AbYBDI2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 03:28:24 -0500
X-Trace: 678624947/mk-filter-3.mail.uk.tiscali.com/B2C/$THROTTLED-DYNAMIC/CUSTOMER-DYNAMIC-IP/81.1.80.9
X-SBRS: None
X-RemoteIP: 81.1.80.9
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAGlbpkdRAVAJ/2dsb2JhbACBWKh7
Subject: Re: [PATCH] SH/Dreamcast - fix regressions, whitespace and memory
	leaks in Maple Bus driver
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: Greg KH <greg@kroah.com>
Cc: Paul Mundt <lethal@linux-sh.org>, linux-sh <linux-sh@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080204052900.GB7585@kroah.com>
References: <1202068847.6262.7.camel@localhost.localdomain>
	 <20080204052900.GB7585@kroah.com>
Content-Type: text/plain
Date: Mon, 04 Feb 2008 08:27:55 +0000
Message-Id: <1202113675.6489.6.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2008-02-03 at 21:29 -0800, Greg KH wrote:
> On Sun, Feb 03, 2008 at 08:00:47PM +0000, Adrian McMenamin wrote:
> > From: Adrian McMenamin
> > 
> > This patch fixes the regression noted here:
> > http://lkml.org/lkml/2008/1/26/189 as well as whitespace issues in the
> > previous commit of this driver and the memory leaks noted here:
> > http://lkml.org/lkml/2008/2/2/143 (as well as one or two other minor
> > cleanups).
> 
> Which portion of the patch fixes the kobject WARN_ON()?



+	if (mdev->registered == 0) {
+		retval = device_register(&mdev->dev);
+		if (retval) {
+			printk(KERN_INFO
+			"Maple bus: Attempt to register device"
+			" (%x, %x) failed.\n",
+			mdev->port, mdev->unit);
+			maple_free_dev(mdev);
+			mdev = NULL;
+			return;
+		}
+		mdev->registered = 1;
+	}
 }


Specifically the check on mdev->registered

Unfortunately the previous commit was completely corrupted by whitespace
everywhere so the patch essentially covers the whole dirver (I had a
choice of submitting broken code with whitespace removed or working code
with whitespace removed)

