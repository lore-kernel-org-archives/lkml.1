Return-Path: <linux-kernel-owner+w=401wt.eu-S1756841AbYIIS2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841AbYIIS2i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 14:28:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753545AbYIIS2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 14:28:30 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:57256 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223AbYIIS23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 14:28:29 -0400
Message-ID: <48C6C0ED.2000409@keyaccess.nl>
Date: Tue, 09 Sep 2008 20:31:09 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org,
       Rene Herman <rene.herman@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [bisected][resend] pnp: Huge number of "io resource overlap"
 messages
References: <200809091250.08620.elendil@planet.nl> <200809090930.27583.bjorn.helgaas@hp.com> <200809091826.18876.elendil@planet.nl> <200809091140.25597.bjorn.helgaas@hp.com>
In-Reply-To: <200809091140.25597.bjorn.helgaas@hp.com>
Content-Type: multipart/mixed;
 boundary="------------000600020605000707020708"
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000600020605000707020708
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

On 09-09-08 19:40, Bjorn Helgaas wrote:

> If the PCI device isn't fully initialized, it doesn't seem right to
> check it for resource conflicts.  But I don't know how to tell that.

His pci_resource_start() values are 0. How about just checking for that?

Rene.

--------------000600020605000707020708
Content-Type: text/plain;
 name="quirk_system_pci_resources.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="quirk_system_pci_resources.diff"

diff --git a/drivers/pnp/quirks.c b/drivers/pnp/quirks.c
index 0bdf9b8..d0120a5 100644
--- a/drivers/pnp/quirks.c
+++ b/drivers/pnp/quirks.c
@@ -253,6 +253,9 @@ static void quirk_system_pci_resources(struct pnp_dev *dev)
 				continue;
 
 			pci_start = pci_resource_start(pdev, i);
+			if (!pci_start)
+				continue;
+
 			pci_end = pci_resource_end(pdev, i);
 			for (j = 0;
 			     (res = pnp_get_resource(dev, type, j)); j++) {

--------------000600020605000707020708--
