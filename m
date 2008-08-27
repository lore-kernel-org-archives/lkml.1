Return-Path: <linux-kernel-owner+w=401wt.eu-S1755212AbYH0Wn4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212AbYH0Wn4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 18:43:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752675AbYH0Wns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 18:43:48 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35105
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752673AbYH0Wnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 18:43:47 -0400
Date: Wed, 27 Aug 2008 15:43:43 -0700 (PDT)
Message-Id: <20080827.154343.18918939.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: alan@lxorguk.ukuu.org.uk, petero2@telia.com, rjw@sisk.pl, alan@redhat.com,
       jens.axboe@oracle.com, linux-kernel@vger.kernel.org, bunk@kernel.org,
       akpm@linux-foundation.org, protasnb@gmail.com,
       kernel-testers@vger.kernel.org
Subject: Re: 2.6.27-rc4-git1: Reported regressions from 2.6.26
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.1.10.0808271530350.3419@nehalem.linux-foundation.org>
References: <m3k5e2qkk2.fsf@telia.com>
	<20080827230828.4285022b@lxorguk.ukuu.org.uk>
	<alpine.LFD.1.10.0808271530350.3419@nehalem.linux-foundation.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 27 Aug 2008 15:38:16 -0700 (PDT)

> Btw, why is unlocked_ioctl returning "long"? Does anybody depend on that 
> too? That's another difference between the "unlocked" and the traditional 
> version..

The return values want to be "long" sign extended all the way back
down to syscall dispatch, I think this is just an effort to add
some consistency here so that the int --> long extension eventually
can be eliminated once unlocked_ioctl is the only case left.
