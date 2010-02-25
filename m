Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759136Ab0BYPEB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 10:04:01 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:43677 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759013Ab0BYPEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 10:04:00 -0500
Date: Thu, 25 Feb 2010 16:04:23 +0100
From: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
To: "John W. Linville" <linville@tuxdriver.com>, linux-kernel@vger.kernel.org
Cc: vamos@i4.informatik.uni-erlangen.de,
       "David S. Miller" <davem@davemloft.net>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Patrick McHardy <kaber@trash.net>, Yi Zou <yi.zou@intel.com>
Subject: Question about WLAN_80211 removal
Message-ID: <20100225150423.GA5101@faui49.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all!

	As part of the VAMOS[0] research project at the University of
Erlangen we're checking referential integrity between kernel KConfig
options and in-code Conditional blocks.

	In git commit [1] the option WLAN_80211 was removed as well as
all references from within KConfig (as far as I can see) because the
non 80211 drivers moved to staging.

	I guess while doing so the help message was beliefed in which
tells that this option only enables selection of certain drivers which
is unfortunately wrong as this option is used in one header file[2]
where it influences (as I'm reading it) the maximum size required for
some networking header.	Is this, as it seems, a bug in kernel code or
rather harmless (intended?)?

Regards

	Christoph Egger

[0] http://vamos1.informatik.uni-erlangen.de/
[1] 133d7c6a504c672011ebc24b26e05b15f7410c07
[2] ./include/linux/netdevice.h
#if defined(CONFIG_WLAN_80211) || defined(CONFIG_AX25) || defined(CONFIG_AX25_MODULE)
# if defined(CONFIG_MAC80211_MESH)
#  define LL_MAX_HEADER 128
# else
#  define LL_MAX_HEADER 96
# endif
#elif defined(CONFIG_TR) || defined(CONFIG_TR_MODULE)
# define LL_MAX_HEADER 48
#else
# define LL_MAX_HEADER 32
#endif


