Return-Path: <linux-kernel-owner+w=401wt.eu-S1758871AbZEBR6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758871AbZEBR6Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 13:58:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755877AbZEBR6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 13:58:13 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:34741 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756498AbZEBR6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 13:58:13 -0400
Date: Sat, 2 May 2009 19:58:11 +0200
From: Andreas Mohr <andi@lisas.de>
To: Jeff Garzik <jeff@garzik.org>
Cc: Lubomir Rintel <lkundrak@v3.sk>, netdev@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org
Subject: Re: [PATCH] Do not register ne2k-pci device until initialized
Message-ID: <20090502175811.GA26635@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49FC7D5E.6050203@garzik.org>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> Good spotting, that fixes a clear startup race

I saw this and thought that this must be one of those non-singular bugs
again... ;)

(I checked for dev_addr manipulations _after_ register_netdev)

And, well...:

smsc911x.c looks like it has the same issue (in case of a non-specified
MAC address - invalid EEPROM content).

Dito ucc_geth.c

Dito arm/ixp4xx_eth.c

Dito wireless/netwave_cs.c


Given that several drivers seem to violate this rule: is there a way
to add a check against this problem?

Andreas Mohr
