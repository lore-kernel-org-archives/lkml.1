Return-Path: <linux-kernel-owner+w=401wt.eu-S935111AbXHHOtN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935111AbXHHOtN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 10:49:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758390AbXHHOs6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 10:48:58 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:33765 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758279AbXHHOs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 10:48:57 -0400
X-Sasl-enc: 9V+x4kHJ3nV4C8DA1nnhGAsmGrFQ6WTkLQPoiO2uqW/W 1186584536
Date: Wed, 8 Aug 2007 11:48:54 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
       ibm-acpi-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [ibm-acpi-devel] suspend/hibernation regression between 2.6.19
	and 2.6.20 w/ Thinkpad T41
Message-ID: <20070808144854.GB9587@khazad-dum.debian.net>
References: <200708051902.18801.toralf.foerster@gmx.de> <200708081122.55036.toralf.foerster@gmx.de> <20070808120416.GA554@khazad-dum.debian.net> <200708081442.12641.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708081442.12641.rjw@sisk.pl>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 08 Aug 2007, Rafael J. Wysocki wrote:
> > I wish we loaded the kernel just once, maybe from the boot loader.
> 
> Well, that's not so easy.  That will work for the bare image, but if we want it
> to be compressed and/or encrypted, then the boot loader will need to
> contain all of the necessary code.

Doing things right always have an associated cost, or we'd be doing it right
since day one...

> I may be doable by using a special boot kernel with ACPI disabled and only
> as many drivers as required to load the image, but that will make it more
> difficult to set up and to recover from errors.

Better than the walking bomb we have now.  When waking from suspend-to-disk,
we should not overwrite ANY non-kernel data which has ties to external
systems (the hardware, the firmware).  Instead, we should re-init everything
(re-init hardware to make sure we know in which state it is, re-init
ourselves, to make sure we match the firmware and hardware state), as if we
were booting a cold system in the first place.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
