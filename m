Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759223Ab0BYPRp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 10:17:45 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42278
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754634Ab0BYPRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 10:17:41 -0500
Date: Thu, 25 Feb 2010 07:17:59 -0800 (PST)
Message-Id: <20100225.071759.98314060.davem@davemloft.net>
To: roel.kluin@gmail.com
Cc: herbert@gondor.apana.org.au, mikpe@it.uu.se, linux-crypto@vger.kernel.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sha: prevent removal of memset as dead store in
 sha1_update()
From: David Miller <davem@davemloft.net>
In-Reply-To: <4B8692E3.9030509@gmail.com>
References: <4B8692E3.9030509@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roel Kluin <roel.kluin@gmail.com>
Date: Thu, 25 Feb 2010 16:10:27 +0100

> Due to optimization A call to memset() may be removed as a dead store when
> the buffer is not used after its value is overwritten.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

Solution is wrong and overkill in my mind.

It's overkill because the whole reason it's using a stack buffer is to
avoid the overhead of a kmalloc() call.

And it's wrong because the reason the memset() is there seems to be
to clear out key information that might exist kernel stack so that
it's more difficult for rogue code to get at things.


