Return-Path: <linux-kernel-owner+w=401wt.eu-S1762093AbXJYPVB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762093AbXJYPVB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 11:21:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759192AbXJYPUx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 11:20:53 -0400
Received: from tim.rpsys.net ([194.106.48.114]:48445 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758180AbXJYPUx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 11:20:53 -0400
Subject: Linux machines dieing in swap storms
From: Richard Purdie <rpurdie@rpsys.net>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 25 Oct 2007 16:20:41 +0100
Message-Id: <1193325641.5776.21.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I've got a problem I keep running into. My computers have buggy software
which can sometimes run out of control. Two specific examples:

Evolution: Sometimes its memory usage decides to suddenly grow out of
control. It usually idles at around 300MB, you can watch it in top,
doubling, trebling and ending up going past the 1200MB mark. My system
has 1.5GB ram and you notice it swapping heavily past say 800MB.

Spamassassin: If my mail server log files hit the 2GB file size limit of
the filesystem something strange happens and for whatever reason spamd
suddenly starts growing in memory usage until it uses up all available
system memory.

Arguably both pieces of software are buggy, I accept that, fine. 

In both machines in totally different circumstances what happens next is
bad. The systems swap more and more heavily trying to cope with these
out of control processes. Network interactivity stops. The swap storm
gets so bad you can't log onto the console any more. I've left machines
in this state for 1-2 hours and they don't come back. Watching the
console, the OOM killer does kick in but it never kills the problem
process (both spamd and evolution are long running processes that have
suddenly gone out of control). In then end, you have to hit the reset
switch :(. This happened to my desktop once again about 10 minutes ago
and its *extremely* frustrating. Sometimes I can catch and kill the
offending process but I shouldn't have to.

This isn't a new problem. My mail server used to be running an ancient
2.6.12 kernel and I upgraded it to 2.6.22.X in an effort to solve this
problem which no change. My desktop shows exactly the same kind of OOM
swap storm behaviour (2.6.20 based).

I realise that tuning the OOM killer is a really tricky problem but
something needs improving as the current user experience is broken.

I'm seriously tempted to add a "kill the process using the most memory"
key combination into SysRq which might let me save the desktop but won't
help with my remote server. I could also just disable swap I guess.

Advice on solving this welcome preferably in mainline but I'll happily
hack my kernels with a workaround if need be.

Cheers,

Richard


