Return-Path: <linux-kernel-owner+w=401wt.eu-S1755376AbZAEW2M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376AbZAEW2M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 17:28:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752271AbZAEW1z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 17:27:55 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:35257 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545AbZAEW1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 17:27:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=HfHJ94xxYK2dCD7EX6t1DxrT49A0f2q3zL0Z8r8wQ2kvB8BH0FCmtjxKait6FxVi1Z
         w0keqX+edj/aXBBFcdNDK8kWXX+KMYIAph59/tVQ5xvU4ZrVNEqB3iyuVOe3Ho9OOnxz
         uf7jCwE5lGPbQ07cekgGyQJh/cNwtfbCb+1FU=
Message-ID: <49628964.806@gmail.com>
Date: Mon, 05 Jan 2009 23:27:48 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Dave <kilroyd@googlemail.com>
CC: Andrey Borzenkov <arvidjaar@mail.ru>, orinoco-devel@lists.sourceforge.net,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.28: warn_slowpath in orinoco receive path
References: <200901052005.12428.arvidjaar@mail.ru> <49626E4D.3010705@gmail.com>
In-Reply-To: <49626E4D.3010705@gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2009 09:32 PM, Dave wrote:
> --- a/drivers/net/wireless/orinoco/orinoco.c
> +++ b/drivers/net/wireless/orinoco/orinoco.c
> @@ -1616,9 +1616,15 @@ static void orinoco_rx_isr_tasklet(unsigned long
> data)
> 
>         /* extract desc and skb from queue */
>         list_for_each_entry_safe(rx_data, temp, &priv->rx_list, list) {
> +               unsigned long flags;
> +
>                 desc = rx_data->desc;
>                 skb = rx_data->skb;
> +
> +               local_irq_save(flags);
>                 list_del(&rx_data->list);
> +               local_irq_restore(flags);
> +

Hi,

another processor still can see inconsistent state, spinlock should be taken.
Or, am I missing something?

regards,
--js
