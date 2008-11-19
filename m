Return-Path: <linux-kernel-owner+w=401wt.eu-S1754569AbYKSSli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569AbYKSSli (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 13:41:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752580AbYKSSla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 13:41:30 -0500
Received: from server.drzeus.cx ([85.8.24.28]:38504 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752485AbYKSSla (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 13:41:30 -0500
Date: Wed, 19 Nov 2008 19:41:27 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Ben Dooks <ben-linux@fluff.org>
Cc: Ben Dooks <ben-linux@fluff.org>, linux-kernel@vger.kernel.org,
       sdhci-devel@list.drzeus.cx
Subject: Re: [patch 6/7] SDHCI: Check DMA for overruns at end of transfer
Message-ID: <20081119194127.34204891@mjolnir.drzeus.cx>
In-Reply-To: <20081116000508.GE9161@fluff.org.uk>
References: <20081103200944.099353331@fluff.org.uk>
	<20081103201010.820070757@fluff.org.uk>
	<20081114230026.18513b8a@mjolnir.drzeus.cx>
	<20081116000508.GE9161@fluff.org.uk>
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Nov 2008 00:05:08 +0000
Ben Dooks <ben-linux@fluff.org> wrote:

> On Fri, Nov 14, 2008 at 11:00:26PM +0100, Pierre Ossman wrote:
> > 
> > I'm sorry, but I don't see how this is anywhere near acceptable. This
> > should be a panic at the very least, and until this can be sorted out
> > and avoided the driver should avoid using DMA on these chips.
> 
> A panic won't help get the debug logs out of the kernel.

Indeed, but it will avoid corrupting the system.

> This only
> turned up whilst debugging the controller, I got the timeout clock
> calculation wrong and thus ended up timing out pretty much all the
> CMD25s and seeing this problem.
> 

Just because you had to provoke it doesn't mean it won't appear under
"normal" circumstances for others.

Until this problem is fully understood I think DMA should be turned off
(or possibly needs to be explicitly forced on using Kconfig or a module
parameter).

Do you have any contacts at Samsung that can help out here?

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
