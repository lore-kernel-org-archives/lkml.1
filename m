Return-Path: <linux-kernel-owner+w=401wt.eu-S1756850AbZKWUUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756850AbZKWUUW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 15:20:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756113AbZKWUUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 15:20:21 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50524
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755589AbZKWUUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 15:20:20 -0500
Date: Mon, 23 Nov 2009 12:20:38 -0800 (PST)
Message-Id: <20091123.122038.64001211.davem@davemloft.net>
To: hartleys@visionengravers.com
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: drivers/ide/au1xxx-ide.c: use resource_size()
From: David Miller <davem@davemloft.net>
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE190901EE5C3E@mi8nycmail19.Mi8.com>
References: <BD79186B4FD85F4B8E60E381CAEE190901EE5C0C@mi8nycmail19.Mi8.com>
	<20091123.103810.44071453.davem@davemloft.net>
	<BD79186B4FD85F4B8E60E381CAEE190901EE5C3E@mi8nycmail19.Mi8.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H Hartley Sweeten" <hartleys@visionengravers.com>
Date: Mon, 23 Nov 2009 15:01:02 -0500

> On Monday, November 23, 2009 11:38 AM, David Miller wrote:
>>>  
>>> -	ahwif->regbase = (u32)ioremap(res->start, res->end - res->start + 1);
>>> +	ahwif->regbase = (u32)ioremap(res->start, resource_size(res));
>>>  	if (ahwif->regbase == 0) {
>>>  		ret = -ENOMEM;
>>>  		goto out;
>>
>> That needs some fixing.  ioremap()'s return value is an
>> "__iomem" pointer, not an integer.  ->regbase's type should be
>> changed to something like "void __iomem *" etc.
> 
> FWIW, following is an updated patch that fixes the "__iomem" pointer.

Please, I've already applied your resource_size() patch, and you
should submit a seperate patch relative to that in order to address
the ioremap() pointer issues.

Thank you.
