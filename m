Return-Path: <linux-kernel-owner+w=401wt.eu-S1754016AbYLZJiJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016AbYLZJiJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 04:38:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753430AbYLZJh4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 04:37:56 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:33601 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753534AbYLZJhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 04:37:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=hE2j9V57r1az08xidcFaoBoFiVY+p5oj2salphbI2YbeKK/Gpxo3ONl2w+v0adj+6o
         o5cwPKkdnUm9x3c6difIieq3oS5nt0q3jwhyjfUT6e/tReRjLlwlZOif4yg0F/nMrEhI
         jl9uq9dA2HRIwedPh6XNRadD7UJAa30RhURNw=
Message-ID: <aa79d98a0812260137l73de751fuffaac6dff3c3a22a@mail.gmail.com>
Date: Fri, 26 Dec 2008 12:37:53 +0300
From: "Cyrill Gorcunov" <gorcunov@gmail.com>
To: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH for -tip] irq: for_each_irq_desc() makes simplify
Cc: "Ingo Molnar" <mingo@elte.hu>, "Yinghai Lu" <yinghai@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20081226101754.85DB.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2f11576a0812250643s25a79de6q205ae3b0a7d63f06@mail.gmail.com>
	 <20081225160109.GA5636@localhost>
	 <20081226101754.85DB.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 26, 2008 at 4:22 AM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>> [KOSAKI Motohiro - Thu, Dec 25, 2008 at 11:43:45PM +0900]
>> | > | "if (!desc) " mean this irqno don't have irq description.
>> | > | so I think this name imply mean skipping no irq desctiption element.
>> | > |
>> | > | Actually, on CONFIG_SPARSEIRQ, desc is filled in dynamically after booting.
>> | > | then "defined" is a bit misleading word.
>> | > |
>> | >
>> | > So if I would need to iterate over all descriptors including empty
>> | > I need to type all this long for(;;) form again?
>> |
>> | We already have for_each_irq_nr() for this purpose ;-)
>>
>> Which is not shorter form of desc iterator in turn :-)
>>
>> Since the original for_each_irq_desc didn't check for NULL
>> desc's I think the better would to name it like for_each_irq_desc_safe
>> or for_each_irq_desc_inuse then.
>
> but before CONFIG_SPARSEIRQ feature age, for_each_irq_desc() guaranteed
> to return !NULL value.
> recently CONFIG_SPARSEIRQ break this assumption. I hope to restore it.

indeed

>
> In addition, if we make both for_each_irq_desc() and for_each_irq_desc().
> for_each_irq_desc() become unused macro.
> from cleanup view, unused function/macro is not preferred.
>

yeah!
