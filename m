Return-Path: <linux-kernel-owner+w=401wt.eu-S1754261AbYLBKOq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261AbYLBKOq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 05:14:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754108AbYLBKOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 05:14:35 -0500
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:4188 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544AbYLBKOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 05:14:34 -0500
X-Greylist: delayed 466 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Dec 2008 05:14:34 EST
From: "Miquel van Smoorenburg" <miquels@cistron.nl>
Subject: MAP_PRIVATE that stays private even on external write
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Newsreader: trn 4.0-test76 (Apr 2, 2001)
Originator: mikevs@n2o.xs4all.nl (Miquel van Smoorenburg)
Date: 02 Dec 2008 10:06:45 GMT
Message-ID: <493508b5$0$200$e4fe514c@news.xs4all.nl>
X-Trace: 1228212405 news.xs4all.nl 200 [::ffff:194.109.0.112]:51216
X-Complaints-To: abuse@xs4all.nl
To: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have an application that mmaps blocks from a file and then
sends it out over a TCP socket.

The contents of the file may be overwritten while the blocks
are sent out, but there is a very low chance of that.

To prevent this, I can ofcourse just use read() all blocks into
memory in advance, check consistency, and go ahead .. but since
there may be a lot of network connections active this might cost
a lot of memory.

What I am looking for is a MAP_PRIVATE type flag that, when another
process modifies pages of the file (through mmap() or write())
makes sure that my mapping never sees that.

I found out that mmap(MAP_PRIVATE|MAP_POPULATE) does exactly what
I want, but ofcourse it reads in the entire mapping all at once,
which is equivalent to plain read().

There has been talk of a MAP_SNAPSHOT flag before, e.g.
http://lkml.indiana.edu/hypermail/linux/kernel/0407.1/0416.htm

Has anyone ever looked at implementing something like this ?

Mike.
