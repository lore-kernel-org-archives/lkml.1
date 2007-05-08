Return-Path: <linux-kernel-owner+w=401wt.eu-S967725AbXEHDrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967725AbXEHDrt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 23:47:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967719AbXEHDrs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 23:47:48 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:28784 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967717AbXEHDrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 23:47:47 -0400
X-IronPort-AV: i="4.14,503,1170651600"; 
   d="scan'208"; a="37817427:sNHT24621912"
Subject: Re: [spi-devel-general] adding bits_per_word to struct
	spi_board_info to mirror struct spi_device
From: Bryan WU <bryan.wu@analog.com>
To: David Brownell <david-b@pacbell.net>,
       Mike Frysinger <vapier.adi@gmail.com>
Cc: spi-devel-general@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <8bd0f97a0705071647w58c6055ehc54dd6b520a8e227@mail.gmail.com>
References: <8bd0f97a0704250305qe6175cdm8e1a0cd7844f67bc@mail.gmail.com>
	 <200704250813.30999.david-b@pacbell.net>
	 <8bd0f97a0705071647w58c6055ehc54dd6b520a8e227@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 08 May 2007 11:48:26 +0800
Message-Id: <1178596106.5222.3.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-05-07 at 19:47 -0400, Mike Frysinger wrote:
> On 4/25/07, David Brownell <david-b@pacbell.net> wrote:
> > On Wednesday 25 April 2007, Mike Frysinger wrote:
> > > the spi_device structure has a bits_per_word so that you can change
> > > the value on a per-device setting, yet the spi_board_info structure
> > > does not ... this means that the bus-specific structure has to have a
> > > bits_per_word member which the spi bus driver will copy into the spi
> > > device bits_per_word member
> >
> > Actually that's more likely a driver-specific characteristic than
> > something related to board wiring/configuration ... a characteristic
> > of the particular protocol requests being made.  That's why for
> > example bits_per_word has a per-transfer override, and drivers are
> > able to call spi_setup(spi).
> 
> hmm, true ...
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
> 
> Blackfin at the moment is doing DMA/bits_per_word setup in the boards
> ... we could move these to the drivers and have each one just call
> spi_setup() at init, or i could post a patch for the common framework
> if you think that's an OK direction to [also] go ...
> -mike

Yes, it is very common for spi_framework. DMA setting as well as
bits_per_word setup should be imported to spi_board_info struct. And
currently, there are some duplicated data members in spi_device struct
spi_board_info struct. This two structs are confused driver writers and
boards driver users.

Thanks
-Bryan Wu
