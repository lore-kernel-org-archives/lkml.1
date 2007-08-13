Return-Path: <linux-kernel-owner+w=401wt.eu-S1031213AbXHMQa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031213AbXHMQa3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 12:30:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031287AbXHMPa1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 11:30:27 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48293 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031234AbXHMPaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 11:30:22 -0400
Date: Mon, 13 Aug 2007 21:12:58 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Alexey Dobriyan <adobriyan@sw.ru>
cc: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc2-mm2: strtol_check_range patches
In-Reply-To: <20070813112907.GA6620@localhost.sw.ru>
Message-ID: <alpine.LFD.0.999.0708132103090.29609@enigma.security.iitk.ac.in>
References: <20070813112907.GA6620@localhost.sw.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 13 Aug 2007, Alexey Dobriyan wrote:

> Andrew please drop
> 	introduce-strtol_check_range-fix.patch
> 	introduce-strtol_check_range.patch
> from -mm.
> 
> strtol_check_range() semantics is broken, because caller can't distinguish
> -E from valid negative number if he wants to negative integers.

As you wrote, the comment does mention that you can't use this to convert
negative integers, and it WARN()'s if the user tries that anyway.

> Comment
> mentions this, but we don't want to such horrible and not well thought
> out function to lib/ .
> 
> If anything it should be strtonum() with additional trailing '\n' check.

That's fine, I'll use strtonum() in any case. It turns out the behaviour
that we want is precisely what strtonum() offers, plus that also works for
negative integers, so we might as well just copy it over.

Andrew, I'll diff a new patch implementing strtonum(3) _not_ based on this
one, so you may safely drop this.


Thanks,
Satyam
