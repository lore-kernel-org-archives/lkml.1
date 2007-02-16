Return-Path: <linux-kernel-owner+w=401wt.eu-S1946044AbXBPTCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946044AbXBPTCu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 14:02:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946053AbXBPTCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 14:02:50 -0500
Received: from ns2.suse.de ([195.135.220.15]:39007 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946059AbXBPTCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 14:02:49 -0500
To: Jeff Muizelaar <jeff@infidigm.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Using sched_clock for mmio-trace
References: <20070216013024.GA32287@infidigm.net>
From: Andi Kleen <andi@firstfloor.org>
Date: 16 Feb 2007 21:02:44 +0100
In-Reply-To: <20070216013024.GA32287@infidigm.net>
Message-ID: <p73k5yhg9az.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Muizelaar <jeff@infidigm.net> writes:
> 
> The question is, what api should I be using? I need something that can
> be called from inside interrupt handlers, and obviously the more
> accurate and the lower the overhead the better.

Use do_gettimeofday(). sched_clock() is not for general use
and only for some very limited use cases and will give you
unexpected results in several cases.

There are a few cases where gtod is still a little slow, but these
are being addressed. In many cases it is fast. In some hardware
it stays slow, but there is not much that can be done about that
because of the hardware design.

It works fine from interrupt handlers and other strange contexts. 

-Andi
