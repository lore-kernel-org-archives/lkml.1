Return-Path: <linux-kernel-owner+w=401wt.eu-S1756532AbZCDXr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532AbZCDXr1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 18:47:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755846AbZCDXrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 18:47:08 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:7318 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755613AbZCDXrF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 18:47:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=WU7JvGU45/EOTv8d3+sEXA+VmGCgR4ZXlSiSnO8E2awHQNdmVimJns1+jFQO2R/sy1
         GBbS80OTmFCN/967qUlz/JLobWy1qA4qMaIBwXdWtFRYoZ2M0rjF0PzAdKz/xHf0080J
         rVbgZnafESwyBmM4PzmkDyzsrHBN7J9UJe1Wc=
MIME-Version: 1.0
In-Reply-To: <20090304085055.c9de6cbb.akpm@linux-foundation.org>
References: <20090303063605.GA30258@july>
	 <20090303124948.dda294e5.akpm@linux-foundation.org>
	 <49AE6907.1080702@nokia.com>
	 <20090304085055.c9de6cbb.akpm@linux-foundation.org>
Date: Thu, 5 Mar 2009 08:47:03 +0900
X-Google-Sender-Auth: e0cbda60d8e887af
Message-ID: <9c9fda240903041547x540899f9hd94cbf49baac660b@mail.gmail.com>
Subject: Re: [PATCH 1/3] [MTD] Flex-OneNAND support
From: Kyungmin Park <kmpark@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Adrian Hunter <adrian.hunter@nokia.com>,
       Rohit Hagargundgi <h.rohit@samsung.com>,
       "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Mar 5, 2009 at 1:50 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Wed, 04 Mar 2009 13:41:59 +0200 Adrian Hunter <adrian.hunter@nokia.com> wrote:
>
>> Andrew Morton wrote:
>> >> ...
>> >>
>> >> +static loff_t flexonenand_get_addr(struct onenand_chip *this, int block)
>> >> +{
>> >> +  loff_t ofs = 0;
>> >> +  int die = 0, boundary;
>> >> +
>> >> +  if (ONENAND_IS_DDP(this) && block >= this->density_mask) {
>> >> +          block -= this->density_mask;
>> >> +          die = 1;
>> >> +          ofs = this->diesize[0];
>> >> +  }
>> >> +
>> >> +  boundary = this->boundary[die];
>> >> +  ofs += block << (this->erase_shift - 1);
>> >> +  if (block > (boundary + 1))
>> >> +          ofs += (block - boundary - 1) << (this->erase_shift - 1);
>> >
>> > Both `block' and `boundary' have 32-bit types.  Are you sure that the
>> > left-shift cannot overflow?
>>
>> Only very recently has MTD supported sizes greater than 32 bits internally
>> for any type of flash.  The external APIs (ioctls) are still 32-bit based.
>>
>> For this driver, supporting sizes over 32-bits is a separate issue - and
>> may never be needed.
>
> So it doesn't support files >4G?  What's the max device size (now and
> projected)?

Umm it's not simple question. basically Flex-OneNAND based on NAND
flash technology. It means if NAND flash technology are advanced, it
can also get more size. Currently max Flex-OneNAND has 16 Gib (2GiB)
So it will be exceed the 4GiB soon. but I'm not sure when this device is opened.
I think we know the issues currently and then if the device is opened,
handle this one if required.
How do you think?

Thank you,
Kyungmin Park
