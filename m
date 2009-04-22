Return-Path: <linux-kernel-owner+w=401wt.eu-S1752003AbZDVXGa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003AbZDVXGa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 19:06:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751607AbZDVXGV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 19:06:21 -0400
Received: from mailout.ijneb.com ([212.13.201.26]:9368 "EHLO metheny.ijneb.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751126AbZDVXGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 19:06:21 -0400
X-Greylist: delayed 3072 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Apr 2009 19:06:20 EDT
Date: Wed, 22 Apr 2009 23:15:07 +0100 (BST)
From: Mark Hills <mark@pogo.org.uk>
To: linux-kernel@vger.kernel.org
Subject: splice() on unix sockets
Message-ID: <alpine.BSO.2.00.0904220913580.19956@zrgural.vwaro.pbz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
X-SA-Exim-Connect-IP: 127.0.0.1
X-SA-Exim-Mail-From: mark@pogo.org.uk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found that splice() can operate from a pipe to a unix socket, but from a 
unix socket to a pipe fails with EINVAL.

On investigation, splicing from a pipe to a unix socket (af_unix.c) gets 
routed through a regular unix_stream_sendmsg (via sock_no_sendpage). If my 
understanding is correct this means it will copy memory and not 
references, so it's not actually a splice.

If so, splice() behaves inconsistently; sometimes it fails on unsupported 
file descriptors, sometimes it falls back to a copy. The man page favours 
the former, but the latter could also be useful -- to call splice() with 
any pair of fds and have the kernel do the best it can.

Splicing between unix sockets and pipes would give a useful performance 
benefit. Is there any work in progress on this? Are there any caveats to 
implementing it?

Thanks,

-- 
Mark
