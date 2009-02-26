Return-Path: <linux-kernel-owner+w=401wt.eu-S1757777AbZBZVM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757777AbZBZVM5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 16:12:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753244AbZBZVMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 16:12:47 -0500
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:33359 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751193AbZBZVMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 16:12:46 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=wUKG0TPL6nNELynDzDZ4bH0AZwSSQ3YfaStSqVZ/7Qand3asVIDzH/zv9UmK3jQRRGnN6TeIHdmgsI2/BfAZvG1D83bcsRujfLVagAmJNghfjt8cxTHRff+IXt4sDwkxJyJgP360i7t+EYXEVX1eEobj9TIAuahaErPFY/U5uKM=  ;
X-YMail-OSG: dYMsRIgVM1k0nwEPIKqX9HgnFqnEGBtD7.Zbb7oGqZoTR6zXkVhee0VtY5iQTzjtV4HviOTd2HQLJ4XPsP5Hw1SONTAUauRqP52LaK2wfwj5ROHUeTHbMUFcGewwfQFmyZyj22TZS2RAvcasyyHHF4I8HkMZRTv8fq2DlVTXAWgLkn9pGH45T.rU0SKJjzc9H8.CMoTXlpH8ehdIzc3cyx4vSK.IKnxWaB61jA0-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Mark Brown <broonie@sirena.org.uk>
Subject: Re: [patch 2.6.29-rc6 1/2] regulator: enumerate voltages (v2)
Date: Thu, 26 Feb 2009 13:12:42 -0800
User-Agent: KMail/1.9.10
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, lkml <linux-kernel@vger.kernel.org>,
       OMAP <linux-omap@vger.kernel.org>
References: <200902081037.06645.david-b@pacbell.net> <200902261148.36892.david-b@pacbell.net> <20090226202055.GE8595@sirena.org.uk>
In-Reply-To: <20090226202055.GE8595@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902261312.42720.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 February 2009, Mark Brown wrote:
> On Thu, Feb 26, 2009 at 11:48:36AM -0800, David Brownell wrote:
> 
> > Updates since previous version:  address feedback, simplify.
> 
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> 
> This looks good to merge to me - coincidentally I've got a use case for
> it lined up already.  Might it be worth merging the MMC client along
> with this patch if the relevant maintainers are OK with that, could help
> get it in faster?

You mean, that example MMC code I sent?  I think it's a bit
early to merge to mainline ... only the "generate ocr_mask"
call has really been verified.  I'll send the updated version
along though.

I had thought about sending that with patches to convert the
omap_hsmmc driver over to the regulator framework.  No skin
off my back if it goes with a different set of patches though.


> Just two very minor points which might be nice to fix at some point:
> 
> > +			cmin = INT_MIN;
> > +			cmax = INT_MAX;
> > +		}
> > +
> > +		/* else require explicit machine-level constraints */
> > +		else if (cmin <= 0 || cmax <= 0 || cmax < cmin) {
> 
> That indentation is going to catch some people out :)

Maybe.


> > +		/* final: [min_uV..max_uV] valid iff constraints valid */
> > +		if (max_uV < min_uV) {
> > +			pr_err("%s: %s '%s' voltage constraints\n",
> > +				       __func__, "unsupportable", name);
> > +			ret = -EINVAL;
> 
> That style is going to hurt grepability for the error.

"grep unsupportable" ... :)

Sharing the primary string saves about three dozen bytes,
and I'm not keen on needless bloat.

