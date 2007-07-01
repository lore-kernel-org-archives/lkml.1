Return-Path: <linux-kernel-owner+w=401wt.eu-S1756925AbXGAKYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756925AbXGAKYP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 06:24:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755375AbXGAKYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 06:24:05 -0400
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:34523
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754960AbXGAKYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 06:24:04 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Lennert Buytenhek <buytenh@wantstofly.org>
Subject: Re: [PATCH] b44: power down PHY when interface down
Date: Sun, 1 Jul 2007 12:23:16 +0200
User-Agent: KMail/1.9.6
Cc: =?iso-8859-1?q?T=F6r=F6k_Edvin?= <edwintorok@gmail.com>,
       zambrano@broadcom.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, power@bughost.org
References: <4354d3270706300447ladcda4by987b1f87963112f9@mail.gmail.com> <200707010024.40649.mb@bu3sch.de> <20070630231734.GF2553@xi.wantstofly.org>
In-Reply-To: <20070630231734.GF2553@xi.wantstofly.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707011223.17235.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 01 July 2007 01:17:34 Lennert Buytenhek wrote:
> More or less.  You can't add the resistances like that, since the
> bus isolation chip buffers the IDSEL signal, but it is correct that
> if the host's IDSEL resistor is larger than a certain value, the
> combination of the resistive coupling of IDSEL plus the extra buffer
> in the isolator might be causing the IDSEL input on the 'guest' PCI
> board to assert too late (or not assert at all), causing config
> accesses to fail.
> 
> (This also depends on the specific 'guest' PCI board used, as you
> noted, due to differing IDSEL trace lengths/capacitances and input
> pin capacitances on different PCI boards.  Also, it might work at
> 33 MHz but not work at 66 MHz, etc.)

It doesn't work on any of my boards :(

> If you feel adventurous, you could try to hack around this by
> figuring out which AD[31:16] line this PCI slot's IDSEL line is
> resistively coupled to (depends on the slot), and then adding
> another parallel resistor on the board itself to make the bus
> isolator's input buffer charge faster.  Note that this does
> increase the load on that specific AD[] line, which might cause
> other funny effects.

Well, but how to find out to which address line it's connected to?
Pretty hard to follow the PCB traces, especially since it's
multilayered.

-- 
Greetings Michael.
