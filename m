Return-Path: <linux-kernel-owner+w=401wt.eu-S1751744AbXEAPcJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751744AbXEAPcJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 11:32:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751821AbXEAPcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 11:32:09 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:19807 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbXEAPcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 11:32:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=EvVbVg6zoryM+rZ36X+NgfdFe65l742ZkDf9XexYp4PBho98blN0jMC1gUEUbfpuyIndo1zlbNYVY7Xyf9eVkHD3rTLqsnmeKj0O4B7gVlErFDRuuK7tg+S7IGQh1bpXakofh+IQksP+zMJNecnoj6zHkLHvGD1+c8JRO5tDrbs=
Message-ID: <46375D27.3060901@gmail.com>
Date: Tue, 01 May 2007 17:30:47 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: jeff@garzik.org, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] libata-sff: Undo bug introduced with pci_iomap changes
References: <20070501125327.52dd92e4@the-village.bc.nu>
In-Reply-To: <20070501125327.52dd92e4@the-village.bc.nu>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Alan.

Alan Cox wrote:
> If you have a controller with one channel disabled and unmapped the new
> iomap code blindly tries to iomap unconfigured BARs. Later on the code
> does the right thing and checks for unmapped bars but it is done in the
> wrong order
> 
> Reorder the checks and make the iomap conditional
> 
> Tejun: I think the code below is now correct but would appreciate you
> giving it a review.
>
> Signed-off-by: Alan Cox <alan@redhat.com>

Acked-by: Tejun Heo <htejun@gmail.com>

Yeap, the patch looks good.  I got tunnel visioned while converting to
iomap and mechanically mapped IO BAR access to iomap.  Thanks for
catching this.  This is already fixed in #upstream while converting to
new-init-model (the code is in ata_pci_init_native_host() and does about
the same thing as your patch does), so I think this patch is only needed
for -stable.  Cc'ing stable team.  The original patch can be reached at...

  http://article.gmane.org/gmane.linux.kernel/523335/raw

Thanks.

-- 
tejun
