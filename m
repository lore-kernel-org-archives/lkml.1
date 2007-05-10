Return-Path: <linux-kernel-owner+w=401wt.eu-S1758888AbXEJJne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758888AbXEJJne (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 05:43:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756859AbXEJJn1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 05:43:27 -0400
Received: from wr-out-0506.google.com ([64.233.184.224]:6818 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753827AbXEJJn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 05:43:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=IgRdptkqVE2D9nn2G8Vpo2fuZLqQTSho9MjD+5bKL2MMEyjRDi70HDMZqA+xnymOyZQQf3MmFM1RL0ouNZ7fSXp8rmDaf3nTc7sHdDVAWi5F6pmaDRRrLXuYdmOrRqBc1GNdkV0/vl0zxSVPzeiE1PBsDd7vk1t3JV9Vg5CWdGg=
Message-ID: <4642E92D.5010509@gmail.com>
Date: Thu, 10 May 2007 11:43:09 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] libata: add human-readable error value decoding
References: <46428103.3040003@shaw.ca>
In-Reply-To: <46428103.3040003@shaw.ca>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> This adds human-readable decoding of the ATA status and error registers
> (similar
> to what drivers/ide does) as well as the SATA Serror register to libata
> error
> handling output. This prevents the need to pore through standards documents
> to figure out the meaning of the bits in these registers when looking at
> error
> reports. Some bits that drivers/ide decoded are not decoded here, since
> the bits
> are either command-dependent or obsolete, and properly parsing them
> would add
> too much complexity.
> 
> Signed-off-by: Robert Hancock <hancockr@shaw.ca>
> 
> --- linux-2.6.21.1/drivers/ata/libata-eh.c    2007-04-27
> 15:49:26.000000000 -0600
> +++ linux-2.6.21.1edit/drivers/ata/libata-eh.c    2007-05-09
> 19:47:53.000000000 -0600
> @@ -1523,6 +1523,27 @@ static void ata_eh_report(struct ata_por
>             ata_port_printk(ap, KERN_ERR, "(%s)\n", desc);
>     }
> 
> +    if (ehc->i.serror)
> +        ata_port_printk(ap, KERN_ERR,
> +          "SError: {%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s}\n",
> +          ehc->i.serror & SERR_DATA_RECOVERED ? "RecovDataErr " : "",
> +          ehc->i.serror & SERR_COMM_RECOVERED ? "RecovCommErr " : "",
> +          ehc->i.serror & SERR_DATA ? "UnrecovDataErr " : "",
> +          ehc->i.serror & SERR_PERSISTENT ? "PersistErr " : "",
> +          ehc->i.serror & SERR_PROTOCOL ? "ProtocolErr " : "",
> +          ehc->i.serror & SERR_INTERNAL ? "HostInternalErr " : "",
> +          ehc->i.serror & SERR_PHYRDY_CHG ? "PHYRdyChg " : "",
> +          ehc->i.serror & SERR_PHY_INT_ERR ? "PHYInternalErr " : "",
> +          ehc->i.serror & SERR_COMM_WAKE ? "CommWake " : "",
> +          ehc->i.serror & SERR_10B_8B_ERR ? "10B8BErr " : "",
> +          ehc->i.serror & SERR_DISPARITY ? "Disparity " : "",
> +          ehc->i.serror & SERR_CRC ? "CRCErr " : "",
> +          ehc->i.serror & SERR_HANDSHAKE ? "HandshakeErr " : "",
> +          ehc->i.serror & SERR_LINK_SEQ_ERR ? "LinkSeqErr " : "",
> +          ehc->i.serror & SERR_TRANS_ST_ERROR ? "TransStatTransErr " : "",
> +          ehc->i.serror & SERR_UNRECOG_FIS ? "UnrecogFIS " : "",
> +          ehc->i.serror & SERR_DEV_XCHG ? "DevExchanged " : "" );

I'm not really convinced whether this is necessary.  The human readable
form is also a bit cryptic and can get quite long.  So, mild NACK from me.

-- 
tejun
