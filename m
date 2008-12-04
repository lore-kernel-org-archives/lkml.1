Return-Path: <linux-kernel-owner+w=401wt.eu-S1756268AbYLDN4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756268AbYLDN4S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 08:56:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754557AbYLDNz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 08:55:59 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:8030 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754459AbYLDNz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 08:55:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=PqVnIFrIcviKRAyTpOaKUiTSd0jKLi/aCIsilHRuaCOCJ4fLB0ASB0VD4CMQIjc3Ff
         8E2sjVqimQapjiEwOxVVnsr3s4kp8Jejfj0Vq1/5JQH3Tu517fb7nYaALvYWCSJJaIc+
         W00s8ShwSFvytdrWJJqyIFdCDj7WXj11kb/mA=
Date: Thu, 4 Dec 2008 17:00:10 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, tiwai@suse.de
Subject: next-2008-12-04: ca0106 compile fix
Message-ID: <20081204140010.GA13953@x200.localdomain>
References: <20081204200745.eff0ac87.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081204200745.eff0ac87.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please, fold into 2c5dd6425e72a6e97d9fb9fee9910a58f02d77df
aka "ALSA: ca0106 - Add power-amangement support"
			      ^^

  CC [M]  sound/pci/ca0106/ca0106_main.o
sound/pci/ca0106/ca0106_main.c:1809: error: 'snd_ca0106_suspend' undeclared here (not in a function)
sound/pci/ca0106/ca0106_main.c:1810: error: 'snd_ca0106_resume' undeclared here (not in a function)

--- a/sound/pci/ca0106/ca0106_main.c
+++ b/sound/pci/ca0106/ca0106_main.c
@@ -1806,8 +1806,10 @@ static struct pci_driver driver = {
 	.id_table = snd_ca0106_ids,
 	.probe = snd_ca0106_probe,
 	.remove = __devexit_p(snd_ca0106_remove),
+#ifdef CONFIG_PM
 	.suspend = snd_ca0106_suspend,
 	.resume = snd_ca0106_resume,
+#endif
 };
 
 // initialization of the module
