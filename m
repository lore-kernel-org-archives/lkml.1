Return-Path: <linux-kernel-owner+w=401wt.eu-S1762968AbXISSsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762968AbXISSsi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 14:48:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756509AbXISSsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 14:48:30 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:42133 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755859AbXISSsa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 14:48:30 -0400
Date: Wed, 19 Sep 2007 20:48:18 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: Miles Lane <miles.lane@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: 2.6.23-rc6-mm1
Message-ID: <20070919184818.GA3651@uranus.ravnborg.org>
References: <20070918011841.2381bd93.akpm@linux-foundation.org> <a44ae5cd0709180827w7156dc17q13853c3f2c127142@mail.gmail.com> <20070918191741.GA27725@uranus.ravnborg.org> <a44ae5cd0709181242j517e39e0xc3f78224bcda360a@mail.gmail.com> <20070918202654.GA27836@uranus.ravnborg.org> <46F05378.8020907@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46F05378.8020907@googlemail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi Sam,
> 
> I can reproduce this bug on Frugalware Linux. 
> 
> Here the bt:
> 
> Program received signal SIGSEGV, Segmentation fault.                                                     
> 0xb7dc4143 in strlen () from /lib/libc.so.6                                                                                                                                       
> (gdb) bt                                                                                                                                                                          
> #0  0xb7dc4143 in strlen () from /lib/libc.so.6                                                                                                                                   
> #1  0x0804fd60 in str_append (gs=0xbfe4f6e8, s=0x0) at scripts/kconfig/util.c:87                                                                                                  
So the string is null and we call strlen(null) => boom.

Thanks - will post a fix in a few minutes.
Need to investigate a bit more why I do not see the crash even
though I updated to ubuntu gutsy to check it out?!?

	Sam
