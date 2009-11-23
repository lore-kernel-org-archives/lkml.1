Return-Path: <linux-kernel-owner+w=401wt.eu-S1753381AbZKWShB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381AbZKWShB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 13:37:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754200AbZKWShA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 13:37:00 -0500
Received: from exprod6og115.obsmtp.com ([64.18.1.35]:58046 "EHLO
	exprod6og115.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200AbZKWSg7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 13:36:59 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: drivers/ide/au1xxx-ide.c: use resource_size()
Date: Mon, 23 Nov 2009 13:37:05 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190901EE5C0C@mi8nycmail19.Mi8.com>
In-Reply-To: <20091123.102817.157628485.davem@davemloft.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: drivers/ide/au1xxx-ide.c: use resource_size()
Thread-Index: AcpsarQeRT0PCtLFS7WeUOEZJOdKvgAAO/wg
References: <BD79186B4FD85F4B8E60E381CAEE190901EE5BFD@mi8nycmail19.Mi8.com> <20091123.102817.157628485.davem@davemloft.net>
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "David Miller" <davem@davemloft.net>
Cc: <linux-kernel@vger.kernel.org>, <linux-ide@vger.kernel.org>
X-OriginalArrivalTime: 23 Nov 2009 18:37:04.0802 (UTC) FILETIME=[F436E820:01CA6C6B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 23, 2009 11:28 AM, David Miller wrote:
> From: "H Hartley Sweeten" <hartleys@visionengravers.com>
> Date: Mon, 23 Nov 2009 13:15:32 -0500
>
>> Use resource_size() for {request/release}_mem_region and ioremap.
>> 
>> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
>
> Applied to ide-next-2.6, thanks.
>
>>  
>> -	ahwif->regbase = (u32)ioremap(res->start, res->end - res->start + 1);
>> +	ahwif->regbase = (u32)ioremap(res->start, resource_size(res));
>>  	if (ahwif->regbase == 0) {
>>  		ret = -ENOMEM;
>>  		goto out;
>
> That needs some fixing.  ioremap()'s return value is an
> "__iomem" pointer, not an integer.  ->regbase's type should be
> changed to something like "void __iomem *" etc.

Agree.  But that was already in the driver.

I don't have to hardware to test this so I didn't want to dig to deeply
into fixing that.

Thanks,
Hartley
