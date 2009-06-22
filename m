Return-Path: <linux-kernel-owner+w=401wt.eu-S1754308AbZFVXbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308AbZFVXbl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 19:31:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752282AbZFVXbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 19:31:33 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38459
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751444AbZFVXbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 19:31:32 -0400
Date: Mon, 22 Jun 2009 16:31:36 -0700 (PDT)
Message-Id: <20090622.163136.246300819.davem@davemloft.net>
To: bzolnier@gmail.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cs5520: add missing IRQ setup for the second port
From: David Miller <davem@davemloft.net>
In-Reply-To: <200906221348.02632.bzolnier@gmail.com>
References: <200906221348.02632.bzolnier@gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date: Mon, 22 Jun 2009 13:48:02 +0200

> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] cs5520: add missing IRQ setup for the second port
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
> This is obviously correct regression fix.  The only problem is that
> it cannot be applied under the new rigid policy before somebody with
> the hardware verifies it.  This will only result in a needless delay
> in this case (IMHO a common sense works better than rigid policies).

Such hard rules don't apply to regression fixes.  Patch
applied, thanks.

But I certainly would have required some positive testing for the
commit which introduced this problem!

I've added some verbosity to the commit message, so that people can
track where the problem was introduced, and exactly how this problem
arose, like so:

cs5520: add missing IRQ setup for the second port

This fixes a regression introduced by commit
86ccf37c6acd74cf7e4b7751ee045de19943c5a0 ("ide: remove pciirq argument
from ide_pci_setup_ports()")

ide_pci_setup_ports() would loop over the available ports, one
by one, recording IRQ numbers increasingly from the one passed
in as "pciirq".  The conversion only assigned the initial port's
IRQ, 14, but left the second one not setup.

[ Make commit message more verbose -DaveM ]

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
