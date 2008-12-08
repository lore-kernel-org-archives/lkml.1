Return-Path: <linux-kernel-owner+w=401wt.eu-S1752525AbYLHTSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525AbYLHTSS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 14:18:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751275AbYLHTSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 14:18:05 -0500
Received: from rv-out-0506.google.com ([209.85.198.228]:8318 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269AbYLHTSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 14:18:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=Jx5Xpmd+kTWG7VD2aHXVkwv6+jjV44eoifdkF6l/R9HkDR6aRtr2daeWbR7v/XnvP2
         ghBlsY0zEq1YRcfmHomVwfLb7jmrdJ7okTMeHxd8dv3X1CCqF7qSKYrckFL9q9FKixct
         dtTrlKOSP2sSruImFHM6j3ez1ADkCuVsrCH+A=
Message-ID: <86802c440812081118u4b29f8bag4224997e1020056d@mail.gmail.com>
Date: Mon, 8 Dec 2008 11:18:01 -0800
From: "Yinghai Lu" <yinghai@kernel.org>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 5/5] irq: move irq_desc according to smp_affinity v5
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20081208134219.GC29965@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1228532430-28958-1-git-send-email-yinghai@kernel.org>
	 <20081208134219.GC29965@elte.hu>
X-Google-Sender-Auth: f5eae976e909afa6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 8, 2008 at 5:42 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
>>                       mask_ack_irq(desc, irq);
>> +#ifdef CONFIG_MOVE_IRQ_DESC
>> +                     /* get new one */
>> +                     desc = irq_to_desc(irq);
>> +#endif
>
> this patch adds a ton of #ifdefs to important .c files, which could all
> have been avoided by introducing a new method:
>
>        desc = irq_remap_to_desc(irq, desc);
>
> which would do something like:
>
>  static struct irq_desc *
>  irq_remap_to_desc(unsigned int irq, struct irq_desc *desc)
>  {
>  #ifdef CONFIG_MOVE_IRQ_DESC
>        return irq_to_desc(irq);
>  #else
>        return desc;
>  #endif
>  }
>
> right?

yes. will work on it.

YH
