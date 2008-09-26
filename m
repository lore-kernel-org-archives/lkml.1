Return-Path: <linux-kernel-owner+w=401wt.eu-S1754313AbYIZFbM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313AbYIZFbM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 01:31:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752316AbYIZFa4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 01:30:56 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:59627 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063AbYIZFaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 01:30:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=wgKqInjdkTnZIvMpJgDYjSVii9fYU3T6o1F/E8Fu862bDSGKs5buv3xdoDXvbE0jK4
         SDxW0PX50zuVLUpeETpMaPN1nHImeAm7w4SO+HaHVGWn4IwZ14Rqi2AEVdILo9eiPD8F
         HODAve6Nz8QLyuolHEzLTYyilhVo7LQms+fTc=
Message-ID: <9c9fda240809252230s6373acf8v4dd2b942eba360a7@mail.gmail.com>
Date: Fri, 26 Sep 2008 14:30:54 +0900
From: "Kyungmin Park" <kmpark@infradead.org>
To: dedekind@infradead.org
Subject: Re: [ANNOUNCE] [PATCH] [MTD] Flex-OneNAND MTD Driver available.
Cc: apgmoorthy <moorthy.apg@samsung.com>,
       "Kyungmin Park" <kyungmin.park@samsung.com>,
       linux-mtd@lists.infradead.org, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1222404711.5012.5.camel@sauron>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19198934.52871221827459790.JavaMail.weblogic@epml16>
	 <9c9fda240809220011w49c0875q804f836550ff3476@mail.gmail.com>
	 <000001c91e42$1aa86c50$3dd66c6b@sisodomain.com>
	 <9c9fda240809251731y48272a63j988e0001dc50d78@mail.gmail.com>
	 <1222404711.5012.5.camel@sauron>
X-Google-Sender-Auth: ea40c1d7ea5610ca
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

>>
>>
>> > diff -uprN a/include/mtd/mtd-abi.h b/include/mtd/mtd-abi.h
>> > --- a/include/mtd/mtd-abi.h     2008-09-16 20:48:12.000000000 +0530
>> > +++ b/include/mtd/mtd-abi.h     2008-09-24 14:09:06.000000000 +0530
>> > @@ -102,7 +102,11 @@ struct nand_oobinfo {
>> >        uint32_t useecc;
>> >        uint32_t eccbytes;
>> >        uint32_t oobfree[8][2];
>> > +#ifdef CONFIG_MTD_ONENAND
>> > +       uint32_t eccpos[128];
>> > +#else
>> >        uint32_t eccpos[32];
>> > +#endif
>> >  };
>> >
>> >  struct nand_oobfree {
>> > @@ -117,7 +121,11 @@ struct nand_oobfree {
>> >  */
>> >  struct nand_ecclayout {
>> >        uint32_t eccbytes;
>> > +#ifdef CONFIG_MTD_ONENAND
>> > +       uint32_t eccpos[128];
>> > +#else
>> >        uint32_t eccpos[64];
>> > +#endif
>> >        uint32_t oobavail;
>> >        struct nand_oobfree oobfree[MTD_MAX_OOBFREE_ENTRIES];
>> >  };
>
> I do not think stuff like this is going to be accepted because you
> change ABI. You should instead introduce new ioctls or add sysfs
> support and expose this information via sysfs. This is much bigger
> work, but it is needed.
>

Thank you for your kind comments.

Yes that's I concerned it breaks the other NAND ABI. Actually In
OneNAND it doesn't use eccpos since OneNAND controller handle all ECC
functions. we don't need to concern it.

As pages are bigger, it requires more eccpos and other fields are
similar. we need more flexible filed definitions.

Well how do you think that at this time it only describes the 64 bytes
only for temporarily and next time it adds remaining parts if it is
really needed.

Thank you,
Kyungmin Park
