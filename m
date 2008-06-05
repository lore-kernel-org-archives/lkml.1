Return-Path: <linux-kernel-owner+w=401wt.eu-S1763289AbYFEBZh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763289AbYFEBZh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 21:25:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752569AbYFEBZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 21:25:29 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:29303 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324AbYFEBZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 21:25:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=KX05BwvLG/FaIQ/SZR6bSVnKS7Rvn0r4FCcbqOogQFQynd4J6jRcItYtZvNDemFBtB
         fgCQ4iVpQgQpIAplGGfhcs78IjyqSLRr+DoxIu2rK0mud9OaADXRv6mCFrK9hXuI6/Yg
         RmWmjaELouL+8zX7o2GtlsjojmceJjeYfHQmo=
Message-ID: <aec7e5c30806041825o4c6c859fp8380063e9384622@mail.gmail.com>
Date: Thu, 5 Jun 2008 10:25:27 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: "Hans J. Koch" <hjk@linutronix.de>
Subject: Re: [PATCH] uio_pdrv: Unique IRQ Mode
Cc: linux-kernel@vger.kernel.org, Uwe.Kleine-Koenig@digi.com, gregkh@suse.de,
       akpm@linux-foundation.org, lethal@linux-sh.org, tglx@linutronix.de
In-Reply-To: <20080604101144.GA3207@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080604060826.17162.46972.sendpatchset@rx1.opensource.se>
	 <20080604101144.GA3207@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 4, 2008 at 7:11 PM, Hans J. Koch <hjk@linutronix.de> wrote:
> On Wed, Jun 04, 2008 at 03:08:26PM +0900, Magnus Damm wrote:
>> From: Magnus Damm <damm@igel.co.jp>
>>
>> This patch adds a "Unique IRQ Mode" to the uio_pdrv UIO platform driver.
>> In this mode the user space driver is responsible for acknowledging and
>> re-enabling the interrupt. Shared interrupts are not supported.
>
> I still don't see any gain in this. This only works for embedded
> devices, so a user has to setup hardware specific code in his board
> support anyway.

Exactly what in my patch makes this platform driver only suitable for
embedded devices?

> With your code, we would have to add something like this
> to the docs:
>
> IF you define an irq AND ommit the irq handler THEN we silently add a
> handler that blindly assumes the irq is not shared...

I'm not sure if silently and blindly are the first words that pop into
my mind, but sure. Documentation is a good idea. Just let me know
which uio_pdrv document you want me to modify.

> In my opinion, this is confusing, and all it does is saving the need for a
> three-lines irq handler in the board support.

You propose that I put the callbacks in my board support code instead
of modifying the driver. I don't think the board support level is the
proper place for this code. The patch contains no board specific code,
and it is independent of both architecture and cpu model.

> So, NAK to this until somebody convinces me that I completely missed the
> point.

We can reuse this driver for _many_ different SuperH processor models.
Most of these processor models even have more than one hardware block
that can be exported to user space using this uio_pdrv driver in
"Unique IRQ Mode". There is nothing board specific with this at all,
so yes, I think you are missing the point.

Maybe you prefer that I repost my "Reusable UIO Platform Driver"
instead of modifying uio_pdrv?

/ magnus
