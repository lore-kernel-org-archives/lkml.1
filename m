Return-Path: <linux-kernel-owner+w=401wt.eu-S1760154AbYHBUJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760154AbYHBUJl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 16:09:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757490AbYHBUJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 16:09:32 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:50417 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757384AbYHBUJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 16:09:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=CgpJNh8ghnKSJkl+W1mxInCoD6f3rpwiGoLHTkPxUhJNRZEjb/wcFd5rxW8ri4fQYi
         ihIzmhS5LDKleDIbp8lgD7dv4VwY55t0m/3wG1HyDBeyIrgaSMvRn5ND43f1ICL8tfwp
         +DHidnbI3tWjruRwIAF0UVlSPfqQ2uxd5o8TE=
Message-ID: <6101e8c40808021309r7de3cd31r11eb707b14c92fc4@mail.gmail.com>
Date: Sat, 2 Aug 2008 22:09:29 +0200
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Willy Tarreau" <w@1wt.eu>
Subject: Re: [RFC, 2.6.26.2-rc1] fs/partition/check.c: fix return value warning
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Abdel Benamrouche" <draconux@gmail.com>, stable@kernel.org,
       jens.axboe@oracle.com, "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080802200448.GH615@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200808022202.48079.oliver.pntr@gmail.com>
	 <alpine.LFD.1.10.0808021254190.3874@nehalem.linux-foundation.org>
	 <20080802200448.GH615@1wt.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Willy, this good to know ...

and I think, this patch fixed a small leak:

+
+out2:
+       device_del(&p->dev);
+out1:
+       put_device(&p->dev);
+       free_part_stats(p);
+out0:
+       kfree(p);
+       return err;


On 8/2/08, Willy Tarreau <w@1wt.eu> wrote:
> On Sat, Aug 02, 2008 at 12:56:10PM -0700, Linus Torvalds wrote:
>> Please don't just send patches to the stable team because they "look
>> fine". They should be real bugs, with real consequences. And no, a
>> compiler warning is not a real consequence.
>
> BTW, before Oliver does the mistake, I'd suggest never forwarding
> network patches to stable either as Davem already maintains his
> own -stable queue ;-)
>
> Willy
>
>


-- 
Thanks,
Oliver
