Return-Path: <linux-kernel-owner+w=401wt.eu-S935573AbYBUXc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935573AbYBUXc2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 18:32:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756140AbYBUXcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 18:32:09 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58197 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756021AbYBUXcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 18:32:07 -0500
Message-ID: <47BE08C0.5060700@zytor.com>
Date: Thu, 21 Feb 2008 15:26:56 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Ian Campbell <ijc@hellion.org.uk>, Joel Becker <Joel.Becker@oracle.com>,
       Jody Belka <lists-lkml@pimb.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andi Kleen <andi@firstfloor.org>,
       Mika Penttila <mika.penttila@kolumbus.fi>
Subject: Re: 2.6.25-rc1 xen pvops regression
References: <20080212235404.GY7980@pimb.org> <47B2DBA5.6030001@goop.org>	<20080214022744.GA4160@mail.oracle.com> <47B3F2DC.8080707@goop.org>	<20080215202336.GE26034@mail.oracle.com>	<1203274161.27987.6.camel@localhost.localdomain>	<20080218104025.GA15899@ca-server1.us.oracle.com>	<1203458366.26910.15.camel@cthulhu.hellion.org.uk>	<47BBDA20.8030105@zytor.com>	<1203497511.26910.39.camel@cthulhu.hellion.org.uk>	<47BCA275.7000504@goop.org>	<1203546597.26910.74.camel@cthulhu.hellion.org.uk>	<47BDEA11.6010302@goop.org> <47BDEB57.5040203@zytor.com> <m14pc26k6f.fsf@ebiederm.dsl.xmission.com> <47BE05C0.2090405@goop.org>
In-Reply-To: <47BE05C0.2090405@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> 
> It seems to me that those pages are being handed out as heap pages by 
> the early allocator.  In the Xen case this is OK because there's nothing 
> magic about them.  But if real hardware doesn't reserve these pages in 
> the E820 map, then they could end up being used as regular memory by 
> mistake, which is an issue.
> 

No, they couldn't.

On real hardware they'll be memory types 0 or 2, depending on whether or 
not they're marked reserved.

Available RAM is type 1.

	-hpa
