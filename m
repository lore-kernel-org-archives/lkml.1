Return-Path: <linux-kernel-owner+w=401wt.eu-S1761741AbXFHEi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761741AbXFHEi4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 00:38:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754657AbXFHEir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 00:38:47 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:54643 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754528AbXFHEiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 00:38:46 -0400
Message-ID: <4668DD3C.60000@cosmosbay.com>
Date: Fri, 08 Jun 2007 06:38:20 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: Kyle Moffett <mrmacman_g4@mac.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
References: <send-serie.davidel@xmailserver.org.4625.1181169040.7> <20070606235906.72439d16@the-village.bc.nu> <Pine.LNX.4.64.0706061558550.10383@alien.or.mcafeemobile.com> <20070607001932.35c9591c@the-village.bc.nu> <466741BD.20106@redhat.com> <20070607110432.73be7960@the-village.bc.nu> <B8B9EC80-2E36-433E-87EB-5B31FF42FBCF@mac.com> <20070607151243.22caab9e.dada1@cosmosbay.com> <Pine.LNX.4.64.0706071243090.6445@alien.or.mcafeemobile.com> <466864F8.2050903@cosmosbay.com> <Pine.LNX.4.64.0706071454530.6445@alien.or.mcafeemobile.com>
In-Reply-To: <Pine.LNX.4.64.0706071454530.6445@alien.or.mcafeemobile.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Fri, 08 Jun 2007 06:38:26 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Davide Libenzi a écrit :
> On Thu, 7 Jun 2007, Eric Dumazet wrote:
>> I am afraid randomization wont really work if /sbin/init or /bin/bash for
>> example uses one (or more) unseq fd :
>> The 'random base' will be propagated at fork()/exec() time ?
> 
> As I said to Uli, we can't move the base while fds are in there. We can 
> re-randomize it when it's empty. This can also be done (it's a trivial and 
> fast operation - just set fmap->base to a new value) even every time the 
> fd count on the map touches zero.
> 

Hum, I think it would be better to free fmap if it's empty, instead of change 
fmap->base. (Only in fork() after removal of O_CLOFORK file handles, and in 
exec() after removal of O_CLOEXEC file handles)


