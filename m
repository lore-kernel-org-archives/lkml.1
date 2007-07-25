Return-Path: <linux-kernel-owner+w=401wt.eu-S935707AbXGYTfR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935707AbXGYTfR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 15:35:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763397AbXGYTfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 15:35:05 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55829
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758690AbXGYTfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 15:35:03 -0400
Date: Wed, 25 Jul 2007 12:35:01 -0700 (PDT)
Message-Id: <20070725.123501.71119586.davem@davemloft.net>
To: jeremy@goop.org
Cc: viro@ftp.linux.org.uk, torvalds@linux-foundation.org, hpa@zytor.com,
       kaos@ocs.com.au, xyzzy@speakeasy.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH][RFC] getting rid of stupid loop in BUG()
From: David Miller <davem@davemloft.net>
In-Reply-To: <46A78A31.10506@goop.org>
References: <alpine.LFD.0.999.0707251018280.3607@woody.linux-foundation.org>
	<20070725172542.GG27237@ftp.linux.org.uk>
	<46A78A31.10506@goop.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy@goop.org>
Date: Wed, 25 Jul 2007 10:36:49 -0700

> I tried that, but there's still no way of getting a pointer to the ud2a
> instruction in there.  gcc just generates garbage if you try to use use
> the &&label syntax on a label which isn't (potentially) the target of a
> goto (it just gets placed somewhere random).
> 
> But there's a bigger problem than that.  If the BUG is in code which can
> be replicated (ie inlined or unrolled), then it would also require
> replicating the static variable...

Another issue is that if you have a conditional trap instruction on
your cpu, and you try the __label__ trick, GCC no longer converts:

	BUG_ON(test)

into just a:

	set condition codes;
	conditional_trap;

sequence because the "stuff" inside the basic block is something
more than just the __builtin_trap().

The holy grail would be being able to get the perfect conditional
trap sequence, plus the annotations in a seperate section.
