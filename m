Return-Path: <linux-kernel-owner+w=401wt.eu-S1755181AbYD2BIH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181AbYD2BIH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 21:08:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752542AbYD2BHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 21:07:53 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:43041 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617AbYD2BHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 21:07:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=guw025UJDBWOTZP9MzT3+b3IyFbBWGct5GiBt19oQMeqDhXlpQGgqYrafvzs29oROecU3O0ftWqYB450DiK4+ry0Se4Q2SUIcYgImdsC1b1tUbqJ1rlkwRIsAaKaNZBBWq5KbCUZSeMz0/7BGCmTG0+K9AmtsW6krDywHdhFp0c=
Message-ID: <1ba2fa240804281807u2162bf28red586ae61fd881a@mail.gmail.com>
Date: Tue, 29 Apr 2008 03:07:51 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [2.6 patch] iwlwifi: move the selects to the tristate drivers
Cc: "Adrian Bunk" <bunk@kernel.org>, "David Miller" <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, reinette.chatre@intel.com,
       torvalds@linux-foundation.org, yi.zhu@intel.com,
       linux-wireless@vger.kernel.org
In-Reply-To: <20080428234548.GB3075@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080428054700.GA16177@Pilar.virtua.com.br>
	 <20080427.233507.261574307.davem@davemloft.net>
	 <20080428073212.GA7260@Pilar.virtua.com.br>
	 <20080428131552.GI16379@cs181133002.pp.htv.fi>
	 <20080428142129.GA5679@beyonder.ift.unesp.br>
	 <20080428205849.GB2813@cs181133002.pp.htv.fi>
	 <20080428234548.GB3075@tuxdriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/29/08, John W. Linville <linville@tuxdriver.com> wrote:
> On Mon, Apr 28, 2008 at 11:58:49PM +0300, Adrian Bunk wrote:
>
> > This patch moves the following select's:
> > - RFKILL        : IWLWIFI_RFKILL -> IWLCORE
> > - RFKILL_INPUT  : IWLWIFI_RFKILL -> IWLCORE
> > - MAC80211_LEDS : IWL4965_LEDS   -> IWLCORE
> > - LEDS_CLASS    : IWL4965_LEDS   -> IWLCORE
> > - MAC80211_LEDS : IWL3945_LEDS   -> IWL3945
> > - LEDS_CLASS    : IWL3945_LEDS   -> IWL3945
> >
> > The effects are:
> > - with IWLCORE=m and/or IWL3945=m RFKILL/RFKILL_INPUT/MAC80211_LEDS/LEDS_CLASS
> >   are no longer wrongly forced to y
> > - fixes a build error with IWLCORE=y, IWL4965=m
> >   might be a bug in kconfig causing it, but doing this change that is
> >   anyway the right thing fixes it
> >
> > Reported-by: Carlos R. Mafra <crmafra2@gmail.com>
> > Signed-off-by: Adrian Bunk <bunk@kernel.org>
>
> This seems sane to me -- I'm sorry I let so much Kconfig mess slip
> through on this driver in the first place!

I'm sorry too, this is just so no intuitive... I'm really amazed where
it get into yet constrain computation is always complex.  Next time I
put more effort in this.

Tomas

> > ---
> >
> > BTW: There's no correlation between IWL3945_LEDS and IWLWIFI_LEDS.
> >      That seems to be intended?
>
> Yes.  IWLWIFI_LEDS used to be IWL4965_LEDS, and I have the impression
> that eventually it will subsume IWL3945_LEDS as well.
>
True, not yet.



Thanks
Tomas
