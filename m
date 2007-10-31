Return-Path: <linux-kernel-owner+w=401wt.eu-S1758717AbXJaK0e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758717AbXJaK0e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 06:26:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755187AbXJaK01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 06:26:27 -0400
Received: from static.206.158.47.78.clients.your-server.de ([78.47.158.206]:38312
	"EHLO mega2000.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbXJaK00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 06:26:26 -0400
X-Greylist: delayed 1592 seconds by postgrey-1.27 at vger.kernel.org; Wed, 31 Oct 2007 06:26:26 EDT
Date: Wed, 31 Oct 2007 11:00:25 +0100
To: linux-kernel@vger.kernel.org
Subject: Need information on elevator_dispatch_fn
Message-ID: <20071031100025.GC16598@mega2000.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
From: philipp.gruber@flupps.net (Philipp Gruber)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

I'm just working on an I/O-scheduler that implements some QoS
functionality.

Now I get some weird problems and need to know what triggers my
elevator_dispatch_fn, and how the return value of it is handled.
For now, I found that the dispatch function is called as long as there
are requests in my queue, so probably as long as it returns 1. On the
other hand, only every second dispatch call returns 1, the others 0, but
still it's working. I couldn't find any documentation about that (but
would like to write some, if I understood it). Could someone please
explain me when and why exactly elevator_dispatch_fn is triggered?

A little background:
Now that I'm implementing my QoS, I have one queue for each process, and
prioritized processes get a timeslice, where they can access the device
exclusively.
A timeslice might be 400ms, but if a process is finished after 200ms
and has no more requests, dispatch will return 0 and then it won't be
triggered anymore. So, when the next process has his timeslice, even if
it has requests, dispatch_fn is not triggered, so the process will
starve and hang forever.
So I need to 'reactivate' the whole dispatching process again. The only
way to to this is probably a timer, but I couldn't get this working
since I don't understand what calls dispatch_fn.

thanks in advance,
Philipp
