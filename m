Return-Path: <linux-kernel-owner+w=401wt.eu-S1753303AbYKRANz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303AbYKRANz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 19:13:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751552AbYKRANo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 19:13:44 -0500
Received: from rv-out-0506.google.com ([209.85.198.230]:65033 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327AbYKRANn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 19:13:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=H7R3rqBW6JMA8ULDlovdTxkLBBBBm9xGji+2wRwtPIkUnh8L/YKzxO2AEnGHwyKaZV
         AJhG3nMp6vypyGaVSScM4XBDKjZQItLSa3A2qiItANpqwyucu6K8zSC+aK9FGBWPssTi
         Ls55HPZIvQrFFFmVwSfXXjxW52h4NGvOW/vgY=
Date: Mon, 17 Nov 2008 18:13:36 -0600
From: Jay Cliburn <jcliburn@gmail.com>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: csnook@redhat.com, atl1-devel@lists.sourceforge.net,
       linux-kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Subject: Re: [atl1-devel] atl2: don't mess up irq on suspend/resume
 (probably msi only)
Message-ID: <20081117181336.1a270561@osprey.hogchain.net>
In-Reply-To: <4921E574.3090602@tuffmail.co.uk>
References: <49201401.1060600@tuffmail.co.uk>
	<4921E574.3090602@tuffmail.co.uk>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[adding netdev to cc list]

On Mon, 17 Nov 2008 21:43:16 +0000
Alan Jenkins <alan-jenkins@tuffmail.co.uk> wrote:


> Don't listen to me.  The problem went away because when I was testing
> my patch, I plugged the ethernet in and actually used it.  My patch
> doesn't seem to fix anything.
> 
> So I now have the steps to reproduce this warning: remove the ethernet
> cable and suspend.
> 
> Also, I was speaking rubbish because the warning isn't on the resume
> path.  It seems to be when network-manager re-opens the device on
> resume.
> 
> I'll have another look for possible culprits.  Hints appreciated :).

Does this help?

diff --git a/drivers/net/atlx/atl2.c b/drivers/net/atlx/atl2.c
index f5bdc92..5b292f0 100644
--- a/drivers/net/atlx/atl2.c
+++ b/drivers/net/atlx/atl2.c
@@ -1690,10 +1690,6 @@ static int atl2_resume(struct pci_dev *pdev)
 
 	ATL2_WRITE_REG(&adapter->hw, REG_WOL_CTRL, 0);
 
-	err = atl2_request_irq(adapter);
-	if (netif_running(netdev) && err)
-		return err;
-
	atl2_reset_hw(&adapter->hw);
 
	if (netif_running(netdev))
