Return-Path: <linux-kernel-owner+w=401wt.eu-S1755438AbYIHXE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438AbYIHXE4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 19:04:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753828AbYIHXEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 19:04:48 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47850
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753514AbYIHXEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 19:04:48 -0400
Date: Mon, 08 Sep 2008 16:04:41 -0700 (PDT)
Message-Id: <20080908.160441.124972717.davem@davemloft.net>
To: James.Bottomley@HansenPartnership.com
Cc: david-b@pacbell.net, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-parisc@vger.kernel.org
Subject: Re: [PATCH] fix RTC_CLASS regression with PARISC
From: David Miller <davem@davemloft.net>
In-Reply-To: <1220914847.8074.81.camel@localhost.localdomain>
References: <200809081429.57805.david-b@pacbell.net>
	<20080908.143504.121592746.davem@davemloft.net>
	<1220914847.8074.81.camel@localhost.localdomain>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Bottomley <James.Bottomley@HansenPartnership.com>
Date: Mon, 08 Sep 2008 18:00:47 -0500

> On Mon, 2008-09-08 at 14:35 -0700, David Miller wrote:
> > The RTC layer is very nice and it even allows writing drivers for
> > very simplistic RTC devices (even ones that cannot be written)
> > with ease.  I had two such cases to handle on sparc64.
> 
> I'm guessing they're not upstream yet (since I can't find them)?

It's in my sparc next tree:

	master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-next-2.6.git

> However, if you based them on rtc-ppc.c then yes, I agree, it looks
> reasonably easy:  it's just a matter of converting over the GEN_RTC
> PDT_TOD helpers.

That's not what I do, I use the real RAW chip drivers provided by the
RTC layer.

That's the way to do this.

I think the powerpc folks did the wrong thing and should just register
generic platform_device objects in their platform code, and let the
RTC layer drive the individual devices in response.

All the powerpc folks are doing is providing a dummy shim into the
RTC layer using their machine description vector, and not really using
the RTC layer drivers at all.
