Return-Path: <linux-kernel-owner+w=401wt.eu-S1759228AbYEPUs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759228AbYEPUs0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 16:48:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752830AbYEPUsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 16:48:19 -0400
Received: from an-out-0708.google.com ([209.85.132.241]:63924 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158AbYEPUsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 16:48:18 -0400
Message-ID: <fa686aa40805161348t52b94956w112ef6926ff30892@mail.gmail.com>
Date: Fri, 16 May 2008 14:48:16 -0600
From: "Grant Likely" <grant.likely@secretlab.ca>
To: "Jon Smirl" <jonsmirl@gmail.com>
Subject: Re: [RFC PATCH 0/4] Describe SPI devices in the OF device tree and add mpc5200-spi driver
Cc: linuxppc-dev@ozlabs.org, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, dbrownell@users.sourceforge.net,
       fabrizio.garetto@gmail.com
In-Reply-To: <9e4733910805161327u4c42fd1dg5b09319d89db447c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080516193054.28030.35126.stgit@trillian.secretlab.ca>
	 <9e4733910805161327u4c42fd1dg5b09319d89db447c@mail.gmail.com>
X-Google-Sender-Auth: a306407ec82ced4a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2008 at 2:27 PM, Jon Smirl <jonsmirl@gmail.com> wrote:
> On 5/16/08, Grant Likely <grant.likely@secretlab.ca> wrote:
>> This series is a set of changes to allow the slaves on an SPI bus to be
>>  described in the OF device tree (useful in arch/powerpc) and adds a driver
>>  that uses it (the Freescale MPC5200 SoC's SPI device).
>
> Right now we have SPI hooked up to PSC3. Hardware engineer is gone but
> I'll see if I can get him to alter things to use the SPI controller. I
> have an old mail from him where he thinks the Phytec board is missing
> a signal needed to use the SPI controller.

While I'd appreciate the testing, I suspect that you really don't want
to do that.  The dedicated SPI controller isn't very good.  It only
does a byte at a time and so is rather slow.  A PSC is SPI mode should
be better (but I haven't tried it personally it yet).

>
> Is the current SPI driver working on PSC3? I have a MMC card wired up
> to it but I've never tried using it.

It should work.

> I have the MPC5200 PSC SPI driver enabled and "MMC/SD over SPI"
> enabled in my kernel. The MMC bus gets created but there aren't any
> devices on it. Do we need something in the SPI driver so that the MMC
> layer can find it?

Yes, see patch 3 in my series.  the PSC SPI driver needs to do
something like this.  SPI busses don't really do autodetection (but
some sub-protocols, like MMC, do IIRC).

> Are you going to keeps this as two drivers or merge them? If it is two
> drivers there should be one entry in Kconfig and two sub choices for
> the types of drivers.

It will remain as two drivers.  The devices are entirely separate.  I
don't think putting them under a single Kconfig is needed or a good
idea.  They both depend on PPC_MPC52xx anyway so they only show up if
you're building for a 5200 platform.

Thanks for the comments.

Cheers,
g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
