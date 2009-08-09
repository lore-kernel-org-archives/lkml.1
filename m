Return-Path: <linux-kernel-owner+w=401wt.eu-S1752916AbZHIUay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752916AbZHIUay (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 16:30:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752468AbZHIUay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 16:30:54 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:20793 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887AbZHIUax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 16:30:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=MMY32JjvTO87RXBCy/gYL8oiOhOLQ4ybGdcF1T9HOTx2JFReBlJsicGqRizxF1Nkm+
         gbfMZd+xCizQAQutpxdNujECb6y+ZXVPsbaO/+nd6pWst40MIFcENUsuN+8TXcfAKlm3
         e2oveXlIcdqZirq6Yr1f7+0IBSJyxdpmqZ+LE=
Message-ID: <4A7F31F6.9000706@gmail.com>
Date: Sun, 09 Aug 2009 22:30:46 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090715 SUSE/3.0b3-7.3 Thunderbird/3.0b3
MIME-Version: 1.0
To: Roel Kluin <roel.kluin@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] applicom: Prevent unsigned wrap in ac_interrupt()
References: <4A7D961A.1020303@gmail.com>
In-Reply-To: <4A7D961A.1020303@gmail.com>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2009 05:13 PM, Roel Kluin wrote:
> unsigned i wraps if this occurs in the first iteration.

Could you elaborate? I don't quite understand the point.

> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> Or do we know this can't happen?

You mean the i--? It's followed by i++ in the for loop 3rd expression. Or?

> 
> diff --git a/drivers/char/applicom.c b/drivers/char/applicom.c
> index 73a0765..0df3e12 100644
> --- a/drivers/char/applicom.c
> +++ b/drivers/char/applicom.c
> @@ -670,7 +670,7 @@ static irqreturn_t ac_interrupt(int vec, void *dev_instance)
>  			}
>  			Dummy = readb(apbs[i].RamIO + VERS);
>  
> -			if(readb(apbs[i].RamIO + RAM_IT_TO_PC)) {
> +			if(i && readb(apbs[i].RamIO + RAM_IT_TO_PC)) {
>  				/* There's another int waiting on this card */
>  				spin_unlock(&apbs[i].mutex);
>  				i--;
