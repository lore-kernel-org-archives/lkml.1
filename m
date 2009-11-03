Return-Path: <linux-kernel-owner+w=401wt.eu-S1753621AbZKCNiN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621AbZKCNiN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 08:38:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751523AbZKCNiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 08:38:13 -0500
Received: from smtp.nokia.com ([192.100.122.233]:62551 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbZKCNiM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 08:38:12 -0500
From: Peter Ujfalusi <peter.ujfalusi@nokia.com>
To: ext Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 3/5] MFD: twl4030-codec: APLL_INFREQ handling in the MFD driver
Date: Tue, 3 Nov 2009 15:37:50 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-gentoo; KDE/4.3.2; i686; ; )
Cc: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "sameo@linux.intel.com" <sameo@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tony@atomide.com" <tony@atomide.com>
References: <1257165295-9352-1-git-send-email-peter.ujfalusi@nokia.com> <1257165295-9352-4-git-send-email-peter.ujfalusi@nokia.com> <20091102173035.GC8546@rakim.wolfsonmicro.main>
In-Reply-To: <20091102173035.GC8546@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <200911031537.50430.peter.ujfalusi@nokia.com>
X-OriginalArrivalTime: 03 Nov 2009 13:37:56.0012 (UTC) FILETIME=[D9A3E6C0:01CA5C8A]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 November 2009 19:30:35 ext Mark Brown wrote:
> On Mon, Nov 02, 2009 at 02:34:53PM +0200, Peter Ujfalusi wrote:
> > Move the APLL_CTL register configuration to the twl4030-codec
> > MFD driver.
> > Provide also a function for childs to query the audio_mclk
> > frequency.
> 
> This all looks good to me, some nitpicks below.
> 
> > +unsigned int twl4030_codec_get_mclk(void)
> > +{
> > +	struct twl4030_codec *codec = platform_get_drvdata(twl4030_codec_dev);
> > +
> > +	return codec->audio_mclk;
> > +}
> > +EXPORT_SYMBOL_GPL(twl4030_codec_get_mclk);
> 
> As I said in my followup to patch 5 this feels like it should have a
> parameter to specify the twl4030 though in practical systems it won't
> matter.

I agree that this does not look quite nice, but as you already mentioned, it is 
highly unlikely that one system would have more than one twl series of PM chip 
on board. Another reason is that we have other part of the twl, which needs 
resources from the codec part, but it is not loaded through the codec MFD, so 
providing the needed information is kind of tricky with that setup.

> 
> > +	if (!(pdata->audio_mclk == 19200000 ||
> > +	      pdata->audio_mclk == 26000000 ||
> > +	      pdata->audio_mclk == 38400000)) {
> > +		dev_err(&pdev->dev, "Invalid audio_mclk\n");
> > +		return -EINVAL;
> > +	}
> 
> Might flow more naturally with a switch statement?

Yes, true. This looks weird, I'll change it.

> 

-- 
Péter
