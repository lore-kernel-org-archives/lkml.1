Return-Path: <linux-kernel-owner+w=401wt.eu-S1756198AbXGITz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198AbXGITz2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 15:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751917AbXGITzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 15:55:20 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57890 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751090AbXGITzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 15:55:19 -0400
Date: Mon, 9 Jul 2007 12:55:01 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Davide Libenzi <davidel@xmailserver.org>
cc: Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: queued spinlock code and results
In-Reply-To: <Pine.LNX.4.64.0707091241350.15898@alien.or.mcafeemobile.com>
Message-ID: <alpine.LFD.0.999.0707091250550.3412@woody.linux-foundation.org>
References: <20070708043228.GB22397@wotan.suse.de>
 <Pine.LNX.4.64.0707091140440.15898@alien.or.mcafeemobile.com>
 <alpine.LFD.0.999.0707091212410.3412@woody.linux-foundation.org>
 <Pine.LNX.4.64.0707091241350.15898@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 9 Jul 2007, Davide Libenzi wrote:
> 
> The always-lfence instruction in vadd-lock really is painfull though.
> If numbers are close, and given that spinlock size considering structure 
> alignments should not matter much, wouldn't it be better to use a double 
> short and remove the 256 CPUs cap?

On x86? No.

There are no issues with the 255-CPU cap on 32-bit x86. It's just not 
relevant to anybody. So the _only_ thing that matters is speed and to a 
secondary degree size.

On x86-64, things are slightly different, and we would want to have at 
least the _capability_ to do 16 bits. So there might be a (somewhat weak) 
argument in favor of trying to share code.

But even then, size and performance are really the only things that 
matter, and if the 8/16-bit version is no slower, then I'd pick that by 
default, and suggest the 16/32-bit one to be enabled by CONFIG_MAX_CPU's 
being >=256 (at which point you can share the code with x86 anyway, since 
that just becomes the <256 cpu case).

		Linus
