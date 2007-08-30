Return-Path: <linux-kernel-owner+w=401wt.eu-S1762423AbXH3QoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762423AbXH3QoW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 12:44:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759412AbXH3QoO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 12:44:14 -0400
Received: from mail.gmx.net ([213.165.64.20]:39469 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1759340AbXH3QoN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 12:44:13 -0400
X-Authenticated: #12383568
X-Provags-ID: V01U2FsdGVkX1+Awrd/ayKAqgtLM9rET1raomxehknIebbYmjvEve
	qlhsTUjHswOErR
From: Clemens Kolbitsch <clemens.kol@gmx.at>
To: linux-kernel@vger.kernel.org
Subject: Forbid deletion of memory mappings
Date: Thu, 30 Aug 2007 18:44:10 +0200
User-Agent: KMail/1.9.6
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708301844.10532.clemens.kol@gmx.at>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone!
I have a strange problem where I don't even know if there is a solution to it 
at the moment:

I'm working on a new way of doing memory-management and currently I allocate 
memory mappings (at non-fixed locations) in user-memory (i.e. < TASK_SIZE) in 
addition to the regular pages mapped for the apps (e.g. heap memory, etc.)

It all works perfectly well (creating & deleting the additional mappings), 
however, when the kernel feels like it needs to allocate a mapping in 
user-space it sometimes deletes my mapping and overwrites it with the new 
one, although there is plenty of free memory at some other location.

typically my mappings are (automatically chosen) located somewhere around 
0xb7xxxxxx although there's plenty free space around 0xayyyyyyy. (i know that 
this is a bad location because of stack, etc.) but i need the kernel to 
choose a good location for me...

is there a way to make sure my mappings are not removed from memory?? or is 
there a location where i can put my mappings that they will not be removed 
(i.e. by using MAP_FIXED)?
Note that i need a big amount of memory so the range will have to be fairly 
big (to be precise: i need a lot of 0x1000byte mappings - they are always 
page-sized, not bigger, not smaller, but A LOT of them :-/ )

hope someone can help me with this!
thanks & greets,
  Clemens
