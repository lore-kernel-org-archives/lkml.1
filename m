Return-Path: <linux-kernel-owner+w=401wt.eu-S1756763AbZEQJAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763AbZEQJAl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 05:00:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753871AbZEQJAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 05:00:30 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:33129 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753869AbZEQJA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 05:00:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=fIBsH/xbLwju0oOEIgjrvezjoJ61d8+JkKbP/TOX4R0VybfYBmmsuNCm6Qm+B+vBmz
         JNDD3drqUfORTsDrpxe83lIUubMPWBWYTHKAHoWgyUXCDUrJM0Zp0U1trBZnJC06CKQp
         heK/oZguqa2ZcP933UVe+Q5qdkj+87RLCiMS4=
Message-ID: <4A0FD229.9010401@gmail.com>
Date: Sun, 17 May 2009 03:00:25 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Tejun Heo <htejun@gmail.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       alan@lxorguk.ukuu.org.uk, flar@allandria.com,
       schmitz@biophys.uni-duesseldorf.de, linux-kernel@vger.kernel.org,
       jgarzik@pobox.com, linux-ide@vger.kernel.org, takata@linux-m32r.org,
       geert@linux-m68k.org, linux-m68k@vger.kernel.org,
       ysato@users.sourceforge.jp
Subject: Re: [PATCH] ata: libata depends on HAS_DMA
References: <20090513043409.GA13577@cynthia.pants.nu> <200905151316.31521.arnd@arndb.de> <4A0D5051.90708@gmail.com> <200905151355.09888.arnd@arndb.de>
In-Reply-To: <200905151355.09888.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Friday 15 May 2009, Tejun Heo wrote:
>> Don't know much history here but I don't wanna sprinkle ifdefs around
>> in libata so I would much prefer dummy implementation which doesn't
>> fail compile.
> 
> My original patch did that by adding 'depends on HAS_DMA'.
> 
> The only architectures that don't have that are m68k, m32r,
> h8300, s390 and microblaze. More research has shown that
> they all found a different way to disable the ATA drivers
> already, except microblaze.
> 
> Alan, you objected the patch initially (and loudly), but
> maybe you can reconsider this. The only actual effect
> that my patch has is to allow an allyesconfig build on
> microblaze and that will implement dma-mapping.h in the
> next version.
> 
> All existing architectures do not care at all about this
> change, unless I'm missing something.
> 
> Besides, all the other users of the DMA mapping API
> also depend on CONFIG_HAS_DMA.

Yes, it fixes the compile problem by preventing libata from being 
compiled at all. But the point is that libata should be able to work 
without DMA support.
