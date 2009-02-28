Return-Path: <linux-kernel-owner+w=401wt.eu-S1754692AbZB1J7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692AbZB1J7Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 04:59:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752593AbZB1J7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 04:59:17 -0500
Received: from mail.openmoko.org ([88.198.124.205]:47606 "EHLO
	mail.openmoko.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096AbZB1J7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 04:59:16 -0500
Date: Sat, 28 Feb 2009 15:28:48 +0530
From: Balaji Rao <balajirrao@openmoko.org>
To: Simon Kagstrom <simon.kagstrom@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Andy Green <andy@openmoko.com>, spi-devel-general@lists.sourceforge.net
Subject: Re: [PATCH 2/2] spi_bitbang: Add support for non-blocking
	synchronous transfers
Message-ID: <20090228095846.GA32044@fedora.yogi>
References: <20090228081036.31964.80618.stgit@fedora.yogi> <20090228081117.31964.51155.stgit@fedora.yogi> <20090228100914.2ec2ff7f@lska2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090228100914.2ec2ff7f@lska2>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 28, 2009 at 10:09:14AM +0100, Simon Kagstrom wrote:

Hi Simon,

> Thanks for taking this up Balaji!


You are welcome.
 
> In the comment below I'm assuming the Openmoko accelerometer use of
> this functionality, which would include doing SPI transfers in the
> interrupt handler.
> 

> 
> > +/* Synchronous non blocking transfer */
> > +int
> > +spi_bitbang_transfer_sync(struct spi_device *spi, struct spi_message
> > *m) +{
> > [...]
> > +		if (setup_transfer) {
> > +			status = setup_transfer(spi, t);
> > [...]
> > +			if (!m->is_dma_mapped)
> > +				t->rx_dma = t->tx_dma = 0;
> > +			status = bitbang->txrx_bufs(spi, t);
> 
> Another thing that we'd need to take care of is that the stuff being
> called from the synhronous transfer is actually callable from interrupt
> context. Looking at txrx_bufs for s3c24xx (s3c24xx_spi_txrx), it's
> using a wait_for_completion which is in turn completed by the s3c24xx
> SPI interrupt handler.
> 
> Without trying, I'm guessing that that won't be possible from interrupt
> context.
> 

The master is not spi_s3c24xx but spi_s3x24xx_gpio, whose txrx are very
simple code.

Additionally all of this has been tested and found to work. The code,
along with the modified new spi based lis302dl driver is all in
andy-tracking [1].

[1] - git://git.openmoko.org/git/kernel.git andy-tracking

Thanks,
Balaji
