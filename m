Return-Path: <linux-kernel-owner+w=401wt.eu-S1763623AbYASB3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763623AbYASB3S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 20:29:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759460AbYASB3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 20:29:05 -0500
Received: from ozlabs.org ([203.10.76.45]:48932 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757260AbYASB3D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 20:29:03 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH 3/3] Makes lguest's irq handler typesafe
Date: Sat, 19 Jan 2008 12:28:29 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jgarzik@pobox.com>, Ash Willis <ashwillis@programmer.net>,
       linux-pcmcia@lists.infradead.org,
       virtualization@lists.linux-foundation.org
References: <200801190722.26154.rusty@rustcorp.com.au> <200801190727.36567.rusty@rustcorp.com.au> <47913261.5000708@gmail.com>
In-Reply-To: <47913261.5000708@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801191228.30363.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 19 January 2008 10:12:33 Tejun Heo wrote:
> Type safety is good but I doubt this would be worth the complexity.  It
> has some benefits but there's much larger benefit in keeping things in
> straight C.  People know that functions take fixed types and are also
> familiar with the convention of passing void * for callback arguments.
> IMHO, staying in line with those common knowledges easily trumps having
> type checking on interrupt handler.

I sympathise with this argument, but I think just because people are familiar 
with existing hacks shouldn't prevent improvement.  I think the resulting 
code is clearer and more readable.

Even in the implementation, the tricky part is the check_either_type() macro: 
the rest is straight-forward.

> Also, how often do we see a bug where things go wrong because interrupt
> handler is given the wrong type of argument?  Even when such bug
> happens, I doubt it can escape the developer's workstation if he/she is
> paying any attention to testing.

I agree this one is unlikely.  But I am trying to spread type-safety more 
widely (see previous kthread patches).

I like changing the kernel to make life simpler for developers.  We don't do 
enough of it.

Cheers,
Rusty.
