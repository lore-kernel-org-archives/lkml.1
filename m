Return-Path: <linux-kernel-owner+w=401wt.eu-S1761024AbXEKGNz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761024AbXEKGNz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 02:13:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756931AbXEKGNs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 02:13:48 -0400
Received: from smtp101.sbc.mail.mud.yahoo.com ([68.142.198.200]:28559 "HELO
	smtp101.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755046AbXEKGNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 02:13:47 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=kMLGIjNc8qMAGztGlRbgoC29RvU/HMQvRaMovpBxQUaxLhHQ5DQ4X4FEzEjlRN/lWLoWJp4s3f2tl0fd7BMhCfCgj9DyxAhoJnaWHB8WH77cjdraJkniAClMABqK+FS+BRtMqhUDE5UjhBYRAwuAKEVMro6xluFrJ1xIwtIJaro=  ;
X-YMail-OSG: ywV6tkUVM1liGnnCemPgKlSEuk0gvhZBwOPX5tfqFzAQDJn3j8FQN5n89DLv0ICxNa9T7bYtyQ--
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCHv2] at91: fix enable/disable_irq_wake symmetry in pcmcia driver
Date: Thu, 10 May 2007 23:01:56 -0700
User-Agent: KMail/1.9.6
Cc: Marc Pignat <marc.pignat@hevs.ch>, andrew@sanpeople.com,
       linux-kernel@vger.kernel.org
References: <200705101009.36302.marc.pignat@hevs.ch> <20070510152636.4adb3ef1.akpm@linux-foundation.org>
In-Reply-To: <20070510152636.4adb3ef1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705102301.56964.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 May 2007, Andrew Morton wrote:

> "disable_irq_wake call must be symmetric with enable_irq_wake".  hmm, OK,
> I'll take your word for it.

In the same way that enable_irq() and disable_irq() must be matched,
and for the same reasons:  when the IRQ is shared between drivers,
they can't all treat enable/disable status as boolean.  Those calls
mask refcountig.


> Does the present code actually fail in some manner, or what?

Yes ... runtime warnings flagging various misbehaviors associated
with refcount mismatches.

- Dave


