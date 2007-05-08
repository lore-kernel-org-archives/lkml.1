Return-Path: <linux-kernel-owner+w=401wt.eu-S967848AbXEHFAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967848AbXEHFAb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 01:00:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967842AbXEHFAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 01:00:30 -0400
Received: from smtp107.sbc.mail.mud.yahoo.com ([68.142.198.206]:39889 "HELO
	smtp107.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S967814AbXEHFAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 01:00:30 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=k7zc8K6n4LWkD/qUZAV2Y+9S946VoHnuNCHT8mPlDuQae2xB5Lz+JC6+x9jbQTkUrh09TMgJFxuSFRzTp6bmQnFt9CaiYdLEmaRnt+R/cFRLsXtYaS1d6yPa8rJtrNFZhc5whkIgjYtOxw1EYtwjHhe4QbtIEW1YAMW7Odko6Hk=  ;
X-YMail-OSG: UFMIKf8VM1lJENtr1D1_iTT6jEn97WEz7GfWnU3jaiK4ob78Yz1Lwh.2uWxXB1lr0SNPeCrR3w--
From: David Brownell <david-b@pacbell.net>
To: "Mike Frysinger" <vapier.adi@gmail.com>
Subject: Re: [spi-devel-general] adding bits_per_word to struct spi_board_info to mirror struct spi_device
Date: Mon, 7 May 2007 21:53:45 -0700
User-Agent: KMail/1.9.6
Cc: spi-devel-general@lists.sourceforge.net, "Wu, Bryan" <Bryan.Wu@analog.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
References: <8bd0f97a0704250305qe6175cdm8e1a0cd7844f67bc@mail.gmail.com> <200704250813.30999.david-b@pacbell.net> <8bd0f97a0705071647w58c6055ehc54dd6b520a8e227@mail.gmail.com>
In-Reply-To: <8bd0f97a0705071647w58c6055ehc54dd6b520a8e227@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705072153.46411.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 May 2007, Mike Frysinger wrote:
> On 4/25/07, David Brownell <david-b@pacbell.net> wrote:
> > On Wednesday 25 April 2007, Mike Frysinger wrote:
> 
> > > is there something obvious i'm missing ?  seems to me that if the
> > > generic spi framework respects bits_per_word on a per-spi device
> > > basis, then it should be exposed in the generic info structure so that
> > > the setting can be tracked in the boards file ...
> >
> > The initial driver set didn't need it, that's all.  ISTR someone
> > else pointed out this quirk, but never provided a patch to resolve
> > the issue.
> 
> so which direction should it be ?  or should it be both ? :)

Add bits_per_word to spi_board_info, and have the device creation
logic copy it into spi_device as it's created.


> Blackfin at the moment is doing DMA/bits_per_word setup in the boards
> ... we could move these to the drivers and have each one just call
> spi_setup() at init, or i could post a patch for the common framework
> if you think that's an OK direction to [also] go ...

I don't see what you're getting at here.  The SPI core doesn't
do anything with DMA, beyond passing DMA addresses through when
necessary.  (Needed to handle messages derived from scatterlists,
since I don't want lower layers to know scatterlists, but otherwise
uncommon.)

And when each spi_device is created, the core calls spi_setup()
with the data.  That seems like the natural place to set up
things like DMA and so forth...

The pxa2xx_spi driver uses spi_board_info.controller_data to pass
dma setup/tuning data from board init logic.  

- Dave
