Return-Path: <linux-kernel-owner+w=401wt.eu-S1757943AbYC1Uvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757943AbYC1Uvs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 16:51:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755044AbYC1Uvj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 16:51:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41890 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583AbYC1Uvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 16:51:39 -0400
Message-ID: <47ED5A40.9020307@zytor.com>
Date: Fri, 28 Mar 2008 13:51:12 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: use of volatile in iounmap()?
References: <20080328203427.GA14256@uranus.ravnborg.org>
In-Reply-To: <20080328203427.GA14256@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> While reviewing some CAN driver I stumbled on iounmap
> which has following prototype on x86:
> 
> extern void iounmap(volatile void __iomem *addr);
> 
> I argued that the driver should not use volatile
> but then I cannot explain why the argument to
> iounmap takes a volatile.
> 
> The same goes for many other functions in
> the io*.h headers.
> 
> Grepping the other archs they mostly follow
> same pattern.
> 
> Can anyone explain the rational for volatile in this case.
> 

Yes.  The use of volatile in a function prototype like this means that 
it is valid to pass a volatile pointer to that function -- in other 
words, we're telling gcc that we're not going to do anything with the 
pointer that is invalid for a volatile pointer.

A lot of the "volatile considered harmful" stuff that has been bandied 
about is explicitly about marking *data* items volatile (it does have 
its uses, but it's easy to get wrong); Linus has explicitly made the 
distinction between volatile *data* and volatile *operations*.

	-hpa
