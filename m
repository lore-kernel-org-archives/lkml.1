Return-Path: <linux-kernel-owner+w=401wt.eu-S1759609AbYEMIhC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759609AbYEMIhC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 04:37:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758179AbYEMIgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 04:36:53 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:49903 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757459AbYEMIgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 04:36:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=iSMQtp3CgKWDZv03Y4aq2Y3Qnfn1HM5FFTbkpJMimWHVMyXUDlzcd5YWm/A0hQlMTwMvFiscVTLjKMINBct+7koqvEpONGpyYYKHY2YxyQECRNR6QwWNK/8JENBLq2IShgIsnQY/6lM2e4AQ2FvbJXmjjWiE32/2mffDNFMy9w0=
Message-ID: <386072610805130136n52366cc3u666b93164884fa42@mail.gmail.com>
Date: Tue, 13 May 2008 16:36:51 +0800
From: "Bryan Wu" <cooloney@kernel.org>
To: "Hennerich, Michael" <Michael.Hennerich@analog.com>
Subject: Re: [PATCH 1/1] [bluetooth]: fix bug - kernel warning detected ifbuilt in Bluetooth CF driver
Cc: "Marcel Holtmann" <marcel@holtmann.org>, linux-bluetooth@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <8A42379416420646B9BFAC9682273B6D015A1866@limkexm3.ad.analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1210587779-10257-1-git-send-email-cooloney@kernel.org>
	 <1210597828.16390.44.camel@violet.holtmann.net>
	 <8A42379416420646B9BFAC9682273B6D015A1866@limkexm3.ad.analog.com>
X-Google-Sender-Auth: 462660bb803ebe26
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2008 at 4:20 PM, Hennerich, Michael
<Michael.Hennerich@analog.com> wrote:
>
>
>
>  >-----Original Message-----
>  >From: Marcel Holtmann [mailto:marcel@holtmann.org]
>  >Sent: Montag, 12. Mai 2008 15:10
>  >To: Bryan Wu
>  >Cc: linux-bluetooth@vger.kernel.org; linux-kernel@vger.kernel.org;
>  Michael
>  >Hennerich
>  >Subject: Re: [PATCH 1/1] [bluetooth]: fix bug - kernel warning detected
>  >ifbuilt in Bluetooth CF driver
>  >
>  >Hi Brian,
>  >
>  >> https://blackfin.uclinux.org/gf/project/uclinux-
>  >dist/tracker/?action=TrackerItemEdit&tracker_item_id=2650
>  >>
>  >> Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
>  >> Signed-off-by: Bryan Wu <cooloney@kernel.org>
>  >> ---
>  >>  drivers/bluetooth/bluecard_cs.c |    2 +-
>  >>  1 files changed, 1 insertions(+), 1 deletions(-)
>  >>
>  >> diff --git a/drivers/bluetooth/bluecard_cs.c
>  >b/drivers/bluetooth/bluecard_cs.c
>  >> index bcf5792..3b330a0 100644
>  >> --- a/drivers/bluetooth/bluecard_cs.c
>  >> +++ b/drivers/bluetooth/bluecard_cs.c
>  >> @@ -867,7 +867,7 @@ static int bluecard_probe(struct pcmcia_device
>  *link)
>  >>
>  >>      link->io.Attributes1 = IO_DATA_PATH_WIDTH_8;
>  >>      link->io.NumPorts1 = 8;
>  >> -    link->irq.Attributes = IRQ_TYPE_EXCLUSIVE | IRQ_HANDLE_PRESENT;
>  >> +    link->irq.Attributes = IRQ_TYPE_DYNAMIC_SHARING |
>  IRQ_HANDLE_PRESENT;
>  >>      link->irq.IRQInfo1 = IRQ_LEVEL_ID;
>  >>
>  >>      link->irq.Handler = bluecard_interrupt;
>  >
>  >all Bluetooth PCMCIA drivers use an exclusive IRQ:
>  >
>  >bluecard_cs.c: link->irq.Attributes = IRQ_TYPE_EXCLUSIVE |
>  >IRQ_HANDLE_PRESENT;
>  >bt3c_cs.c:     link->irq.Attributes = IRQ_TYPE_EXCLUSIVE |
>  IRQ_HANDLE_PRESENT;
>  >btuart_cs.c:   link->irq.Attributes = IRQ_TYPE_EXCLUSIVE |
>  >IRQ_HANDLE_PRESENT;
>  >dtl1_cs.c:     link->irq.Attributes = IRQ_TYPE_EXCLUSIVE |
>  IRQ_HANDLE_PRESENT;
>  >
>  >There was a reason for that when these drivers where written. I am not
>  >sure if it is still valid or not. Does anybody at least have tested
>  that
>  >the cards still work if you use a shared IRQ.
>  >
>  >Regards
>  >
>  >Marcel
>
>  Please disregard this patch. It's a leftover and not really necessary.
>  Some time ago the Blackfin PCMCIA driver also requested the Card IRQ in
>  order to shut up some irq handling noise. However this is no longer the
>  case.
>

OK, no problem. I will drop this.

Thanks
-Bryan
