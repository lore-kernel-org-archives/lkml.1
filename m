Return-Path: <linux-kernel-owner+w=401wt.eu-S1761882AbYFDUi7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761882AbYFDUi7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 16:38:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754052AbYFDUiu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 16:38:50 -0400
Received: from gate.crashing.org ([63.228.1.57]:56015 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752201AbYFDUit (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 16:38:49 -0400
Message-Id: <9BECB10D-536E-4242-A2F5-6E1EF8CBDB40@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: David Miller <davem@davemloft.net>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v924)
Subject: math-emu issue with fp divide
Date: Wed, 4 Jun 2008 15:38:22 -0500
Cc: lkml List <linux-kernel@vger.kernel.org>, libc-alpha@sourceware.org
X-Mailer: Apple Mail (2.924)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,

You seem to be the last person to touch the math-emu code in the  
kernel so I figured you might have some insights.  I'm trying to move  
the powerpc math-emu code to use the include/math-emu bits.

In doing so I've been using TestFloat to see how good or bad we are  
doing.  For the most part the current math-emu code that PPC uses has  
a number of issues that the code in include/math-emu seems to solve  
(plus bugs we've had for ever that no one every realized).

Anyways, I've come across a case that we are flagging underflow and  
inexact because we think we have a denormalized result from a double  
precision divide:

000.FFFFFFFFFFFFF / 3FE.FFFFFFFFFFFFE
	soft: 001.0000000000000 .....  syst: 001.0000000000000 ...ux

What it looks like is the results out of FP_DIV_D are:

D:
sign:	  0
mantissa: 01000000 00000000
exp:	 -1023 (0)

The problem seems like we aren't normalizing the result and bumping  
the exp.  So I was wondering if you had any idea if FP_DIV_D should be  
doing that or if when we call FP_PACK_DP/_FP_PACK_CANONICAL if that  
could should be doing it.

thanks

- k
