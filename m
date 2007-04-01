Return-Path: <linux-kernel-owner+w=401wt.eu-S932690AbXDAGhL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932690AbXDAGhL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 02:37:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932785AbXDAGhL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 02:37:11 -0400
Received: from smtp01.isdsl.net ([196.26.208.190]:55702 "EHLO smtp01.isdsl.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932690AbXDAGhJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 02:37:09 -0400
X-Greylist: delayed 1221 seconds by postgrey-1.27 at vger.kernel.org; Sun, 01 Apr 2007 02:37:09 EDT
Message-ID: <460F4E35.10109@kroon.co.za>
Date: Sun, 01 Apr 2007 08:16:21 +0200
From: Jaco Kroon <jaco@kroon.co.za>
User-Agent: Thunderbird 1.5.0.10 (X11/20070331)
MIME-Version: 1.0
To: Pedram M <pmessri@gmail.com>
CC: kernel-janitors@lists.osdl.org, linux-kernel@vger.kernel.org
References: <9c9aa5d00703310639q68fa5d19k4d8e3bfb56b1fa6@mail.gmail.com> <9c9aa5d00703312224t1948b24bhe34199f19cbda4fb@mail.gmail.com>
In-Reply-To: <9c9aa5d00703312224t1948b24bhe34199f19cbda4fb@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-score: -1.8
X-Spam-report: SpamAssassin 3.1.8 (xacatecas.lan) Report:
	ALL_TRUSTED=-1.8
	Relay Countries: 
	pts  rule name              description
	---- ---------------------- --------------------------------------------------
	-1.8 ALL_TRUSTED            Passed through trusted hosts only via SMTP
	Total: -1.8/3.5
	Contact: postmaster@kroon.co.za
Subject: Re: [KJ] my first janitorial
X-Scan-Signature: 30172e4ad79eabc895afebd0c12510de{39}}
X-Trace: smtp01.isdsl.net 1HXtMq-0001cf-90 75f48bc69df1efd56812aeba0d930953
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pedram M wrote:
> How about this one? Am I doing it right now?
> If not, please try to explain more to me what I am
> doing wrong.

You need a changelog entry (or explanation of what you're doing). You 
need a signed-off-by line and your patch needs to apply to the root of 
the kernel tree with -p1, something like:

-------------
Replace deprecated pci_find_device call with pci_get_device.

Signed-Off-By: Pedram M <pmessri@gmail.com>

--- linux-2.6.20.3.orig/path/to/file.c     2006-06-24 09:41:08.000000000 
+0200
+++ linux-2.6.20.3/path/to/file.c       2006-07-15 21:01:57.000000000 +0200
@@ -4760,7 +4760,7 @@
  	for (i = 0; i < NR_CARDS; i++) {
  		/* look for a Cyclades card by vendor and device id */
  		while ((device_id = cy_pci_dev_id[dev_index]) != 0) {
-			if ((pdev = pci_find_device(PCI_VENDOR_ID_CYCLADES,
+			if ((pdev = pci_get_device(PCI_VENDOR_ID_CYCLADES,
  						   device_id, pdev)) == NULL) {
  				dev_index++;	/* try next device id */
  			} else {
-------------

And your subject needs to please include the string "[PATCH]", something 
like:  [PATCH] path/to/file.c: pci_find_device cleanup

However, as pointed out, the code itself is incorrect, for every 
pci_get_device there also needs to be a call to pci_put_device in order 
to maintain reference counts.

Your client does not seem to be clobbering the patch itself and 
maintains tabs and line wrapping (unlike my client).

Jaco
