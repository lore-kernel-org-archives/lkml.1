Return-Path: <linux-kernel-owner+w=401wt.eu-S1760781AbYDBHA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760781AbYDBHA4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 03:00:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759883AbYDBHAS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 03:00:18 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47899
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1759578AbYDBHAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 03:00:16 -0400
Date: Wed, 02 Apr 2008 00:00:17 -0700 (PDT)
Message-Id: <20080402.000017.222512990.davem@davemloft.net>
To: hidave.darkstar@gmail.com
Cc: davej@codemonkey.org.uk, netdev@vger.kernel.org,
       linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
       marcel@holtmann.org
Subject: Re: [PATCH 2/2] bluetooth : __rfcomm_dlc_close lock fix
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080402060243.GB3050@darkstar.te-china.tietoenator.com>
References: <20080402060243.GB3050@darkstar.te-china.tietoenator.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Young <hidave.darkstar@gmail.com>
Date: Wed, 2 Apr 2008 14:02:43 +0800

> Lockdep warning will be trigged while rfcomm connection closing.
> 
> The locks taken in rfcomm_dev_add:
> rfcomm_dev_lock --> d->lock
> 
> In __rfcomm_dlc_close:
> d->lock --> rfcomm_dev_lock (in rfcomm_dev_state_change)
> 
> There's two way to fix it, one is in rfcomm_dev_add we first locking
> d->lock then the rfcomm_dev_lock
> 
> The other (in this patch), remove the locking of d->lock for
> rfcomm_dev_state_change because just locking "d->state = BT_CLOSED;"
> is enough.

Also applied, thanks a lot Dave!
