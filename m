Return-Path: <linux-kernel-owner+w=401wt.eu-S934201AbXGRQ3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934201AbXGRQ3g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 12:29:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932777AbXGRQ3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 12:29:25 -0400
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:30070 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933359AbXGRQ3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 12:29:24 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=EztCPYgP4Ry1y1A5JqVG9FR4knyBSOoODnbYRoBfI51zmNSb0pMnS660PJmtTs3FwWehngKXnYYU9R4EIp5xJ+rrNrrpAXRFnGVEJSHmvFlXOKYunyzOEqQaoXjYGmNwEzakicyyRGeKkZeyvqc1pSv/sgYY73X2K0/aIALV4O4=  ;
X-YMail-OSG: 7hW2eMgVM1lHhQ7PEwyJvhC2cb6ZzPtf7inV.QnPBbk3eF5vn_EcyqapQF1CyJyNP3yQFGWvEw--
Message-ID: <469C3FE8.30505@yahoo.com.au>
Date: Tue, 17 Jul 2007 14:04:56 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Nish Aravamudan <nish.aravamudan@gmail.com>
CC: Ray Lee <ray-lk@madrabbit.org>, Roman Zippel <zippel@linux-m68k.org>,
       Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH/RFC] msleep() with hrtimers
References: <21003.1184596954@lwn.net>	 <Pine.LNX.4.64.0707161654130.1817@scrub.home>	 <2c0942db0707160857s25cbce19j7f057b14e74651e8@mail.gmail.com> <29495f1d0707160908x32704c7o41ab7857ceac1558@mail.gmail.com>
In-Reply-To: <29495f1d0707160908x32704c7o41ab7857ceac1558@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nish Aravamudan wrote:

> Well, before these changes, the only guarantee msleep() could make,
> just like the only guarantee schedule_timeout() could make, was that
> it would not return early. The 1-jiffy sleep was always tough to deal
> with, because of rounding and such. And it's simply exacerbated with
> HZ=100. It's not technically 20 times longer in all cases, it's 2
> jiffies longer, which depends on HZ, so varies from 2 msecs longer to
> 20 msecs longer.

I don't think you should rely on anything else actually, because Linux
is not an RT OS. If your driver needs a specific sequence in a given
amount of time, you have to do something like disable interrupts and
use delays.

-- 
SUSE Labs, Novell Inc.
