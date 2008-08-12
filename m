Return-Path: <linux-kernel-owner+w=401wt.eu-S1753450AbYHLJdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450AbYHLJdP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 05:33:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752155AbYHLJc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 05:32:59 -0400
Received: from fk-out-0910.google.com ([209.85.128.188]:49628 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944AbYHLJc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 05:32:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :message-id:from;
        b=IvZMeRKpMpiOXoaGhQP0jJvYdiXzMLg6PI6lRv9ocztNUFOUXF6vu8Nhp5vh+hBxkO
         YWcPhHMhD181hvRr3N106FD3CDNebiT/XvDrlegafGVD/ds80ajX7WebF/JR7NwKc1t8
         u+IbL/anf7FMsRS99zH+NfBNXrpNdSC5ka5JY=
To: John Linville <linville@tuxdriver.com>
Subject: Re: Fixing rt2500pci [PATCH]
Date: Tue, 12 Aug 2008 12:01:26 +0200
User-Agent: KMail/1.9.9
Cc: Peter Chubb <peterc@gelato.unsw.edu.au>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, stable@kernel.org
References: <87tze8vu18.wl%peterc@chubb.wattle.id.au> <200807302115.03865.IvDoorn@gmail.com> <87vdym6fct.wl%peterc@chubb.wattle.id.au>
In-Reply-To: <87vdym6fct.wl%peterc@chubb.wattle.id.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808121201.26544.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 31 July 2008, Peter Chubb wrote:
> 
> In kernel version 2.6.26-rc9 my wireless LAN card worked; but in the
> released 2.6.26, my RaLink rt2500 card wouldn't associate.
> 
> Git-bisect led me to this patch:
> 
> 	61486e0f68d1f8966c09b734566a187d42d65c54
> 	rt2x00: Remove ieee80211_tx_control argument from write_tx_desc()
> 
> I believe that there is a problem with that patch --- it
> (inadvertantly) removes an extra line of code, that used to set the
> DATABYTE_COUNT field.
>  
> This patch reinstates that line, and with it my card works again.
>  
> Signed-off-by: Peter Chubb <peterc@gelato.unsw.edu.au>
> Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

[stable@kernel.org added to CC]

The 2.6.27 version of the patch has already been pushed upstream,
this one is for 2.6.26-stable since this fixes a regression introduced after 2.6.25.

---
> diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
> index 1724ce9..4ba2165 100644
> --- a/drivers/net/wireless/rt2x00/rt2500pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2500pci.c
> @@ -1198,6 +1198,7 @@ static void rt2500pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
>  	rt2x00_set_field32(&word, TXD_W0_IFS, txdesc->ifs);
>  	rt2x00_set_field32(&word, TXD_W0_RETRY_MODE,
>  			   test_bit(ENTRY_TXD_RETRY_MODE, &txdesc->flags));
> +	rt2x00_set_field32(&word, TXD_W0_DATABYTE_COUNT, skbdesc->data_len);
>  	rt2x00_set_field32(&word, TXD_W0_CIPHER_ALG, CIPHER_NONE);
>  	rt2x00_desc_write(txd, 0, word);
>  }
> 
> --
> Dr Peter Chubb  http://www.gelato.unsw.edu.au  peterc AT gelato.unsw.edu.au
> http://www.ertos.nicta.com.au           ERTOS within National ICT Australia
> --
> Dr Peter Chubb  http://www.gelato.unsw.edu.au  peterc AT gelato.unsw.edu.au
> http://www.ertos.nicta.com.au           ERTOS within National ICT Australia
> 


