Return-Path: <linux-kernel-owner+w=401wt.eu-S1763582AbYCEGuH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763582AbYCEGuH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 01:50:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758943AbYCEGtu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 01:49:50 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:42640 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758125AbYCEGtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 01:49:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=rR5p014WEeTPF5ZdoHAaARcqI5WaF0s79L9hdLXc9cdjrZezp7nllDlPL16oQkshK5WYJpwBJqJujAc/mz/ePuyxukL0L/TxTJul/kRteEUig+bevY/bKaGShRt3QvzzhcVrQyc9bWMGR16Orde/RyA1mG02vP/sjCVuowx7cSA=
Message-ID: <70318cbf0803042249j57d7f3a3j7666961a9132b10b@mail.gmail.com>
Date: Tue, 4 Mar 2008 22:49:47 -0800
From: "Christopher Li" <sparse@chrisli.org>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 6/9] drivers/net/wireless/iwlwifi/iwl-4965.c: Correct use of ! and &
Cc: "Julia Lawall" <julia@diku.dk>, yi.zhu@intel.com,
       linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       "Harvey Harrison" <harvey.harrison@gmail.com>,
       "Alexander Viro" <viro@ftp.linux.org.uk>, linux-sparse@vger.kernel.org,
       "Josh Triplett" <josh@freedesktop.org>
In-Reply-To: <20080305063842.GA24495@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0802262143570.18200@ask.diku.dk>
	 <20080305063842.GA24495@elte.hu>
X-Google-Sender-Auth: 425f03b5bdbb20f8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think Al Viro has sent a patch to linux-sparse with subject
"[PATCH 3/3] catch !x & y brainos" does exactly that.

Chris



On Tue, Mar 4, 2008 at 10:38 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
>  * Julia Lawall <julia@diku.dk> wrote:
>
>  > From: Julia Lawall <julia@diku.dk>
>  >
>  > In commit e6bafba5b4765a5a252f1b8d31cbf6d2459da337, a bug was fixed
>  > that involved converting !x & y to !(x & y).  The code below shows the
>  > same pattern, and thus should perhaps be fixed in the same way.
>
>
> >       if (sta_ht_inf) {
>  >               if ((!sta_ht_inf->ht_supported) ||
>  > -                (!sta_ht_inf->cap & IEEE80211_HT_CAP_SUP_WIDTH))
>  > +                (!(sta_ht_inf->cap & IEEE80211_HT_CAP_SUP_WIDTH)))
>  >                       return 0;
>
>  i'm wondering, could Sparse be extended to check for such patterns?
>
>  People are regularly running "make C=1" and are sending fixes to make
>  entire subsystems sparse-warning-free, so Sparse is a nice mechanism
>  that works and it keeps code clean in the long run.
>
>  I dont think the "!X & Y" pattern is ever used legitimately [and even if
>  it were used legitimately, it's easy to avoid the sparse false positive
>  - while in the buggy case we have a clear bug].
>
>         Ingo
>  --
>  To unsubscribe from this list: send the line "unsubscribe linux-sparse" in
>
>
> the body of a message to majordomo@vger.kernel.org
>  More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
