Return-Path: <linux-kernel-owner+w=401wt.eu-S1030572AbXAYVMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030572AbXAYVMj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 16:12:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030573AbXAYVMj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 16:12:39 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45098
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1030572AbXAYVMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 16:12:38 -0500
Date: Thu, 25 Jan 2007 13:12:37 -0800 (PST)
Message-Id: <20070125.131237.88342843.davem@davemloft.net>
To: michal.k.k.piotrowski@gmail.com
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       vyekkirala@TrustedCS.com
Subject: Re: Linux 2.6.20-rc6
From: David Miller <davem@davemloft.net>
In-Reply-To: <45B91BAC.5010707@googlemail.com>
References: <Pine.LNX.4.64.0701241847360.25027@woody.linux-foundation.org>
	<45B91BAC.5010707@googlemail.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Date: Thu, 25 Jan 2007 22:05:48 +0100

> It doesn't build for me.
> 
> make O=/dir
> [..]
> security/built-in.o: In function `security_set_bools':
> (.text+0x12471): undefined reference to `flow_cache_genid'
> security/built-in.o: In function `security_load_policy':
> (.text+0x128b3): undefined reference to `flow_cache_genid'
> make[1]: *** [.tmp_vmlinux1] Error 1
> make: *** [_all] Error 2

Venkat, I think we should fix this by embedding the flow_cache_genid
bumps into selinux_netlbl_cache_invalidate() and
selnl_notify_policyload(), or something like that.

That way we don't have to pepper CONFIG_XFRM ifdefs all over
services.c

Any better ideas?  I'm actually surprised this code gets built
at all when CONFIG_XFRM is disabled to be honest.  :-)
