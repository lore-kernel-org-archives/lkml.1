Return-Path: <linux-kernel-owner+w=401wt.eu-S1755492AbYFBEvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492AbYFBEvX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 00:51:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751110AbYFBEvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 00:51:13 -0400
Received: from eth6445.sa.adsl.internode.on.net ([150.101.30.44]:47480 "EHLO
	aix.gdt.id.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750810AbYFBEvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 00:51:12 -0400
Message-ID: <48437C25.7080400@gdt.id.au>
Date: Mon, 02 Jun 2008 14:20:45 +0930
From: Glen Turner <gdt@gdt.id.au>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Bill Fink <billfink@mindspring.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, James Cammarata <jimi@sngx.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: [PATCH] net: add ability to clear stats via ethtool - e1000/pcnet32
References: <482DA5B6.1020606@sngx.net>	<482DB46A.8020103@cosmosbay.com>	<482EF192.4070707@sngx.net>	<482F5113.5090703@cosmosbay.com>	<482F610D.2080108@sngx.net>	<20080518003104.GK28241@solarflare.com>	<482FBA09.80201@sngx.net>	<483E0AAE.2020107@sngx.net>	<20080528221118.63da4092.akpm@linux-foundation.org>	<483EA2D1.8050603@sngx.net>	<20080529154525.3916c7b5@core>	<20080530151250.b44a119a.billfink@mindspring.com>	<20080531131143.516ca56e@core> <20080531195702.0b879dd1.billfink@mindspring.com>
In-Reply-To: <20080531195702.0b879dd1.billfink@mindspring.com>
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAALVBMVEV8hICwZ1odCw7OiXlO
 ODMEBAvgy8WynJtXR2ZLIy+SWk2yeGL///8fHyx4QDQ69jxnAAACY0lEQVQ4jY3TMWsbMRQAYA8l
 9pDlyHa3iXjIkMHc0MFQKGjwmZ6nHu2SrTS0eEip6ZW0gQyldaGB1tyiIYGb0jyXg+OGwAlCh2IH
 4qGYmsTQGwJarIJ+QyXbyclNC32jPj1JT08qDP4Rhf+B3t+hv5dlF8Wb8HLoqTj/A3p73jyWF6E1
 uoKHC9DPyl5ZDZevU2bwbVhGSMnGyHugww5CY4JUDL2NpgYuGgc46AynaT9z6LtrgRAN5uwj5M3X
 msJpRgSAABeplPs5PBkLMC0wjtBUmtfQqgNYNKSGQ9B62Xt9DbfqZphUEpuaYj8bzSqZQRiv3H5u
 21UzcvYzLaPUTWwV1FCQaRlziI0IL0DrCsyIZVmWL/XIoleAF+DUAOjKMzHByDj7kcPXlANP4khe
 yjrJah/yu0qB8ZVKgwVsGLgXGtDwc2jf+WTBBBP3/Zd8qaRKLfvkLjU5sHYn3+NM3kZSPeE2pTBp
 rw10kGVLsCvRpLSqNUqVITMSO46c0vdFqCYnQgIj7Xs3wPllpxKWc+hZNI7DI3RpmROyqz+fMO5S
 0w14aDrkrQ5pCqEFEeOASVGHbSuuhyZDl2mACzo8pTQ+phE30oNaSYe+hJUK8DBt1N680KDXpVQ2
 nEMkanqjBoNnEmIAub+L1s81OLMkmCCE00HehQb9kCYxRBg78o3uarAJNJE9J5iQzmppOQcfuqoX
 ErDzsfQuP9UrDiZEDnYOBDtsF5tzeOxv10EwjHHAQWwViksz2PT9nUu1M3YaHA63fL+goOfL2OrK
 HyVFhMaxgqVBYTru+1QVIYT8P9N5xeZvAufMcHaieZQAAAAASUVORK5CYII=
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Yes, every individual Linux network administrator can re-create the
> wheel by devising their own scripts, but it makes much more sense
> to me to implement a simple general kernel mechanism once that could
> be used generically, than to have hundreds (or thousands) of Linux
> network administrators each having to do it themselves (perhaps
> multiple times if they have a variety of types of systems and types
> of NICs).

Hi Bill,

If you pull the stats using a SNMP polling tool (torrus, cacti, mrtg)
then those package's graphs give nice "did this get better or worse"
output for debugging network issues.

I'd suggest you use one of those tools rather than writing your
own scripts.  Even if 99% of the time the graphs record zero errors,
knowing when those errors started is very valuable and well worth
the additional effort of configuring the tools over a command-line
or a kernel hack.

The more sophisticated tools can do alerting to Nagios should
a variable suddenly change its behaviour.

The Cisco/Juniper/everyone-else feature to run console stats
separately from SNMP stats is nice, but it's rather tuned to
the needs of router-heads and tends to fall apart when multiple
staff are debugging a fault.

If we do proceed with better command line stats then the number
of errored seconds and the worst errored second and its value
would be useful. These useful numbers can't be calculated by
the SNMP polling tools and it's hard to see how they could be
done in user-space.

Cheers, Glen

-- 
  Glen Turner
