Return-Path: <linux-kernel-owner+w=401wt.eu-S1754907AbZESSlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907AbZESSlQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 14:41:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752880AbZESSlK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 14:41:10 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:43297 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289AbZESSlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 14:41:10 -0400
Date: Tue, 19 May 2009 19:40:59 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Trilok Soni <soni.trilok@gmail.com>
Cc: Linus Walleij <linus.ml.walleij@gmail.com>,
       Mike Rapoport <mike@compulab.co.il>, linux-kernel@vger.kernel.org,
       sameo@linux.intel.com, linux-i2c@vger.kernel.org,
       Linus Walleij <linus.walleij@stericsson.com>
Message-ID: <20090519184059.GB4476@sirena.org.uk>
References: <63386a3d0905181340y42ad1868k6b2978e586abc18d@mail.gmail.com> <4A12C3B5.2050100@compulab.co.il> <63386a3d0905190923t36d301c5hf245c06db00b6127@mail.gmail.com> <5d5443650905191026w22b0ff95j992e09923f55dd0a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d5443650905191026w22b0ff95j992e09923f55dd0a@mail.gmail.com>
X-Cookie: You will never know hunger.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/1] MFD: Add U300 AB3100 core support v2
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 19, 2009 at 10:56:16PM +0530, Trilok Soni wrote:

> I don't know but why people are not encouraging to use mfd_xxx apis
> here? Lot's of drivers are available under drivers/mfd, but only
> couple of them are using real mfd_xxx apis? Is there anything missing
> in those apis?

The mfd_ APIs only really help with memory mapped platform devices but a
lot of MFD devices are controlled using I2C and SPI interfaces instead.
On registration they need to at least do something extra to allow the
client devices to access the I2C or SPI control structure, or the client
drivers have to do something like fish around using their parent
pointer.

It's not so much that there's something wrong with the MFD APIs as
issues with splitting up I2C and SPI devices for access in a generic
manner.  With things mapped through struct resource the MFD API is able
to provide some help.
