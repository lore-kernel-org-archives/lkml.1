Return-Path: <linux-kernel-owner+w=401wt.eu-S1759147AbZAIX7N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759147AbZAIX7N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 18:59:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754338AbZAIX6w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 18:58:52 -0500
Received: from styx.suse.cz ([82.119.242.94]:46002 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754290AbZAIX6v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 18:58:51 -0500
Date: Sat, 10 Jan 2009 00:58:50 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Alexey Zaytsev <alexey.zaytsev@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>,
       Trivial Kernel Patches <trivial@kernel.org>
Subject: Re: [PATCH 4/5] Fix dubious bitwise 'and' usage spotted by sparse.
In-Reply-To: <20090109234821.11800.74193.stgit@zaytsev.su>
Message-ID: <alpine.LNX.1.10.0901100057510.5377@jikos.suse.cz>
References: <20090109234113.11800.55672.stgit@zaytsev.su> <20090109234821.11800.74193.stgit@zaytsev.su>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Jan 2009, Alexey Zaytsev wrote:

> It doesn't change the semantics, but it looks like
> the logical 'and' was meant to be used here.
> 
> Signed-off-by: Alexey Zaytsev <alexey.zaytsev@gmail.com>
> ---
>  drivers/net/wireless/ath9k/rc.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath9k/rc.c b/drivers/net/wireless/ath9k/rc.c
> index cca2fc5..e8eb20d 100644
> --- a/drivers/net/wireless/ath9k/rc.c
> +++ b/drivers/net/wireless/ath9k/rc.c
> @@ -609,7 +609,7 @@ ath_rc_get_nextvalid_txrate(const struct ath_rate_table *rate_table,
>  
>  static int ath_rc_valid_phyrate(u32 phy, u32 capflag, int ignore_cw)
>  {
> -	if (WLAN_RC_PHY_HT(phy) & !(capflag & WLAN_RC_HT_FLAG))
> +	if (WLAN_RC_PHY_HT(phy) && !(capflag & WLAN_RC_HT_FLAG))
>  		return FALSE;
>  	if (WLAN_RC_PHY_DS(phy) && !(capflag & WLAN_RC_DS_FLAG))
>  		return FALSE;

This one needs a small fixup, as the buggy code got moved around to 
ath_rc_valid_phyrate().

-- 
Jiri Kosina
SUSE Labs
