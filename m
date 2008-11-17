Return-Path: <linux-kernel-owner+w=401wt.eu-S1755912AbYKQAjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912AbYKQAjj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 19:39:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754894AbYKQAjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 19:39:21 -0500
Received: from ox1.aei.mpg.de ([194.94.224.6]:40734 "EHLO ox1.aei.mpg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754692AbYKQAjU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 19:39:20 -0500
Date: Mon, 17 Nov 2008 01:39:41 +0100
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: reinette chatre <reinette.chatre@intel.com>,
       Lukas Hejtmanek <xhejtman@ics.muni.cz>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>
Subject: Re: iwlagn driver segfault in 2.6.28-rc3
Message-ID: <20081117003941.GA21367@localhost.aei.mpg.de>
References: <20081111143410.GA4401@ics.muni.cz> <1226560041.1115.945.camel@rc-desk> <20081116120621.GA3937@localhost.aei.mpg.de> <1ba2fa240811160429ld8cc080s7e023b0398eeda08@mail.gmail.com> <20081116125148.GA16746@localhost.aei.mpg.de> <1ba2fa240811161554r45d98ae7h3a37ae78c332a4dd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1ba2fa240811161554r45d98ae7h3a37ae78c332a4dd@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 17.Nov'08 at  1:54:16 +0200, Tomas Winkler wrote:
[...]
> Can you please try this one (might be white space broken, just pasted in)

Sure, I've already applied it by hand and will start testing it right away.

But it will take many days until I can report back about it, because
this oops happened only two times in one month or so.

Thanks for taking a look at it, the last time you did my regression
got fixed :-)

> diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c
> b/drivers/net/wireless/iwlwifi/iwl-sta.c
> index 61797f3..d848c63 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-sta.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
> @@ -734,6 +734,12 @@ int iwl_remove_dynamic_key(struct iwl_priv *priv,
>                 return 0;
>         }
> 
> +       if (WARN(priv->stations[sta_id].sta.key.key_offset ==
> WEP_INVALID_OFFSET,
> +               "Removing wrong key %d 0x%x\n", keyconf->keyidx, key_flags)) {
> +               spin_unlock_irqrestore(&priv->sta_lock, flags);
> +               return 0;
> +       }
> +
>         if (!test_and_clear_bit(priv->stations[sta_id].sta.key.key_offset,
>                 &priv->ucode_key_table))
>                 IWL_ERROR("index %d not used in uCode key table.\n",
> 
> Thanks
> Tomas
> 
