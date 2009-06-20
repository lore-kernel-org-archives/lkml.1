Return-Path: <linux-kernel-owner+w=401wt.eu-S1756227AbZFTIVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227AbZFTIVT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 04:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754054AbZFTIVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 04:21:06 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41956
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753610AbZFTIVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 04:21:04 -0400
Date: Sat, 20 Jun 2009 01:21:07 -0700 (PDT)
Message-Id: <20090620.012107.75903817.davem@davemloft.net>
To: jirislaby@gmail.com
Cc: linux-driver@qlogic.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Net: qla3xxx, remove sleeping in atomic
From: David Miller <davem@davemloft.net>
In-Reply-To: <1245424412-15106-1-git-send-email-jirislaby@gmail.com>
References: <1245424412-15106-1-git-send-email-jirislaby@gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>
Date: Fri, 19 Jun 2009 17:13:32 +0200

> Hi, we've found this sleep-inside-spinlock.
> 
> The fix below totally untested, please review carefully.
> 
> --
> 
> We cannot sleep in ql_reset_work under spinlock, unlock before sleep,
> relock after.
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

This looks good.  The spinlock is just required to be held
around the register accesses.  It's going to drop the lock
as soon as the bits settle post-reset anyways and then the
driver goes off and modifies other state outside of the lock.

Applied, thanks!
