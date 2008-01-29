Return-Path: <linux-kernel-owner+w=401wt.eu-S1753044AbYA2XfR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044AbYA2XfR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 18:35:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754751AbYA2XfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 18:35:05 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:39842 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754113AbYA2XfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 18:35:03 -0500
Subject: Re: Udev coldplugging loads 8139too driver instead of 8139cp
From: Jon Masters <jonathan@jonmasters.org>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Frederik Himpe <fhimpe@telenet.be>, LKML <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org
In-Reply-To: <479E7750.9060304@msgid.tls.msk.ru>
References: <1201554992.13883.13.camel@Anastacia>
	 <479E7750.9060304@msgid.tls.msk.ru>
Content-Type: text/plain
Organization: World Organi[sz]ation Of Broken Dreams
Date: Tue, 29 Jan 2008 18:34:16 -0500
Message-Id: <1201649657.2271.81.camel@perihelion>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-01-29 at 03:46 +0300, Michael Tokarev wrote:

> Udev in fact loads both - 8139cp and 8139too.  The difference is the ORDER
> in which it loads them - if for "cp-handled" hardware it first loads "too",
> too will complain as above and will NOT claim the device.  The same is
> true for the opposite.

Actually, it's the order in which the probe functions run, which is
typically related to the order in which they are loaded. You can
blacklist one driver and get the other instead.

> I don't know what happened in 2.6.24, but my guess is that since 8139too-based
> hw is now alot more common, the two drivers are listed in the opposite
> order.

Nah. Random build ordering as it always has been - two different builds
would end up with modules in a different order on disk, hence depmod
would generate a different ordering. This will be fixed shortly with the
Modules.order bits, but you will still need to blacklist one of the
drivers (unless you're lucky and 8139too comes first), until there is
proper support for dynamic rebinding and udev rules to do that.

> In short: NotABug, or ComplainToRealtec (but that's waaaay too late and
> will not help anyway) ;)

Nah. It's a "bug" insomuch as we don't handle multiple matching aliases
very well, and it's becoming more common, so we probably should :)

Jon.


