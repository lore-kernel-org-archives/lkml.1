Return-Path: <linux-kernel-owner+w=401wt.eu-S936231AbYD2A3h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936231AbYD2A3h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 20:29:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935082AbYD2A3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 20:29:22 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:2620 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935080AbYD2A3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 20:29:21 -0400
Date: Mon, 28 Apr 2008 19:45:48 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       reinette.chatre@intel.com, torvalds@linux-foundation.org,
       yi.zhu@intel.com, linux-wireless@vger.kernel.org
Subject: Re: [2.6 patch] iwlwifi: move the selects to the tristate drivers
Message-ID: <20080428234548.GB3075@tuxdriver.com>
References: <20080428054700.GA16177@Pilar.virtua.com.br> <20080427.233507.261574307.davem@davemloft.net> <20080428073212.GA7260@Pilar.virtua.com.br> <20080428131552.GI16379@cs181133002.pp.htv.fi> <20080428142129.GA5679@beyonder.ift.unesp.br> <20080428205849.GB2813@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080428205849.GB2813@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 11:58:49PM +0300, Adrian Bunk wrote:

> This patch moves the following select's:
> - RFKILL        : IWLWIFI_RFKILL -> IWLCORE
> - RFKILL_INPUT  : IWLWIFI_RFKILL -> IWLCORE
> - MAC80211_LEDS : IWL4965_LEDS   -> IWLCORE
> - LEDS_CLASS    : IWL4965_LEDS   -> IWLCORE
> - MAC80211_LEDS : IWL3945_LEDS   -> IWL3945
> - LEDS_CLASS    : IWL3945_LEDS   -> IWL3945
> 
> The effects are:
> - with IWLCORE=m and/or IWL3945=m RFKILL/RFKILL_INPUT/MAC80211_LEDS/LEDS_CLASS
>   are no longer wrongly forced to y
> - fixes a build error with IWLCORE=y, IWL4965=m
>   might be a bug in kconfig causing it, but doing this change that is 
>   anyway the right thing fixes it
> 
> Reported-by: Carlos R. Mafra <crmafra2@gmail.com>
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

This seems sane to me -- I'm sorry I let so much Kconfig mess slip
through on this driver in the first place!

> ---
> 
> BTW: There's no correlation between IWL3945_LEDS and IWLWIFI_LEDS.
>      That seems to be intended?

Yes.  IWLWIFI_LEDS used to be IWL4965_LEDS, and I have the impression
that eventually it will subsume IWL3945_LEDS as well.

Dave, are you going to snarf this one too?  If not (and presuming no
one points out yet another problem) I'll just include it in the next
round of fix patches, probably on tomorrow.

John
-- 
John W. Linville
linville@tuxdriver.com
