Return-Path: <linux-kernel-owner+w=401wt.eu-S1754738AbYINNsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738AbYINNsd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 09:48:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754109AbYINNsY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 09:48:24 -0400
Received: from server.drzeus.cx ([85.8.24.28]:39347 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753472AbYINNsY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 09:48:24 -0400
Date: Sun, 14 Sep 2008 15:48:17 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: "Matt Fleming" <mattjfleming@googlemail.com>
Cc: linux-kernel@vger.kernel.org, dbrownell@users.sourceforge.net
Subject: Re: [RFC][PATCH] MMC: Use write timeout value as read from CSR
Message-ID: <20080914154817.3d618e67@mjolnir.drzeus.cx>
In-Reply-To: <5ff4a1e50809090242ha576dcdmf82d1e9ec2204178@mail.gmail.com>
References: <5ff4a1e50809010812i32168136qea538ba177b81446@mail.gmail.com>
	<20080907123832.5ba79c12@mjolnir.drzeus.cx>
	<5ff4a1e50809080628i65bd7c7blfac70659a9f9229c@mail.gmail.com>
	<20080909092216.46a6eba1@mjolnir.drzeus.cx>
	<5ff4a1e50809090034y3156427bpfac8a07674c3c844@mail.gmail.com>
	<20080909094438.6423b8ef@mjolnir.drzeus.cx>
	<5ff4a1e50809090059i2bcdb7ber8cae07128eea5a77@mail.gmail.com>
	<20080909105513.5b8ceaaf@mjolnir.drzeus.cx>
	<5ff4a1e50809090207o5846f5udf709eeda81653eb@mail.gmail.com>
	<5ff4a1e50809090242ha576dcdmf82d1e9ec2204178@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0cvs92 (GTK+ 2.14.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Sep 2008 10:42:53 +0100
"Matt Fleming" <mattjfleming@googlemail.com> wrote:

> 
> The stack trace where this check is needed is here,
> 
> mmc_get_timeout()
> mmc_spi_readblock()
> mmc_spi_request()
> mmc_wait_for_req()
> mmc_send_cxd_data()
> mmc_send_csd()
> mmc_attach_sd()
> 
> Maybe it would be a good idea to move the line at
> drivers/mmc/core/mmc.c:447 up before the call to mmc_send_csd()? Then
> it'd probably be possible to remove that !host->mmc->card check from
> mmc_get_timeout().

No, that shouldn't be needed. If you look at mmc_send_cxd_data(), it
dutifully calls mmc_set_data_timeout(), so your check isn't needed (for
that case at least).

mmc_send_cid() is a bit more problematic. We probably need to
restructure things so that a mmc_card structure is available there as
well.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
