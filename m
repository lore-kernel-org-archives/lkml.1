Return-Path: <linux-kernel-owner+w=401wt.eu-S1755005AbYIHXXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755005AbYIHXXU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 19:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754438AbYIHXXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 19:23:10 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:58389 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753701AbYIHXXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 19:23:09 -0400
Subject: Re: [PATCH] fix RTC_CLASS regression with PARISC
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: David Miller <davem@davemloft.net>
Cc: david-b@pacbell.net, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-parisc@vger.kernel.org
In-Reply-To: <20080908.160441.124972717.davem@davemloft.net>
References: <200809081429.57805.david-b@pacbell.net>
	 <20080908.143504.121592746.davem@davemloft.net>
	 <1220914847.8074.81.camel@localhost.localdomain>
	 <20080908.160441.124972717.davem@davemloft.net>
Content-Type: text/plain
Date: Mon, 08 Sep 2008 18:23:06 -0500
Message-Id: <1220916186.8074.84.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-09-08 at 16:04 -0700, David Miller wrote:
> From: James Bottomley <James.Bottomley@HansenPartnership.com>
> Date: Mon, 08 Sep 2008 18:00:47 -0500
> 
> > On Mon, 2008-09-08 at 14:35 -0700, David Miller wrote:
> > > The RTC layer is very nice and it even allows writing drivers for
> > > very simplistic RTC devices (even ones that cannot be written)
> > > with ease.  I had two such cases to handle on sparc64.
> > 
> > I'm guessing they're not upstream yet (since I can't find them)?
> 
> It's in my sparc next tree:
> 
> 	master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-next-2.6.git
> 
> > However, if you based them on rtc-ppc.c then yes, I agree, it looks
> > reasonably easy:  it's just a matter of converting over the GEN_RTC
> > PDT_TOD helpers.
> 
> That's not what I do, I use the real RAW chip drivers provided by the
> RTC layer.
> 
> That's the way to do this.
> 
> I think the powerpc folks did the wrong thing and should just register
> generic platform_device objects in their platform code, and let the
> RTC layer drive the individual devices in response.
> 
> All the powerpc folks are doing is providing a dummy shim into the
> RTC layer using their machine description vector, and not really using
> the RTC layer drivers at all.

But realistically that's all we need.  Our RTC is controlled by two
calls into firmware: a get and a set; nothing else.  We don't have the
docs to get at the clock without the firmware calls.

James


