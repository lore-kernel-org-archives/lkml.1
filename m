Return-Path: <linux-kernel-owner+w=401wt.eu-S1755357AbYIGKiq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357AbYIGKiq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 06:38:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753072AbYIGKii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 06:38:38 -0400
Received: from server.drzeus.cx ([85.8.24.28]:53696 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752973AbYIGKih (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 06:38:37 -0400
Date: Sun, 7 Sep 2008 12:38:32 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: "Matt Fleming" <mattjfleming@googlemail.com>
Cc: linux-kernel@vger.kernel.org, dbrownell@users.sourceforge.net
Subject: Re: [RFC][PATCH] MMC: Use write timeout value as read from CSR
Message-ID: <20080907123832.5ba79c12@mjolnir.drzeus.cx>
In-Reply-To: <5ff4a1e50809010812i32168136qea538ba177b81446@mail.gmail.com>
References: <5ff4a1e50809010812i32168136qea538ba177b81446@mail.gmail.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Sep 2008 16:12:03 +0100
"Matt Fleming" <mattjfleming@googlemail.com> wrote:

> Currently, the MMC/SD over SPI code has a hard-coded timeout value of
> 250ms on writes. This is correct for SD cards and is specified in the
> spec, but it is not correct for MMC cards. For MMC cards the values
> that is read from the CSR should be used.
> 
> There is already code to ensure that the write timeout value for SD
> cards does not exceed 250ms, this patch only affects the MMC case.
> 

This actually isn't fully correct for SD either as it only specifies
that 250 ms is the upper bound on the timeout.

I believe the proper way of solving this is to have mmc_spi respect the
timeouts set in the request structure. Modify mmc_set_data_timeout() if
necessary.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
