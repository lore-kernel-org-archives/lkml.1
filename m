Return-Path: <linux-kernel-owner+w=401wt.eu-S1760305AbYBVQco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760305AbYBVQco (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 11:32:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759892AbYBVQc1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 11:32:27 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34381 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759854AbYBVQcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 11:32:17 -0500
Message-ID: <47BEF7D9.50300@zytor.com>
Date: Fri, 22 Feb 2008 08:27:05 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Ian Campbell <ijc@hellion.org.uk>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Joel Becker <Joel.Becker@oracle.com>, Jody Belka <lists-lkml@pimb.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Mika Penttila <mika.penttila@kolumbus.fi>
Subject: Re: 2.6.25-rc1 xen pvops regression
References: <20080212235404.GY7980@pimb.org>	<47B2DBA5.6030001@goop.org>	<20080214022744.GA4160@mail.oracle.com>	<47B3F2DC.8080707@goop.org>	<20080215202336.GE26034@mail.oracle.com>	<1203274161.27987.6.camel@localhost.localdomain>	<20080218104025.GA15899@ca-server1.us.oracle.com>	<1203458366.26910.15.camel@cthulhu.hellion.org.uk>	<47BBDA20.8030105@zytor.com>	<1203497511.26910.39.camel@cthulhu.hellion.org.uk>	<47BCA275.7000504@goop.org>	<1203546597.26910.74.camel@cthulhu.hellion.org.uk>	<47BDEA11.6010302@goop.org>	<47BDEB57.5040203@zytor.com>	<47BDEF36.8000903@goop.org>	<1203631956.28436.4.camel@cthulhu.hellion.org.uk>	<47BDF9C7.6040400@zytor.com>	<47BE0017.1020205@goop.org>	<47BE0228.7020204@zytor.com>	<1203665106.28436.19.camel@cthulhu.hellion.org.uk>	<20080222092855.6ace8845@core>	<47BE9C18.5060202@firstfloor.org> <20080222100034.1e78d661@core> <47BEA0DF.9070800@firstfloor.org>
In-Reply-To: <47BEA0DF.9070800@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Alan Cox wrote:
>>> Actually I switched 64bit over to trust e820 completely and not
>>> reserve 640k-1MB explicitly some time ago
>>> and AFAIK there hasn't been any reports that it causes problems.
>>>
>>> So presumably trusting e802 is ok on modern systems (2003+)
>> Apparently so - at least 64bit capable ones. 
> 
> They should all use the same BIOS code bases, except perhaps
> some embedded weirdnesses.

Well, that, plus you still have to deal with a lot older stuff.

> We do still sort the entries
>> to remove zero length records and other suprises.
> 
> That code could be actually dropped. And the sorting too.
> It's all not needed I think.

When I dealt with this for another project, I found that the e820 data 
format is suboptimal.  It's better to treat it as a sorted list of 
(address, type) tuples (where type can be zero); the data from e820 can 
be fed into such a data structure and it cleans it up nicely.

	-hpa
