Return-Path: <linux-kernel-owner+w=401wt.eu-S1750909AbXCEQbg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750909AbXCEQbg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 11:31:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752803AbXCEQbg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 11:31:36 -0500
Received: from smtpout.mac.com ([17.250.248.176]:62831 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750909AbXCEQbf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 11:31:35 -0500
In-Reply-To: <20070301144138.57d6d8c7.akpm@linux-foundation.org>
References: <45E33EBD.6020603@google.com> <20070228220349.b42bf571.akpm@linux-foundation.org> <20070301103451.2618cc35@dhcp-252-105.norway.atmel.com> <20070301014523.e45c3cc5.akpm@linux-foundation.org> <45E7308B.3050106@google.com> <20070301144138.57d6d8c7.akpm@linux-foundation.org>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <1ED05FB5-17F7-42B2-BEAA-446F7DADAE46@mac.com>
Cc: Mathieu Desnoyers <compudj@google.com>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: Thread flags modified without set_thread_flag() (non atomically)
Date: Mon, 5 Mar 2007 11:30:49 -0500
To: Andrew Morton <akpm@linux-foundation.org>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mar 01, 2007, at 17:41:38, Andrew Morton wrote:
> Well, it's unusual for code to want to test multiple bitflags in  
> the same operation.  Perhaps thread_info.flags is unusual in that  
> regard.
>
> But one can still do
>
> 	if (foo->flags & (1<<bar)|(1<<zot))
>
> Which can get to be a pain if it happens in a lot of places.  But  
> if it only happens in a few places, this seems a reasonable price  
> to pay, given the safety gains.
>
> Plus I'm _forever_ having to go into the header file to remember  
> whether REQ_RW is the bitmask or the bit offset.

Hey Andrew, I think you just fell victim to an order-of-operations  
bug;  '&' has a higher priority than '|' does, so:

   if ( (foo->flags & (1<<bar)) | (1<<zot))

Or:

   if ( dynamic_value | always_true_constant )

And as such this if statement is always true.  You'd need an extra  
pair of parentheses to make it correct.

Cheers,
Kyle Moffett

