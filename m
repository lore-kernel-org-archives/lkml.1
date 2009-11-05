Return-Path: <linux-kernel-owner+w=401wt.eu-S1758464AbZKESli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758464AbZKESli (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 13:41:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758453AbZKESlh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 13:41:37 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:49531 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758446AbZKESle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 13:41:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=NVUH7+HzFjpIvhhRUUYSQMVZNHrUbGKuselBjcTSuSXmlJYvCJQYC17BSgMGWs7lxK
         Yk1QqwceS7oYaafULSeqytERfDWLJvCHmsUPRO45LBpBzjnF0bc97NLJC4QT5zNX5uqW
         CDE/1wHCsooY11iNS9Fm+L7TLg0i7l3pQ7/ao=
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH 04/41] rt2800pci: fix crypto in TX frame
Date: Thu, 5 Nov 2009 19:41:36 +0100
User-Agent: KMail/1.9.10
Cc: linux-wireless@vger.kernel.org, Gertjan van Wingerde <gwingerde@gmail.com>,
       linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain> <20091104173224.28463.49296.sendpatchset@localhost.localdomain>
In-Reply-To: <20091104173224.28463.49296.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911051941.36666.IvDoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 November 2009, Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] rt2800pci: fix crypto in TX frame
> 
> Based on rt2800usb patch from Benoit PAPILLAULT
> (commit 17616310836ad2cc45a64576ef0e1520b0dcc81b).
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2800pci.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: b/drivers/net/wireless/rt2x00/rt2800pci.c
> ===================================================================
> --- a/drivers/net/wireless/rt2x00/rt2800pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2800pci.c
> @@ -2195,7 +2195,7 @@ static void rt2800pci_write_tx_desc(stru
>  	rt2x00_set_field32(&word, TXWI_W1_BW_WIN_SIZE, txdesc->ba_size);
>  	rt2x00_set_field32(&word, TXWI_W1_WIRELESS_CLI_ID,
>  			   test_bit(ENTRY_TXD_ENCRYPT, &txdesc->flags) ?
> -			       (skbdesc->entry->entry_idx + 1) : 0xff);
> +			   txdesc->key_idx : 0xff);
>  	rt2x00_set_field32(&word, TXWI_W1_MPDU_TOTAL_BYTE_COUNT,
>  			   skb->len - txdesc->l2pad);
>  	rt2x00_set_field32(&word, TXWI_W1_PACKETID,
> 


