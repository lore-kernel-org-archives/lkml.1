Return-Path: <linux-kernel-owner+w=401wt.eu-S1764421AbXGUTbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764421AbXGUTbf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 15:31:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756363AbXGUTb2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 15:31:28 -0400
Received: from canuck.infradead.org ([209.217.80.40]:33794 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756508AbXGUTb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 15:31:28 -0400
Subject: Re: from where comes "__moddi3"?
From: Peter Zijlstra <peterz@infradead.org>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0707211516480.6972@localhost.localdomain>
References: <Pine.LNX.4.64.0707211516480.6972@localhost.localdomain>
Content-Type: text/plain
Date: Sat, 21 Jul 2007 21:31:13 +0200
Message-Id: <1185046274.5652.15.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-07-21 at 15:21 -0400, Robert P. J. Day wrote:
> again, probably displaying my abject ignorance, but i wrote a
> trivial module that tries to "var % 15", and i get:
> 
>   WARNING: "__moddi3" undefined!
> 
> and, not surprisingly, when i try to insmod:
> 
>   insmod: error inserting 'seq.ko': -1 Unknown symbol in module
> 
> (using 16 rather than 15 works fine, as i assume that the modulus
> call is simply replaced by an optimized  bitwise comparison.)
> 
>   so ... from where comes __moddi3?  i know there are places in the
> kernel source tree that do non-power-of-2 moduli, and they work fine,
> no?  thanks.

let me guess, 32 bit kernel, and var is 64 bit?

gcc translates that into a libgcc call, which we _explicitly_ do not
have because 64bit divisions are expensive!

use do_div().

16 works because gcc translates that into a right shift.

