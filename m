Return-Path: <linux-kernel-owner+w=401wt.eu-S1758066AbXEXKrf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758066AbXEXKrf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 06:47:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754936AbXEXKr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 06:47:29 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:4930 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754443AbXEXKr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 06:47:28 -0400
Date: Thu, 24 May 2007 20:47:13 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Auke Kok <auke-jan.h.kok@intel.com>
Subject: Re: rmmod e1000 hangs (Was Re: 2.6.22-rc2-mm1)
Message-ID: <20070524104713.GA9174@gondor.apana.org.au>
References: <20070523004233.5ae5f6fd.akpm@linux-foundation.org> <46556AA6.7040503@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46556AA6.7040503@goop.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2007 at 11:36:22AM +0100, Jeremy Fitzhardinge wrote:
> 
> I got a hang while rmmodding e1000.  sysrq-t shows:
> 
> rmmod         D 003FFAFC  6616 15923  15911 (NOTLB)
>        e9341e44 00000092 82318c15 003ffafc e9341e2c 00000000 e9341e14 823187a1 
>        003ffafc 00000000 c0123862 d3dbab80 d3dbad1c c2c08a40 77a67d01 000001ca 
>        00000292 e9341e24 c03799cd e9341e54 c0540840 e9341e44 00223389 000000ff 
> Call Trace:
>  [<c03777b1>] schedule_timeout+0x70/0x8e
>  [<c03777e4>] schedule_timeout_uninterruptible+0x15/0x17
>  [<c0133d04>] msleep+0x10/0x16
>  [<c030d5e0>] dev_close+0x39/0x6b

Looks like we're spinning on __LINK_STATE_RX_SCHED.  This means that
someone called netif_poll_disable() without re-enabling it again.
Perhaps e1000_io_error_detected? Auke?

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
