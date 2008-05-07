Return-Path: <linux-kernel-owner+w=401wt.eu-S1759594AbYEGMoB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759594AbYEGMoB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 08:44:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759091AbYEGMng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 08:43:36 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:53693 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758932AbYEGMnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 08:43:33 -0400
X-Sasl-enc: 0BPqLp+g+vLTYCixodtAUGN4H00zsVHdxmzq4Xm2ZpHz 1210164211
Date: Wed, 7 May 2008 09:43:30 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Holger Macht <hmacht@suse.de>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "Accardi, Kristen C" <kristen.c.accardi@intel.com>
Subject: Re: [PATCH] bay: Exit if notify handler cannot be installed
Message-ID: <20080507124330.GB19475@khazad-dum.debian.net>
References: <20080505202508.GA3690@homac> <20080506091522.GA4378@homac> <1210065811.12668.1.camel@sli10-desk.sh.intel.com> <20080506151846.GA22828@khazad-dum.debian.net> <1210122279.27316.2.camel@sli10-desk.sh.intel.com> <20080507011354.GA8163@khazad-dum.debian.net> <1210123658.30944.6.camel@sli10-desk.sh.intel.com> <20080507123715.GA19475@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080507123715.GA19475@khazad-dum.debian.net>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Forgot one detail:
On Wed, 07 May 2008, Henrique de Moraes Holschuh wrote:
> 2. Even if a bay can take different types of devices, the same bay may
> appear as a number of different EJ0 handlers.  In that case, the
> firmware is to know which handler to use based on which type of device
> is inside the bay.  Thinkpads do this.

But calling EJ0 on any of the devices that might fit the bay will eject
whatever is in the bay, regardless of it being the "active device" in
the bay or not.

This is why bay can be used in a thinkpad to eject BAT1 (a battery),
their EJ0 handlers do exactly the same thing.  You don't get the bay
request eject and bay ejected events since bay.c doesn't tie itself to
the battery ACPI node, but you can eject it.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
