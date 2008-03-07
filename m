Return-Path: <linux-kernel-owner+w=401wt.eu-S1762974AbYCGSkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762974AbYCGSkl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 13:40:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757664AbYCGSka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 13:40:30 -0500
Received: from mga11.intel.com ([192.55.52.93]:5901 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757213AbYCGSk3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 13:40:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,463,1199692800"; 
   d="scan'208";a="304432472"
Message-ID: <47D18B89.4000706@intel.com>
Date: Fri, 07 Mar 2008 10:38:01 -0800
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071125)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: e1000-devel@lists.sourceforge.net, xfs-masters <xfs-masters@oss.sgi.com>,
       kernel-janitors@vger.kernel.org, Julia Lawall <julia@diku.dk>,
       linux-kernel@vger.kernel.org
Subject: Re: [E1000-devel] [PATCH] drivers/net: convert & to &&
References: <Pine.LNX.4.58.0803061841000.1669@pc-041.diku.dk>	<1204826347.5541.20.camel@localhost>  <47D032FA.9000909@intel.com> <1204914033.5541.74.camel@localhost>
In-Reply-To: <1204914033.5541.74.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Mar 2008 18:38:01.0725 (UTC) FILETIME=[5F8D2AD0:01C88082]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> On Thu, 2008-03-06 at 10:07 -0800, Kok, Auke wrote:
>> (which, BTW also could use the uint32_t -> u32 (etc) changes... while you're at it)
> 
> I think this does what you want:
> 
> for size in "8" "16" "32" "64" ; do \
> sed -r -i -e 's/\bu_{0,1}int'$size'_t\b/u'$size'/g' \
> $(grep -rPlw --include=*.[ch] 'u_{0,1}int'$size'_t' drivers/net/e1000 drivers/net/ixgb); done
> 
> But why?  boolean_t is used by 3 subsystems with local typedefs.
> These others are much more frequently used by kernel source.

afaik they're really meant for userspace related code and don't belong in our
driver from that perspective.

> $ grep -rPlw --include=*.[ch] "u{0,1}_{0,1}int(8|16|32|64)_t" * | wc -l
> 876

yes, a lot of that *is* userspace related code.

do the same search in drivers/net/ .... you'll see the only drivers using this for
everything is our old drivers...

Auke
