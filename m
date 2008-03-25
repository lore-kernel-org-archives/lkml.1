Return-Path: <linux-kernel-owner+w=401wt.eu-S1757983AbYCYTAB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757983AbYCYTAB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 15:00:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753571AbYCYS7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 14:59:51 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:23397 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703AbYCYS7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 14:59:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mi5LtGgULhw1cvPShuM1j7JvQQA7DL3Jjg7i+wblprzZKYogYpq33S/y/G6H9/bV4INsAxsHer1vWXdiHlwQ9Br7sxwFYuIYDrAgkZfUPYD3yHsQA9bDRaG14kZeK4QEg78m6iF6BzzXpZ9FHzhgOsfQnyePQvFlucl/Q2GNWG4=
Message-ID: <1ba2fa240803251159p70de1d51jc739b9d141922da3@mail.gmail.com>
Date: Tue, 25 Mar 2008 20:59:49 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Chatre, Reinette" <reinette.chatre@intel.com>
Subject: Re: [PATCH][RESEND] wireless: convert !X & Y to !(X & Y) iniwl4965_is_fat_tx_allowed()
Cc: "John W. Linville" <linville@tuxdriver.com>,
       "Roel Kluin" <12o3l@tiscali.nl>, "Zhu, Yi" <yi.zhu@intel.com>,
       linux-wireless@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <D936D925018D154694D8A362EEB08920040372DB@orsmsx416.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47E9226C.7090403@tiscali.nl>
	 <D936D925018D154694D8A362EEB08920040370C5@orsmsx416.amr.corp.intel.com>
	 <20080325174227.GB3026@tuxdriver.com>
	 <D936D925018D154694D8A362EEB08920040372DB@orsmsx416.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2008 at 8:26 PM, Chatre, Reinette
<reinette.chatre@intel.com> wrote:
>
> On Tuesday, March 25, 2008 10:42 AM, John W. Linville  wrote:
>
>  > On Tue, Mar 25, 2008 at 09:30:58AM -0700, Chatre, Reinette wrote:
>  >> On Tuesday, March 25, 2008 9:04 AM, Roel Kluin  wrote:
>  >>
>  >>> from include/linux/ieee80211.h:274:
>  >>> #define IEEE80211_HT_CAP_SUP_WIDTH              0x0002 ---
>  >>> ! has a higher priority than &
>  >>>
>  >>> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
>  >>> ---
>  >>> diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c
>  >>> b/drivers/net/wireless/iwlwifi/iwl-4965.c
>  >>> index d727de8..6576757 100644
>  >>> --- a/drivers/net/wireless/iwlwifi/iwl-4965.c
>  >>> +++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
>  >>> @@ -4589,7 +4589,7 @@ static u8
>  >>> iwl4965_is_fat_tx_allowed(struct iwl4965_priv *priv,
>  >>>
>  >>>     if (sta_ht_inf) {
>  >>>             if ((!sta_ht_inf->ht_supported) ||
>  >>> -              (!sta_ht_inf->cap & IEEE80211_HT_CAP_SUP_WIDTH))
>  >>> +              (!(sta_ht_inf->cap & IEEE80211_HT_CAP_SUP_WIDTH)))
>  return 0;
>  >>>     }
>  >>
>  >> This patch has already been acked and merged into wireless-testing,
>  >> and afaik already pushed further upstream.
>  >
>  > Yes, but FWIW the problem exists in the 2.6.25 stream as well.
>  > I've been holding-back a patch to fix it there, trying to decide if it
>  > is worth creating the merge conflict to fix it there.  I'm inclined
>  > to think it is better to let things lay as they are and send that
>  > patch for the -stable series once 2.6.25 ships.
>  >
>  > Any thoughts on that?
>
>  I see. The patch is small and I thus assume a merge conflict will be
>  easy to resolve. Yet ... I do not know what is really involved in the
>  upstream code movements, while I know that you do. If you say it is
>  better to wait until stable then I am ok with it.

I have to find the patch but I believe we've published a fix for this
long before this particular patch was born.
Anyhow if HT is enabled in 2.6.25 I would prefer  a conflict then a bug.

Thanks
Tomas
