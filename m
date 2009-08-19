Return-Path: <linux-kernel-owner+w=401wt.eu-S1751529AbZHSBvB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529AbZHSBvB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 21:51:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751312AbZHSBvB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 21:51:01 -0400
Received: from ru.mvista.com ([213.79.90.228]:44933 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750992AbZHSBvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 21:51:00 -0400
Date: Wed, 19 Aug 2009 05:51:01 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Pierre Ossman <pierre@ossman.eu>, David Vrabel <david.vrabel@csr.com>,
       Ben Dooks <ben@fluff.org>, Sascha Hauer <s.hauer@pengutronix.de>,
       linux-kernel@vger.kernel.org, sdhci-devel@lists.ossman.eu,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH v2] powerpc/85xx: Add eSDHC support for MPC8536DS boards
Message-ID: <20090819015101.GA10782@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20090807195724.GA24020@oksana.dev.rtsoft.ru>
 <20090807195822.GG2735@oksana.dev.rtsoft.ru>
 <A17F24A0-87E0-4FFA-9C14-DF57D8A9D015@kernel.crashing.org>
 <20090818233818.GA29042@oksana.dev.rtsoft.ru>
 <F58A75CD-73CC-4F75-AF51-2BCC0B828E84@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <F58A75CD-73CC-4F75-AF51-2BCC0B828E84@kernel.crashing.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 18, 2009 at 08:24:17PM -0500, Kumar Gala wrote:
> 
> On Aug 18, 2009, at 6:38 PM, Anton Vorontsov wrote:
> 
> >This patch simply adds sdhci node to the device tree.
> >
> >We specify clock-frequency manually, so that eSDHC will work without
> >upgrading U-Boot. Though, that'll only work for default setup (1500
> >MHz) on new board revisions. For non-default setups, it's recommended
> >to upgrade U-Boot, since it will fixup clock-frequency automatically.
> >
> >Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> 
> out of interest the 85xx eSDHC don't need the sdhci,wp-inverted
> property?

Yes, eSDHC controllers in MPC85xx report normal state in its
registers.

But the funny thing is that the switch itself is inverted,
so to enable writing, on MPC8569E-MDS and MPC8536DS boards
we have to place card's write protect tab into "lock" position.

Unfortunately we can't fix that in software since controller
doesn't permit write operations if it detects write-protected
state. On the bright side, IIRC MPC8536DS revision history
says that WP line level is fixed via BCSR upgrade. Not sure
if it is possible to fix it for MPC8569E-MDS.

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
