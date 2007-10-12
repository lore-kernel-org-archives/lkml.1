Return-Path: <linux-kernel-owner+w=401wt.eu-S1759920AbXJLEgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759920AbXJLEgU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 00:36:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754270AbXJLEgB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 00:36:01 -0400
Received: from stinky.trash.net ([213.144.137.162]:46234 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339AbXJLEf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 00:35:59 -0400
Message-ID: <470EF994.4080403@trash.net>
Date: Fri, 12 Oct 2007 06:35:32 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Debian Thunderbird 1.0.7 (X11/20051019)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Al Boldi <a1426z@gawab.com>
CC: netfilter-devel@lists.netfilter.org, netdev@vger.kernel.org,
       linux-net@vger.kernel.org, linux-kernel@vger.kernel.org,
       Netfilter Development Mailinglist 
	<netfilter-devel@lists.netfilter.org>
Subject: Re: [RFD] iptables:  mangle table obsoletes filter table
References: <200710120031.42805.a1426z@gawab.com>
In-Reply-To: <200710120031.42805.a1426z@gawab.com>
X-Enigmail-Version: 0.93.0.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Please send mails discussing netfilter to netfilter-devel.

Al Boldi wrote:
> With the existence of the mangle table, how useful is the filter table?
> 
> Other than requiring the REJECT target to be ported to the mangle table, is 
> the filter table faster than the mangle table?

There are some minor differences in ordering (mangle comes before
DNAT, filter afterwards), but for most rulesets thats completely
irrelevant. The only difference that really matters is that mangle
performs rerouting in LOCAL_OUT for packets that had their routing
key changed, so its really a superset of the filter table. If you
want to use REJECT in the mangle table, you just need to remove the
restriction to filter, it works fine. I would prefer to also remove
the restriction of MARK, CONNMARK etc. to mangle, they're used for
more than just routing today so that restriction also doesn't make
much sense. Patches for this are welcome.

> If not, then shouldn't the filter table be obsoleted to avoid confusion?

That would probably confuse people. Just don't use it if you don't
need to.
