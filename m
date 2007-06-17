Return-Path: <linux-kernel-owner+w=401wt.eu-S1762886AbXFQKEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762886AbXFQKEj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 06:04:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760398AbXFQJtt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 05:49:49 -0400
Received: from nn7.de ([85.214.94.156]:60233 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760579AbXFQJts (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 05:49:48 -0400
Subject: git-current: slub breaks s2ram with fglrx...
From: Soeren Sonnenburg <kernel@nn7.de>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       "Rafael J\. Wysocki" <rjw@sisk.pl>, Stefan Seyfried <seife@suse.de>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Sun, 17 Jun 2007 11:49:46 +0200
Message-Id: <1182073786.3841.11.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

OK,

I've found the second root for my 

'2.6.22-rc regression: s2ram fails to suspend + fails to resume w/ Xorg':

The first one was just the wrong coretemp patch (already fixed by Jean).

The second one happens only with Xorg/fglrx loaded and slub enabled, as
I've found after a useless git bisect session, I've traced down the
other s2ram does not work problem to be caused by slub ... FYI: I am now
on git-current which should be rc5:

slab & fglrx works
slub & console works
slub & X11+fglrx creates hangs on suspend (black screen - no further
idea ...)

It should be noted that withouth the proprietary  fglrx.ko module loaded
the machine just reboots on s2ram (though IIRC without fglrx.ko loaded
it worked with 2.6.19 or so...)

Is this a kernel thing or yet another bug in fglrx ?

Soeren 
-- 
Sometimes, there's a moment as you're waking, when you become aware of
the real world around you, but you're still dreaming.
