Return-Path: <linux-kernel-owner+w=401wt.eu-S1760343AbYBRUmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760343AbYBRUmq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 15:42:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752961AbYBRUmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 15:42:39 -0500
Received: from gate.crashing.org ([63.228.1.57]:57069 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752874AbYBRUmi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 15:42:38 -0500
Subject: Re: [Patch 0/2] powerpc: avoid userspace poking to legacy ioports
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Jean Delvare <khali@linux-fr.org>
Cc: Christian Krafft <krafft@de.ibm.com>, linux-kernel@vger.kernel.org,
       parabelboi@bopserverein.de, linuxppc-dev@ozlabs.org
In-Reply-To: <20080218211519.2b159ade@hyperion.delvare>
References: <20080213182800.5c6940a8@de.ibm.com>
	 <20080213183506.7f3e3145@de.ibm.com> <1202935374.7296.44.camel@pasglop>
	 <20080218211519.2b159ade@hyperion.delvare>
Content-Type: text/plain
Date: Tue, 19 Feb 2008 07:42:03 +1100
Message-Id: <1203367323.6740.21.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Maybe Christian's patch can be improved to not do the check on these?
> As long as /dev/port exists, it seems reasonable that the kernel should
> behave, no matter what I/O ports are accessed from user-space.

nonsense.

 /dev/mem exists for example, but you are still not supposed to go
bang all over the place in it.

> > I hate that sensors_detect.. or for that matter any other userland code
> > that pokes random ports like that. It should die.
> 
> What do you propose as a replacement?

Dunno, something less scary, like knowing where your sensors are on a
given machine... honestly, it's just scary the risk you guys are taking
by banging random IO ports.

At the very least, that shouldn't be done on non-x86.

> And how is userland code poking at random ports different from kernel
> code poking at random ports? We could move sensors-detect inside the
> kernel (and I have some plan to do that) but I fail to see how this
> would solve this particular problem.

It wouldn't, but at least I could NAK it or make it CONFIG_X86 :-)

Ben.


