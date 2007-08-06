Return-Path: <linux-kernel-owner+w=401wt.eu-S933999AbXHFXAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933999AbXHFXAn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 19:00:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765586AbXHFXAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 19:00:25 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:41912 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765419AbXHFXAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 19:00:23 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46B7A7E9.5080606@s5r6.in-berlin.de>
Date: Tue, 07 Aug 2007 00:59:53 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.5) Gecko/20070804 SeaMonkey/1.1.3
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Olaf Hering <olh@suse.de>, linuxppc-dev@ozlabs.org, stable@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.22.y] ieee1394: revert "sbp2: enforce	32bit	DMA	mapping"
References: <fa.Qn3Snqoik3hhnxcA6HqjGV0Yzck@ifi.uio.no> <46B4B3DC.7020609@shaw.ca> <46B4B7C6.1040107@s5r6.in-berlin.de> <1186272926.938.8.camel@localhost.localdomain> <46B5824B.1000103@s5r6.in-berlin.de> <1186351473.938.21.camel@localhost.localdomain> <20070806135124.GA2900@suse.de> <1186436848.938.75.camel@localhost.localdomain> <46B79F25.50205@s5r6.in-berlin.de> <46B79FD7.9020801@shaw.ca> <1186439529.938.95.camel@localhost.localdomain> <46B7A22D.4030909@shaw.ca>
In-Reply-To: <46B7A22D.4030909@shaw.ca>
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> I would agree, though, that sbp2 isn't really the place for setting
> this, since the DMA mask is presently a property of the device, not of
> the user..

The mask that sbp2 set was because sbp2 has (in theory, not yet in
practice) a _narrower requirement on address ranges than the chip_ ---
hence it has (in theory) a narrower requirement on DMA mappings than the
ohci1394 driver has.

That's because sbp2 uses the controller in a special mode, as a bus
bridge.  It is the only user of that feature among the higher-level IEEE
1394 drivers.  No other IEEE 1394 application-layer software has this
requirement.

(Well, debugging and forensic tools rely on that mode too, notably
BenH's firescope, but this software runs remote, hence it's a different
beast from sbp2.)
-- 
Stefan Richter
-=====-=-=== =--- --===
http://arcgraph.de/sr/
