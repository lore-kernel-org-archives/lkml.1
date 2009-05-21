Return-Path: <linux-kernel-owner+w=401wt.eu-S1755575AbZEUNb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575AbZEUNb0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 09:31:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752773AbZEUNbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 09:31:16 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:34737 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752124AbZEUNbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 09:31:16 -0400
Date: Thu, 21 May 2009 09:31:08 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Robin Holt <holt@sgi.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 4/4] zone_reclaim_mode is always 0 by default
In-Reply-To: <20090521090549.63B5.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.1.10.0905210924520.31888@qirst.com>
References: <20090519102003.4EAB.A69D9226@jp.fujitsu.com> <20090520140045.GA29447@sgi.com> <20090521090549.63B5.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 May 2009, KOSAKI Motohiro wrote:

> I can't catch up your message. Can you post your patch?
> Can you explain your sanity check?
>
> Now, I decide to remove "nr_online_nodes >= 4" condition.
> Apache regression is really non-sense.

Not sure what that means? Apache regresses with zone reclaim? My
measurements when we introduced zone reclaim showed just the opposite
because Apache would get node local memory and thus run faster. You can
screw this up of course if you load the system so high that the apache
processes are tossed around by the scheduler. Then the node local
allocation may be worse than round robin because all the pages allocated
by a process are now on one node if the scheduler moves the
process to a remote node then all accesses are penalized.

> > Even with 128 nodes and 256 cpus, I _NEVER_ see the
> > system swapping out before allocating off node so I can certainly not
> > reproduce the situation you are seeing.
>
> hmhm. but I don't think we can assume hpc workload.

System swapping due to zone reclaim? zone reclaim only reclaims unmapped
pages so it will not swap. Maybe some bug crept in in the recent changes?
Or you overrode the defaults for zone reclaim?
