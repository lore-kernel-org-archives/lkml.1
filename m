Return-Path: <linux-kernel-owner+w=401wt.eu-S1755808AbYF1NhD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755808AbYF1NhD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 09:37:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752685AbYF1Ngy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 09:36:54 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:49691 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930AbYF1Ngy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 09:36:54 -0400
Date: Sat, 28 Jun 2008 15:37:04 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mmc: Export internal host state through debugfs
Message-ID: <20080628153704.36eda3e6@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <20080628152856.3ba1c2ff@mjolnir.drzeus.cx>
References: <1214478589-21291-1-git-send-email-haavard.skinnemoen@atmel.com>
	<20080628152856.3ba1c2ff@mjolnir.drzeus.cx>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Jun 2008 13:36:51.0923 (UTC) FILETIME=[05C9F230:01C8D924]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman <drzeus-mmc@drzeus.cx> wrote:
> On Thu, 26 Jun 2008 13:09:47 +0200
> Haavard Skinnemoen <haavard.skinnemoen@atmel.com> wrote:
> 
> > From: Haavard Skinnemoen <hskinnemoen@atmel.com>
> > 
> > This adds a new config option, MMC_DEBUG_FS which will, when enabled,
> > create a few files under /sys/kernel/debug containing information
> > about an mmc host's internal state.
> > 
> > Host drivers can add additional files and directories under the host's
> > root directory by passing the debugfs_root field in struct mmc_host as
> > the 'parent' parameter to debugfs_create_*.
> > 
> > Unfinished: No files are actually created yet.
> > 
> > Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
> > ---
> 
> Is there any point to having a separate option for this? Can't we just
> include it if DEBUG_FS is defined?

Sure. It doesn't introduce any additional overhead, just a bit of extra
code.

> Otherwise the system looks ok to me, assuming that everyone is of the
> opinion that debugfs is _not_ a stable API.

That's my assumption at least. Debugfs is just a place where you can
throw random stuff that may help you debugging stuff.

> > +
> > +#else
> > +static inline void mmc_add_host_debugfs(struct mmc_host *host)
> > +{
> > +
> > +}
> > +
> > +static inline void mmc_remove_host_debugfs(struct mmc_host *host)
> > +{
> > +
> > +}
> > +#endif
> > +
> 
> In the other places we have conditional function, it is done by
> ifdef:ing the calls instead. There are just two of them, so it should
> be less mess.

Hmm. You mean it's better with three #ifdefs than one?

Haavard
