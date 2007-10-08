Return-Path: <linux-kernel-owner+w=401wt.eu-S1754393AbXJHHHJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754393AbXJHHHJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 03:07:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752538AbXJHHGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 03:06:55 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58258
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752114AbXJHHGy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 03:06:54 -0400
Date: Mon, 08 Oct 2007 00:06:53 -0700 (PDT)
Message-Id: <20071008.000653.51864134.davem@davemloft.net>
To: arnd@arndb.de
Cc: jeff@garzik.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] net/core: split dev_ifsioc() according to locking
From: David Miller <davem@davemloft.net>
In-Reply-To: <200710070217.09073.arnd@arndb.de>
References: <20071006204212.GA32177@havoc.gtf.org>
	<200710070217.09073.arnd@arndb.de>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Date: Sun, 7 Oct 2007 02:17:08 +0200

> On Saturday 06 October 2007, Jeff Garzik wrote:
> > 
> > This always bugged me:  dev_ioctl() called dev_ifsioc() either inside
> > read_lock(dev_base_lock) or rtnl_lock(), depending on the ioctl being
> > executed.
> > 
> > This change moves the ioctls executed inside dev_base_lock to a new
> > function, dev_ifsioc_locked().  Now the locking context is completely
> > clear to the reader.
> > 
> > Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
> 
> Great idea!

I think so too, applied, thanks!
