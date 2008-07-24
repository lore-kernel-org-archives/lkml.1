Return-Path: <linux-kernel-owner+w=401wt.eu-S1754133AbYGXIhE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133AbYGXIhE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 04:37:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751378AbYGXIgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 04:36:50 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37867
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751288AbYGXIgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 04:36:49 -0400
Date: Thu, 24 Jul 2008 01:36:49 -0700 (PDT)
Message-Id: <20080724.013649.22662901.davem@davemloft.net>
To: mingo@elte.hu
Cc: herbert@gondor.apana.org.au, w@1wt.eu, davidn@davidnewall.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       stefanr@s5r6.in-berlin.de, rjw@sisk.pl
Subject: Re: [TCP bug, regression] stuck distcc connections in latest -git
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080724082730.GA29046@elte.hu>
References: <20080724063242.GA9051@elte.hu>
	<E1KLvds-0001Mc-00@gondolin.me.apana.org.au>
	<20080724082730.GA29046@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Thu, 24 Jul 2008 10:27:30 +0200

> * Herbert Xu <herbert@gondor.apana.org.au> wrote:
> 
> > BTW any reason why you appear to have SACK off?
> 
> default distro setup, Fedora 9 and Fedora 8. No extra tweaking that i'm 
> aware of.

It's probably a side effect of their turning on syncookies in /etc/sysctl.conf :-/

I thought we added code that would allow enabling those options
even with syncookies enabled?  There is code in net/ipv4/syncookies.c
function cookie_check_timestamp() to handle this.

Of course this is a recent addition, so if either side doesn't
have that change.
