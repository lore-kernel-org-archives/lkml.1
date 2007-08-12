Return-Path: <linux-kernel-owner+w=401wt.eu-S936340AbXHLUxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936340AbXHLUxf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 16:53:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759468AbXHLUx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 16:53:26 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:54162 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759093AbXHLUxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 16:53:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=CFTLQjRJPzRbVIBIzgxENWi7awwN/I587MUrV26v+FmDoKvHh0uqN4JGPVl6PVNZLyBvM74FleyQvNUEXB6nBWRosNMhrJTQLdm03XZ3g58TiWi1Jr4LHFlAk5y1I3VJ03/26xsZSObMYHt2yNakgbN680N90jYv/sZpPmnboCA=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/5] 4KSTACKS no longer a debug feature and doesn't belong in "Kernel hacking".
Date: Sun, 12 Aug 2007 22:50:58 +0200
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Paul Mundt <lethal@linux-sh.org>, David Chinner <dgc@sgi.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Matt Mackall <mpm@selenic.com>, Rene Herman <rene.herman@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       William Lee Irwin III <wli@holomorphy.com>,
       Bodo Eggert <7eggert@gmx.de>, Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708122250.58773.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The short story:
This is a series of 5 patches to a) lift 4KSTACKS from a debug feature to a 
non-debug feature and b) move it out of the Kernel hacking menu and into the 
Processor types and features menu and c) make it 'default y', but only 
for -mm.

Some more explanation is probably needed, so here's the longer story:
About a month back I posted a RFC patch with the subject 
"[PATCH][RFC] 4K stacks default, not a debug thing any more...?" to find out 
if I was right in assuming that 4K stacks were no longer considered a debug 
only feature and whether or not it would be sensible to make them default. 
You can find the head of the thread (100+ mesages) in the lkml.org archives 
here: http://lkml.org/lkml/2007/7/11/294 .

Based on the comments in that thread I conclude that 4KSTACKS are not really 
considered a debug-only feature any longer, but the time is not right (yet) 
to make them the default - and it's certainly not yet the time to get rid of 
8K stacks.

In that thread I promised to provide some patches that would lift 4KSTACKS out 
of debug-only feature status, which is what the first two patches in this 
series do.
I also said I would provide a patch to make 4KSTACKS 'default y' to get more 
testing, but restrict that patch to -mm - that's the fifth patch in this 
series.
Patches 3 & 4 in this series move the config option out of the Kernel hacking 
menu and into Processor types and features - this makes sense once it is no 
longer a debug feature and the location is in line with m68knommu (which is 
the only arch with this config symbol in addition to i386 & sh) which already 
place that symbol there.

Now for a bit on the actual patches. These are the patches in this series : 

[PATCH 1/5] 4KSTACKS, remove DEBUG_KERNEL dependency for i386
[PATCH 2/5] 4KSTACKS, remove DEBUG_KERNEL dependency for sh
[PATCH 3/5] 4KSTACKS, move out of Kernel hacking menu (i386)
[PATCH 4/5] 4KSTACKS, move out of Kernel hacking menu (sh)
[PATCH 5/5] 4KSTACKS, make 'default y', -mm patch only.

Andrew; as i386 & -mm maintainer I'm sending you patches 1, 3 & 5 - patches 2 
& 4 for Super-H I would like a maintainer ACK on before they go further, so 
I'm not Cc'ing you on those (they are on LKML if you want them anyway).

Paul; in the thread I mention above I was focusing 100% on i386. I don't 
really know the status of 4KSTACKS on sh, so I'd like your input.

I'm adding a few people from the previous thread to Cc, but far from everyone 
as then the Cc list would become too big. For the patches themselves I'm just 
sending them to LKML, Andrew & Paul, so pick them up on LKML please (sending 
as replies to this mail).


Kind regards,
  Jesper Juhl


