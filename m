Return-Path: <linux-kernel-owner+w=401wt.eu-S932865AbXAWPmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932865AbXAWPmS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 10:42:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932903AbXAWPmS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 10:42:18 -0500
Received: from smtp106.sbc.mail.mud.yahoo.com ([68.142.198.205]:26799 "HELO
	smtp106.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932865AbXAWPmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 10:42:17 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=P5uf2hmX0/ZEa/RLrrArK2cX1BRvAR6JlY7qJ1qtvH7TxQyDd6WebOokurIwJ3zS1wOzGrg7jszyhXcUIjUgKIpGxkKI4VQr40J3xJoEUo58nHBPcBEDusV8l/IGoaGEUHd/SX+GAcnwz3n5FwXLVUgNsBSDYMaygKLhuPt5PtU=  ;
X-YMail-OSG: BgtwwVAVM1lwEFoZtrz8OfdfDuubCzCECWVWa2z8XVZZG1L_Wv3m_QaUgX20BFlRgJAQCCoMt5SijUQg8txouQT5H8Js7HknI1usGdUORzngW2Ya4Vuksx6j_SPuaOt_4u7a7wnKiFlSSF1gFQ_hE_YcG81OltfR
From: David Brownell <david-b@pacbell.net>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Subject: Re: [PATCH 2.6.20-rc5] SPI: alternative fix for spi_busnum_to_master
Date: Tue, 23 Jan 2007 07:42:15 -0800
User-Agent: KMail/1.7.1
Cc: linux-kernel@vger.kernel.org, hcegtvedt@atmel.com, akpm@osdl.org
References: <20070118.202849.70477632.nemoto@toshiba-tops.co.jp> <200701221412.02452.david-b@pacbell.net> <20070123.101011.25910575.nemoto@toshiba-tops.co.jp>
In-Reply-To: <20070123.101011.25910575.nemoto@toshiba-tops.co.jp>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701230742.15531.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 January 2007 5:10 pm, Atsushi Nemoto wrote:
> On Mon, 22 Jan 2007 14:12:02 -0800, David Brownell <david-b@pacbell.net> wrote:
> > > Here is a revised version.  The children list of spi_master_class
> > > contains only spi_master class so we can just compare bus_num member
> > > instead of class_id string.
> > 
> > Looks just a bit iffy ... though, thanks for helping to finally
> > sort this out!
> 
> Well, so previous patch (which was checking class_id string) would be
> preferred?

No, with this rename support lurking, checking names becomes risky.


> > > +		cdev = class_device_get(cdev);
> > > +		if (!cdev)
> > > +			continue;
> > 
> > That "continue" case doesn't seem like it should be possible... but
> > at any rate, the "get" can be deferred until the relevent class
> > device is known, since that _valid_ handle can't disappear so long
> > as that semaphore is held.  And if you find the right device but
> > can't get a reference ... no point in continuing!
> > 
> > Something like a class_find_device() would be the best way to solve
> > this sort of problem, IMO.  But we don't have one of those.  :(
> 
> Indeed the check can be omitted.  Should I send a new patch just
> moving class_device_get() into "if (master->bus_num == bus_num)"
> block?

Yes, please.

 
> The crashing with udev is 2.6.20 regression so I wish this fixed very
> soon.  Thank you for review.

Agreed.

- Dave


 
> ---
> Atsushi Nemoto
> 
