Return-Path: <linux-kernel-owner+w=401wt.eu-S968080AbXEHV0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968080AbXEHV0A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 17:26:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967896AbXEHVZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 17:25:54 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:37118 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968019AbXEHVZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 17:25:51 -0400
Message-ID: <4640EAD4.9010106@garzik.org>
Date: Tue, 08 May 2007 17:25:40 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Krzysztof Halasa <khc@pm.waw.pl>,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Sokolovsky <pmiscml@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH] doc: volatile considered evil
References: <516386418.20070501080839@gmail.com>	<20070430235642.e576e917.akpm@linux-foundation.org>	<20070508121404.17bd97a6.randy.dunlap@oracle.com>	<alpine.DEB.0.99.0705081217180.12908@chino.kir.corp.google.com> <m3k5vj2iha.fsf@maximus.localdomain> <4640E62D.8060704@goop.org> <4640E8C4.4000603@garzik.org> <4640EB19.6030005@oracle.com>
In-Reply-To: <4640EB19.6030005@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> Jeff Garzik wrote:
>> Jeremy Fitzhardinge wrote:
>>> No, David means that "asm volatile (...)" is meaningful and OK to use.
> 
> I thought it was OK in readl(), writel(), etc... (and in asm),
> but that's it.  (and jiffies)
> 
>> In a driver?  Highly unlikey it is OK.  In a filesystem?  Even more 
>> unlikely it is OK to use.
>>
>> The set of circumstances where 'volatile' is acceptable is very limited.
>>
>> You will see it used properly in the definitions of writel(), for 
>> example.  But most drivers using 'volatile' are likely bugs.


Not sure how to interpret your top-posted response :)

It is normal in the definition of writel(), in arch code, but 
inappropriate in drivers when they _use_ writel().

If I may generalize, arch code generally knows what it's doing, when it 
uses volatile.  OTOH, driver authors that use volatile generally do 
/not/ know what they are doing.

	Jeff


