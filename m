Return-Path: <linux-kernel-owner+w=401wt.eu-S1754172AbYGXU4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172AbYGXU4R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 16:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751649AbYGXU4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 16:56:04 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44698
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751213AbYGXU4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 16:56:02 -0400
Date: Thu, 24 Jul 2008 13:56:02 -0700 (PDT)
Message-Id: <20080724.135602.196740386.davem@davemloft.net>
To: heiko.carstens@de.ibm.com
Cc: frank.blaschka@de.ibm.com, schwidefsky@de.ibm.com,
       linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [BUG] qeth doesn't work anymore because of netdev_priv changes
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080724184624.GB8969@osiris.boeblingen.de.ibm.com>
References: <20080724184624.GB8969@osiris.boeblingen.de.ibm.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>
Date: Thu, 24 Jul 2008 20:46:24 +0200

> git commit e3c50d5d25ac09efd9acbe2b2a3e365466de84ed
> "netdev: netdev_priv() can now be sane again." breaks qeth on s390
> (no more networking possible). Reverting the patch fixes it.
> I haven't looked into this any further.

You guys have to stop overriding netdev->priv if that's what
you're doing.

If you need a mid-layer private pointer, use netdev->ml_priv
as it's created exactly for that purpose.
