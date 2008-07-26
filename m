Return-Path: <linux-kernel-owner+w=401wt.eu-S1756675AbYGZW05@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756675AbYGZW05 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 18:26:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755020AbYGZW0s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 18:26:48 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:53416 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158AbYGZW0r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 18:26:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Q5DG5j/TnYRFgN6ADnUPhpXfB79EHBp8jSxXs0ApsbrJdLSXJFnD0iJ75SbV9BF+B/
         /oybHLnXajRaW/8x+0GmM8bv024vdBH5dbqR4QLkJERRoDBUsN9wAkqpB6MUppCpNYF+
         kzzg6m3fgwM7PL60CytNVhbMNXNVEylUsAzFY=
Message-ID: <69e28c910807261526g17d1aeb1m7427b257cf61fc5e@mail.gmail.com>
Date: Sun, 27 Jul 2008 00:26:47 +0200
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Zhu Yi" <yi.zhu@intel.com>, "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] iwlwifi: Enable packet injection for iwl4965
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
       linux-kernel@vger.kernel.org,
       ipw3945-devel <ipw3945-devel@lists.sourceforge.net>,
       "Tomas Winkler" <tomasw@gmail.com>,
       "Tomas Winkler" <tomas.winkler@intel.com>,
       "Johannes Berg" <johannes@sipsolutions.net>,
       "Marco Schuster" <marco@harddisk.is-a-geek.org>
In-Reply-To: <69e28c910807181205m6dd0cdcek83f9717bf1ac9dcc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <69e28c910807181205m6dd0cdcek83f9717bf1ac9dcc@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2008 at 9:05 PM, Stefanik Gábor <netrolller.3d@gmail.com> wrote:
> @@ -822,7 +819,10 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
>        hdr_len = ieee80211_get_hdrlen(le16_to_cpu(fc));
>
>        /* Find (or create) index into station table for destination station */
> -       sta_id = iwl_get_sta_id(priv, hdr);
> +       if (info->flags & IEEE80211_TX_CTL_INJECTED)
> +               sta_id = priv->hw_params.bcast_sta_id;
> +       else
> +               sta_id = iwl_get_sta_id(priv, hdr);
>        if (sta_id == IWL_INVALID_STATION) {
>                DECLARE_MAC_BUF(mac);

Oops... this hunk (last hunk in iwl-tx.c) is unneeded, just ignore it
(it's a leftover from another patch I have in my tree).

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
