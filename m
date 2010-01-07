Return-Path: <linux-kernel-owner+w=401wt.eu-S1754040Ab0AGVNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040Ab0AGVNV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 16:13:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753616Ab0AGVNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 16:13:20 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:42095 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601Ab0AGVNU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 16:13:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Gg+bQCtDUuT4/rY/6PEoWyB24NeQ50NrqQ8T8wEjRyGUclOLgINmEHhrr3MDut/TeD
         IIVkO6sSj8nQomeNUzwd7vmsXQRImqpAlfAcKEDZx3/m+t62ZBfeKoYdT7ZnCMbyMS6B
         FiuQZt/ovMwFFEZXwoluQnSdCq6erIzQIcNxo=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1001072037170.13474@eddie.linux-mips.org>
References: <BD79186B4FD85F4B8E60E381CAEE19090208954A@mi8nycmail19.Mi8.com>
	 <1262888625.10429.23.camel@Joe-Laptop.home>
	 <alpine.LFD.2.00.1001072037170.13474@eddie.linux-mips.org>
Date: Thu, 7 Jan 2010 22:13:18 +0100
Message-ID: <e2d7436a1001071313r6f5814c9o9d7b2d1c6e162367@mail.gmail.com>
Subject: Re: [PATCH] lib/vsprintf.c: Add %pMF to format FDDI bit reversed MAC 
	addresses
From: =?ISO-8859-2?Q?Micha=B3_Miros=B3aw?= <mirqus@gmail.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Joe Perches <joe@perches.com>,
       H Hartley Sweeten <hartleys@visionengravers.com>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/1/7 Maciej W. Rozycki <macro@linux-mips.org>:
> On Thu, 7 Jan 2010, Joe Perches wrote:
>> On Mon, 2010-01-04 at 23:43 +0000, Maciej W. Rozycki wrote:
>> > The example below shows an address, and the sequence of bits or symbols
>> > that would be transmitted when the address is used in the Source Address
>> > or Destination Address fields on the MAC header.  The transmission line
>> > shows the address bits in the order transmitted, from left to right.  For
>> > IEEE 802 LANs these correspond to actual bits on the medium.  The FDDI
>> > symbols line shows how the FDDI PHY sends the address bits as encoded
>> > symbols.
>> >
>> >         MSB:            35:7B:12:00:00:01
>> >         Canonical:      AC-DE-48-00-00-80
>> >         Transmission:   00110101 01111011 00010010 00000000 00000000 00000001
>> >         FDDI Symbols:   35 7B 12 00 00 01"
>> >
>> > Please note that this address has its group bit clear.
>> >
>> >  This notation is also defined in the "FDDI MEDIA ACCESS CONTROL-2
>> > (MAC-2)" (X3T9/92-120) document although that book does not have a need
>> > to use the MSB form and it's skipped.
>>
>> Adds 56 bytes to object size
>>
>> New:
>> $ size lib/vsprintf.o
>>    text          data     bss     dec     hex filename
>>    8714             0       2    8716    220c lib/vsprintf.o
>> old:
>> $ size lib/vsprintf.o
>>    text          data     bss     dec     hex filename
>>    8658             0       2    8660    21d4 lib/vsprintf.o
>
>  What's the gain?  I'd be rather conservative when taking everybody's 56
> bytes for one or two drivers hardly anybody uses.  The format of MAC
> addresses is unlikely to change, so I'd say the sources can live with
> one or two places where the strings are formatted manually.  Even if the
> drivers lose more than these 56 bytes.

Maybe this can be Kconfig-selected by the relevant drivers then?

BTW, the gain is of course consistency and code readability.

Best Regards,
Micha³ Miros³aw
