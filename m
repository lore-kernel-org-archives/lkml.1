Return-Path: <linux-kernel-owner+w=401wt.eu-S1946068AbXBPTkG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946068AbXBPTkG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 14:40:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946073AbXBPTkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 14:40:05 -0500
Received: from delta2.look.ca ([207.136.100.5]:42987 "EHLO keymaster.look.ca"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1946068AbXBPTkE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 14:40:04 -0500
Date: Fri, 16 Feb 2007 14:40:59 -0500
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org
Message-ID: <20070216194059.GF6425@infidigm.net>
References: <20070216013024.GA32287@infidigm.net> <p73k5yhg9az.fsf@bingen.suse.de>
Mime-Version: 1.0
Content-Disposition: inline
In-Reply-To: <p73k5yhg9az.fsf@bingen.suse.de>
User-Agent: Mutt/1.5.9i
From: Jeff Muizelaar <jeff@infidigm.net>
X-SA-Exim-Mail-From: jeff@infidigm.net
Subject: Re: Using sched_clock for mmio-trace
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Version: 3.1 (built Tue Feb 24 05:09:27 GMT 2004)
X-SA-Exim-Scanned: Yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 16, 2007 at 09:02:44PM +0100, Andi Kleen wrote:
> Jeff Muizelaar <jeff@infidigm.net> writes:
> > 
> > The question is, what api should I be using? I need something that can
> > be called from inside interrupt handlers, and obviously the more
> > accurate and the lower the overhead the better.
> 
> Use do_gettimeofday(). sched_clock() is not for general use
> and only for some very limited use cases and will give you
> unexpected results in several cases.
> 
> There are a few cases where gtod is still a little slow, but these
> are being addressed. In many cases it is fast. In some hardware
> it stays slow, but there is not much that can be done about that
> because of the hardware design.
> 
> It works fine from interrupt handlers and other strange contexts.

Ok, I'll probably use it then. How does the overhead of calling
do_gettimteofday() compare to doing an mmio read/write over PCI express?
i.e. is it going to be a performance problem if I call do_gettimeofday
for every mmio read/write?

Also, is there any good reason blk-trace doesn't use do_gettimeofday()? 

-Jeff
