Return-Path: <linux-kernel-owner+w=401wt.eu-S1753586Ab0AZD7M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586Ab0AZD7M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 22:59:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753397Ab0AZD7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 22:59:09 -0500
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:9079 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753348Ab0AZD7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 22:59:08 -0500
Date: Mon, 25 Jan 2010 20:59:06 -0700
From: Alex Chiang <achiang@hp.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: linux-rdma@vger.kernel.org, justin.chen@hp.com,
       linux-kernel@vger.kernel.org
Subject: Re: infiniband limit of 32 cards per system?
Message-ID: <20100126035906.GA23347@ldl.fc.hp.com>
References: <20100125235013.GD2828@grease.ALLEYCAT> <adaiqapplv7.fsf@roland-alpha.cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adaiqapplv7.fsf@roland-alpha.cisco.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Roland Dreier <rdreier@cisco.com>:
> 
>  > My colleague points out the following enum in uverbs_main.c:
>  > 
>  > 	enum {
>  > 		IB_UVERBS_MAJOR       = 231,
>  > 		IB_UVERBS_BASE_MINOR  = 192,
>  > 		IB_UVERBS_MAX_DEVICES = 32
>  > 	};
>  > 
>  > Experimentally, we've determined that on a system where we
>  > plugged in 40 IB cards, OFED only reports 32 cards are present.
> 
> wow, 40 HCAs in one system !

HP sell some pretty big systems. :)

>  > If that enum is indeed the limiting factor, would someone mind
>  > explaining (or pointing me at TFM ;) why it's limited to 32
>  > devices?
> 
> That dates back to when device #s had 8 bits for major and 8 bits for
> minor.  We got one major assigned for IB, and had to split up the 256
> minors that gave us among userspace verbs, management access, etc.  And
> 32 seemed like a pretty reasonable limit for most uses.

Thanks for the explanation.

> Nowadays I guess we should look into expanding that to dynamic device
> numbers on overflow, assuming you do have a realistic situation where
> someone would want to use that many adapters per system.

Think of a large scale-up ia64 box, possibly running some
virtualization stack.

I'm guessing that it's not just a simple kernel fix though since
OFED has to change too, right?

/ac
