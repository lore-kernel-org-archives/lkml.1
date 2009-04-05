Return-Path: <linux-kernel-owner+w=401wt.eu-S1754628AbZDETJY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628AbZDETJY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 15:09:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754547AbZDETJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 15:09:04 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:45639 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754555AbZDETJE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 15:09:04 -0400
Date: Sun, 5 Apr 2009 21:09:00 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: "Cai, Cliff" <Cliff.Cai@analog.com>
Cc: "Bryan Wu" <cooloney@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmc: align data size for host which only supports
 power-of-2 block
Message-ID: <20090405210900.644a81bb@mjolnir.ossman.eu>
In-Reply-To: <0F1B54C89D5F954D8535DB252AF412FA03C5E04A@chinexm1.ad.analog.com>
References: <1236309321-23955-1-git-send-email-cooloney@kernel.org>
	<20090314213038.4d14526e@mjolnir.ossman.eu>
	<0F1B54C89D5F954D8535DB252AF412FA03C5D7C5@chinexm1.ad.analog.com>
	<20090325202335.42abc221@mjolnir.ossman.eu>
	<0F1B54C89D5F954D8535DB252AF412FA03C5E04A@chinexm1.ad.analog.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Mar 2009 10:22:54 +0800
"Cai, Cliff" <Cliff.Cai@analog.com> wrote:

> >
> >mmc_align_data_size() shouldn't be adjusting the size to something it
> >can easily determine that it's invalid.
> 
> Should I create a new function to do the power-of-2 adjustment?
> Or any ideal way to do it?

That function is the correct place. My point was that we need to check
after the adjustment that we didn't violate any of the other
restrictions the driver has set. If we do, we should just return the
original value.

> Otherwise,the SDH almost can't be used as sdio host.

Unfortunately I think this controller will be very unsuitable as an
SDIO controller anyway with that restriction.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
