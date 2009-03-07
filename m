Return-Path: <linux-kernel-owner+w=401wt.eu-S1756018AbZCGTVE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018AbZCGTVE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 14:21:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755689AbZCGTUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 14:20:52 -0500
Received: from mail-fx0-f176.google.com ([209.85.220.176]:54817 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754768AbZCGTUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 14:20:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=Cni9V1LlVYeyWN1rK/UX2aqnKgQs05zVahfa2Xk4F+Uajk7iRPwgfrRxIRMQlYRE6X
         k/bfMBpjDt/oOklPT8eNM1zIjOZSI2QLqnqLtkkolXvfsbmnI+uvWusmrht3urk2e0XI
         1S9hCmOA3fDCXLRxs37jOkC5TJKgywiznoeHs=
Subject: [BUG] Loading both ehci-hcd and uhci-hcd drivers causes my printer
 to fail
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Sat, 07 Mar 2009 21:20:44 +0200
Message-Id: <1236453644.6077.68.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Short summary:

I have HP1018 printer, and it works well in windows.
When I use in in linux, I often see messages like:

usbfs: USBDEVFS_CONTROL failed cmd python rqt 128 rq 6 len 255 ret -110

This is using hp backend that talks to printer using usbfs.
I also tried usblp, but it just doesn't say anything in kernel log. I
think it silently ignores similar errors, because the end result is the
same, the printer sometimes works, but sometimes doesn't.
(printer needs firmware to be uploaded to it, and I do upload it).

On the other hand, IF I remove _ether_ ehci-hcd or uhci-hcd from kernel,
then everything works fine, I already rebooted the printer many times,
used it to print, upload firmware, and everything just work, but as soon
as I load the second driver it fails in same way again.

USB issues with this class of printers are nothing but new, for example
see:

http://foo2zjs.rkkda.com/forum/read.php?9,374
https://bugs.launchpad.net/ubuntu/+source/linux-source-2.6.15/+bug/54419

I compiled without CONFIG_USB_EHCI_ROOT_HUB_TT
and it did help (didn't that much testing, but at least firmware loads
ok, and no error messages)

Looking for your comments,
	Best regards,
		Maxim Levitsky


