Return-Path: <linux-kernel-owner+w=401wt.eu-S1754073AbZBPUmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073AbZBPUmj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 15:42:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751209AbZBPUmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 15:42:31 -0500
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:22917 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751252AbZBPUmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 15:42:31 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=YMyP/dSYuZsMbJNKdoFpT83y+afiSBknxVyzY1deO9UGu4rPXEjFnhnAGV6v8v4z11mFhrc81xemYhs4TiudxyeQPyvm/9ZrpGqg4hZF0jF66REUsbbNif/ufQGbPTjIWYIWTLg0L5m3Gep1Fpa6psOdp80Sruk6O6fxI3+V7WA=  ;
X-YMail-OSG: VCceXGgVM1lu.LVY1xqwQiPDkVuvatKw.IYB30wPO6shTpRWhGZ5yygo6FY3hfoE4kNlKHRaTwuCVBS959ZRC5dwOWgDFqHCO4KAMreSG9.dLoogj7jd5g.lapWI8MGVRmRqlxhF7zL7S42Vqkk9QAZjkv3HLeIfd.mH.GQFTzbNM_UtI0_vXtSVotPL
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH] spi-gpio: Implement spidelay() for busses that need it.
Date: Mon, 16 Feb 2009 12:42:27 -0800
User-Agent: KMail/1.9.10
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <200902151923.00120.mb@bu3sch.de>
In-Reply-To: <200902151923.00120.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200902161242.27773.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[
  NOTE:  removed openwrt from the cc list, it rejects posts
  from non-subscribers.  Please don't cc such lists.
]

On Sunday 15 February 2009, Michael Buesch wrote:
> + * NOTE:  to clock "as fast as we can", set spi_device.max_speed_hz
> + * and spi_transfer.speed_hz to 0.

Won't work; if spi->max_speed_hz is zero, spi_async() and
friends will refuse to queue any messages.

I'm not averse to a solution that lets some boards use a
slowed-down bitbang loop.  But it would be a lot easier
if you kept the default the way it is, and just added
that slowdown as an option for the existing customization
case (currently oriented towards speedup, not slowdown).

- Dave
