Return-Path: <linux-kernel-owner+w=401wt.eu-S1752715AbXFWGWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715AbXFWGWT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 02:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751481AbXFWGWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 02:22:11 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:36246 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbXFWGWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 02:22:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=GAA2m8O6QMt5jbqEjxDyNFKTLWLk8p6RFCM/Qe8Tn6INwlczwkN7cRUKpriETt2vNmsXbXeMkk696mGHMI0OvoMUZvQYA1lREVt9PfCjRL0ziLq425USzIrorLQqPXUwVTx/SzVz4UI5J+CstbRNPojW9ISOnfBk0aeMTmXYyuw=
Message-ID: <467CBC0C.6030001@gmail.com>
Date: Sat, 23 Jun 2007 15:22:04 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Carlo Wood <carlo@alinoe.com>, Jeff Garzik <jeff@garzik.org>,
       Tejun Heo <htejun@gmail.com>, Manoj Kasichainula <manoj@io.com>,
       linux-kernel@vger.kernel.org
Subject: Re: SATA RAID5 speed drop of 100 MB/s
References: <20070620224847.GA5488@alinoe.com> <4679B2DE.9090903@garzik.org> <20070622214410.GB6970@alinoe.com> <20070623035451.GA5522@alinoe.com>
In-Reply-To: <20070623035451.GA5522@alinoe.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Carlo Wood wrote:
> For what it's worth... I tried applying
> 
> --- a/drivers/ata/ahci.c
> +++ b/drivers/ata/ahci.c
> @@ -516,6 +516,8 @@ static void ahci_save_initial_config(struct pci_dev *pdev,
>          * reset.  Values without are used for driver operation.
>          */
>         hpriv->saved_cap = cap = readl(mmio + HOST_CAP);
> +       hpriv->saved_cap &= ( (1<<28) | (1<<17) );
> +       hpriv->saved_cap |= (1 << 27);
>         hpriv->saved_port_map = port_map = readl(mmio + HOST_PORTS_IMPL);

Hmmm... That's super-odd.  You win my oddest-of-the-month award.  :-)

I'll think about it a bit.  Please stand by.

-- 
tejun
