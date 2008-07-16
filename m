Return-Path: <linux-kernel-owner+w=401wt.eu-S1754903AbYGPRfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903AbYGPRfV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 13:35:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751967AbYGPRfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 13:35:07 -0400
Received: from c60.cesmail.net ([216.154.195.49]:35576 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751809AbYGPRfG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 13:35:06 -0400
Subject: Re: [PATCH 5/5] Ath5k: suspend/resume fixes
From: Pavel Roskin <proski@gnu.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Nick Kossifidis <mickflemm@gmail.com>, Jiri Slaby <jirislaby@gmail.com>,
       linville@tuxdriver.com, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@gmail.com>
In-Reply-To: <200807160931.11473.jbarnes@virtuousgeek.org>
References: <1216136661-10930-1-git-send-email-jirislaby@gmail.com>
	 <1216136661-10930-4-git-send-email-jirislaby@gmail.com>
	 <40f31dec0807160915g8a5b083p9f21fae729839445@mail.gmail.com>
	 <200807160931.11473.jbarnes@virtuousgeek.org>
Content-Type: text/plain
Date: Wed, 16 Jul 2008 13:35:03 -0400
Message-Id: <1216229703.29744.23.camel@dv>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-07-16 at 09:31 -0700, Jesse Barnes wrote:
> On Wednesday, July 16, 2008 9:15 am Nick Kossifidis wrote:
> > It's ok for now, but have in mind that on my upcoming patch series i'm
> > disabling msi (commented out) since it results no interrupts on pci-e
> > cards (seems there is a bug in kernel's msi implementation).
> 
> Hm, would be good to get details here.  MSI is being used by other drivers 
> successfully...

That's true, but no driver uses the same interrupt handler with and
without MSI.  Either it's different handlers or the handler checks if
MSI is enabled and does something differently.

Checks is any interrupts are pending are different for MSI.  It may be
not hard to do (it's probably easier than for real interrupts), but it
has to be figured out.  Somebody has to do it right.  Until MSI is
supported by the interrupt handler, it should not be enabled by the
driver, or we get a non-functioning driver for AR5006.

I see that MSI is enabled in wireless-testing, but I think we should try
to avoid this mistake when the commit goes upstream.  I'm not sure what
the procedure there, but it would be nice to keep the tree bisectable,
i.e. avoid known regressions in any revision.  Maybe an amended commit
should go upstream, and we'll drop the original patch when rebasing to
the upstream branch?

-- 
Regards,
Pavel Roskin
