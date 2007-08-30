Return-Path: <linux-kernel-owner+w=401wt.eu-S1762320AbXH3Bi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762320AbXH3Bi0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 21:38:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759782AbXH3BiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 21:38:13 -0400
Received: from nz-out-0506.google.com ([64.233.162.237]:63189 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757144AbXH3BiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 21:38:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LyCzw+fHj5XSgGjrOGZZmXG9KlSBXlOqFz1hJAAusYWcoMp4N7QSHaUJ0xuINSEWM7XP9lBiAR3H+cW00iMzjdmcabt0pSdtLmgqt6za4e4EWcwfHHfBuYCRcNbJXUmdQXGPMn8ES3hECgC0CYP/UpYdd1RJmHsi4rvX8ZA13/U=
Message-ID: <40f31dec0708291838p5d33eb34p3b4432d9d270841a@mail.gmail.com>
Date: Thu, 30 Aug 2007 04:38:09 +0300
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Christoph Hellwig" <hch@infradead.org>,
       "Jiri Slaby" <jirislaby@gmail.com>, linville@tuxdriver.com,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH 5/5] Net: ath5k, kconfig changes
In-Reply-To: <20070828171330.GD29343@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2713029743177393055@pripojeni.net>
	 <280951420471148977@pripojeni.net>
	 <20070828171330.GD29343@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/8/28, Christoph Hellwig <hch@infradead.org>:
> On Tue, Aug 28, 2007 at 12:01:30PM -0400, Jiri Slaby wrote:
> > +config ATH5K_AR5210
> > +     bool "Support AR5210"
> > +     depends on ATH5K
> > +     default y
> > +
> > +config ATH5K_AR5211
> > +     bool "Support AR5211"
> > +     depends on ATH5K
> > +     default y
> > +
> > +config ATH5K_AR5212
> > +     bool "Support AR5212"
> > +     depends on ATH5K
> > +     default y
>
> Please don't add more default statements.
>
> Also this whole patch seems rather pointless.  It saves only
> very little and turns the driver into a complete ifdef maze.

It saves big chunks of code (not only initial register settings
arrays) and we'll extend it's use more inside ath5k_hw.c Trust me this
is a very useful step, eg. check out descriptor processing / setup or
PHY functions (calibrate/channel set etc). For example AR5210 mac chip
only comes with RF5110 phy chip so we can get rid of RF5111/RF5112
code, AR5211 comes with RF5111 so we can get rid of RF5110 and RF5112
code and AR5212 comes with RF5111 or RF5112 so we get rid of RF5110.
This thing also saves lots of checks during runtime (some of them
happen verry frequently, eg. durring descriptor processing). Also most
people will use 5212 code only, 5211 cards are on some old laptops and
5210, well i couldn't even find  a 5210 for actual testing :P

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
