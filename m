Return-Path: <linux-kernel-owner+w=401wt.eu-S933142AbXEDPdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933142AbXEDPdP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 11:33:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933152AbXEDPdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 11:33:15 -0400
Received: from outbound-mail-44.bluehost.com ([69.89.18.13]:33751 "HELO
	outbound-mail-44.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933142AbXEDPdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 11:33:14 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 May 2007 11:33:13 EDT
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] change global zonelist order v4 [0/2]
Date: Fri, 4 May 2007 08:26:23 -0700
User-Agent: KMail/1.9.6
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
       Christoph Lameter <clameter@sgi.com>, Lee.Schermerhorn@hp.com
References: <20070427144530.ae42ee25.kamezawa.hiroyu@jp.fujitsu.com> <20070503224730.3bc6f8a8.akpm@linux-foundation.org>
In-Reply-To: <20070503224730.3bc6f8a8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705040826.23687.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.73.10 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 03, 2007, Andrew Morton wrote:
> On Fri, 27 Apr 2007 14:45:30 +0900 KAMEZAWA Hiroyuki 
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > Hi, this is version 4. including Lee Schermerhon's good rework.
> > and automatic configuration at boot time.
>
> hm, this adds rather a lot of code.  Have we established that it's worth
> it?
>
> And it's complex - how do poor users know what to do with this new
> control?
>
>
> This:
>
> + *	= "[dD]efault | "0"	- default, automatic configuration.
> + *	= "[nN]ode"|"1" 	- order by node locality,
> + *         			  then zone within node.
> + *	= "[zZ]one"|"2" - order by zone, then by locality within zone
>
> seems a bit excessive.  I think just the 0/1/2 plus documentation would
> suffice?
>
>
> I haven't followed this discussion very closely I'm afraid.  If we came
> up with a good reason why Linux needs this feature then could someone
> please (re)describe it?

I think the idea is to avoid exhausting ZONE_DMA on some NUMA boxes by 
ordering the fallback list first by zone, then by node distance (e.g. 
ZONE_NORMAL of local node, then ZONE_NORMAL of next nearest node etc., 
followed by ZONE_DMA of local node, ZONE_DMA of next nearest node, etc.).

As for documentation, it would be good if the "default" behavior was 
described as well (it's mostly by node first, then by zone iirc, but has a 
few other tweaks).

Another option would be to make this behavior automatic if both ZONE_DMA 
and ZONE_NORMAL had pages.  I initially wrote this stuff with the idea 
that machines that really needed it would have all their memory in 
ZONE_DMA, but obviously that's not the case, so some more smarts are 
needed.

Jesse

