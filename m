Return-Path: <linux-kernel-owner+w=401wt.eu-S1754299AbYL2Vsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299AbYL2Vsc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 16:48:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753280AbYL2VsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 16:48:20 -0500
Received: from sj-iport-1.cisco.com ([171.71.176.70]:30677 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051AbYL2VsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 16:48:19 -0500
X-IronPort-AV: E=Sophos;i="4.36,297,1228089600"; 
   d="scan'208";a="123448576"
From: Roland Dreier <rdreier@cisco.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       "general\@lists.openfabrics.org" <general@lists.openfabrics.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [ofa-general] Re: linux-next: origin tree build failure
References: <20081229114321.4b6baea5.sfr@canb.auug.org.au>
	<ada4p0nve4r.fsf@cisco.com> <1230544737.4261.33.camel@alst60>
	<adaljtyu45d.fsf@cisco.com>
	<alpine.LFD.2.00.0812291304471.3082@localhost.localdomain>
	<adahc4mu0l5.fsf@cisco.com>
X-Message-Flag: Warning: May contain useful information
Date: Mon, 29 Dec 2008 13:48:18 -0800
In-Reply-To: <adahc4mu0l5.fsf@cisco.com> (Roland Dreier's message of "Mon, 29
	Dec 2008 13:35:02 -0800")
Message-ID: <adad4fatzz1.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 29 Dec 2008 21:48:18.0439 (UTC) FILETIME=[29213970:01C969FF]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 >  > I'd suggest
 >  > 
 >  >   config IF_IPV6
 >  > 	bool
 >  > 	depends on INET
 >  > 	depends on !(INFINIBAND = y && IPV6 = m)
 >  > 	default y
 > 
 > Makes sense, will do.  How about calling it INFINIBAND_USE_IPV6 or
 > something like that, though?  (Since it's under the INFINIBAND config
 > stuff and exists to forbid INFINIBAND=y && IPV6=m trying to use IPv6).

Actually, thinking about this for 30 more seconds, I'm not sure how
another config symbol helps at all.  I do like splitting dependencies
onto multiple lines as a replacement for &&, so I have:

config INFINIBAND_ADDR_TRANS
	bool
	depends on INET
	depends on !(INFINIBAND = y && IPV6 = m)
	default y

right now.

Not sure if it's worth introducing another Kconfig symbol that depends
on IPV6 != n to avoid the

#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)

tests.  I note that there are tons of that construction all over the
tree, and the places without it look somewhat dubious (eg
net/ipv4/ip_gre.c looks as if it will do the wrong thing if IPV6=m).
Maybe adding CONFIG_IPV6_ENABLED or something and cleaning up the whole
tree would be a good janitorial project?

 - R.
