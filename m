Return-Path: <linux-kernel-owner+w=401wt.eu-S1756223AbZCEJZH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223AbZCEJZH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 04:25:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755720AbZCEJYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 04:24:51 -0500
Received: from wf-out-1314.google.com ([209.85.200.168]:16235 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755649AbZCEJYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 04:24:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=C8E/Nc6F7QMe/9ccGgKS5FJ9gwlYi9wpfXjiOXUcNEukoMWbnhPPpPLDp+Im7az7yD
         ylPH8bXyOfwz5/t4vqxJHtPJC4rqafYypO9v6txQrOCC0P9UA5v7H/JYwhK69WEJ9zmG
         HFybF5+i+NG3hxeOeV3QP25y/HfihSyJcAqG8=
MIME-Version: 1.0
In-Reply-To: <20090226133509.27b58014.akpm@linux-foundation.org>
References: <1235554274-794-1-git-send-email-donari75@gmail.com>
	 <20090226133509.27b58014.akpm@linux-foundation.org>
Date: Thu, 5 Mar 2009 18:24:47 +0900
Message-ID: <57afda040903050124h30bff6fflb9d8dedde966d18c@mail.gmail.com>
Subject: Re: [PATCH] mflash: Initial support
From: unsik Kim <donari75@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org, alan@lxorguk.ukuu.org.uk,
       shdl@zakalwe.fi, harvey.harrison@gmail.com, minchan.kim@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello?

First of all, thanks for your kind review and sorry for very late reply.

>
> Have we fully explored the option of controlling this device with the
> current ATA or IDE code, rather than creating a whole new parallel
> block device implementation?
>

As you see, this driver quite similar with ATA code. (especially PATA
platform device driver) I think integrating with ATA is possible. But, I
think integration is not adequate at this time.

Because,

1. ATA layer deals standard ATA protocol. ATA layer have many low-
level device specific interface, but data transfer keeps ATA rule. But,
mflash IO mode doesn't.

2. Even though currently not used in mflash driver code, mflash has
some custom command and modes. (nand fusing, firmware patch,
etc) If this feature supported in linux kernel, ATA layer more altered.

3. Currently PATA platform device driver doesn't support interrupt.
(I'm not sure) But, mflash uses interrupt (polling mode is just for debug).

4. mflash is somewhat under-develop product. Even though some
company already using mflash their own product, I think more time is
needed for standardization of custom command and mode. That time
(maybe October) I will talk to with ATA people. If they accept integration,
I will integrate.

All the other requests will be reflected with upcoming patch.

-- 
unsik Kim <donari75@gmail.com>
