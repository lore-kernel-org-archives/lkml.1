Return-Path: <linux-kernel-owner+w=401wt.eu-S1756167AbYCYOzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167AbYCYOzf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 10:55:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754598AbYCYOzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 10:55:25 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:43971 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754297AbYCYOzY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 10:55:24 -0400
Message-ID: <47E91256.3010000@garzik.org>
Date: Tue, 25 Mar 2008 10:55:18 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH v2] Re: WAN: new PPP code for generic HDLC
References: <m3prtzsszg.fsf@maximus.localdomain>	<m3tzj92xq6.fsf@maximus.localdomain> <m33aqedg0a.fsf@maximus.localdomain>
In-Reply-To: <m33aqedg0a.fsf@maximus.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa wrote:
> Hi,
> 
> I wrote:
> 
>> New synchronous PPP implementation for generic HDLC.
> 
> So are we leaving the generic-HDLC+PPP in broken state for 2.6.25,
> aren't we?
> 
> If we do, perhaps a "|| BROKEN" in drivers/net/wan/Kconfig would make
> sense? Any attempt to use it will cause kernel panic immediately (PPP
> with generic HDLC only; drivers using syncppp.c directly are not
> affected). I can make that trivial Kconfig patch of course.

In your original email you said

	I guess it should go into 2.6.25, not sure about "stable"
	series. I will appreciate any feedback, review and/or test
	results.

At the time of the posting 2.6.25-rc6 had already been released, which 
seems like an inappropriate time for all that new code, which has been 
given so little exposure to real world testing.

Certainly your original message said PPP panics, but without even 
minimal testing how do we know that your new code doesn't have equally 
problematic issues?

So quite honestly a CONFIG_BROKEN patch might indeed be more appropriate 
since generic HDLC works with Frame Relay at least...

Comments?  IMO the current code is a known risk (PPP panic, FR works) 
whereas the new code is an unknown risk very late in 2.6.25-rc -- but 
with a good chance to make HDLC+PPP work again.

	Jeff



