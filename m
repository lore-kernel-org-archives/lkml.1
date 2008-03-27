Return-Path: <linux-kernel-owner+w=401wt.eu-S1762069AbYC0WFO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762069AbYC0WFO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 18:05:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759281AbYC0WE5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 18:04:57 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49476
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758968AbYC0WE4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 18:04:56 -0400
Date: Thu, 27 Mar 2008 15:04:56 -0700 (PDT)
Message-Id: <20080327.150456.39560267.davem@davemloft.net>
To: joe@perches.com
Cc: ilpo.jarvinen@helsinki.fi, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org, acme@redhat.com,
       mpm@selenic.com
Subject: Re: [PATCH 1/7] [NET]: uninline skb_put, de-bloats a lot
From: David Miller <davem@davemloft.net>
In-Reply-To: <1206645050.4849.77.camel@localhost>
References: <1206621486-5408-1-git-send-email-ilpo.jarvinen@helsinki.fi>
	<1206621486-5408-2-git-send-email-ilpo.jarvinen@helsinki.fi>
	<1206645050.4849.77.camel@localhost>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Thu, 27 Mar 2008 12:10:50 -0700

> On Thu, 2008-03-27 at 14:38 +0200, Ilpo Järvinen wrote:
> > Allyesconfig (v2.6.24-mm1):
> 
> I think this change is only good in severely memory
> limited uses.  This will very likely negatively impact
> high speed networking.  It's a speed/size trade off.

I severely doubt this, the bulk of the overhead of
skb_put() is the atomic operation, not whether the
instructions get executed inline or not.

Please run some tests before making claims like this.
I might give you some slack in this area if you've
been doing networking performance tuning for 10+ years
but you haven't.
