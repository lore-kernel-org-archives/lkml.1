Return-Path: <linux-kernel-owner+w=401wt.eu-S1754168AbZHJPAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168AbZHJPAe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 11:00:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753419AbZHJPAd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 11:00:33 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51615
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753175AbZHJPAc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 11:00:32 -0400
Date: Mon, 10 Aug 2009 08:00:42 -0700 (PDT)
Message-Id: <20090810.080042.259707687.davem@davemloft.net>
To: u.kleine-koenig@pengutronix.de
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, linux@arm.linux.org.uk,
       dbaryshkov@gmail.com, kernel@wantstofly.org, netdev@vger.kernel.org
Subject: Re: [PATCH 5/6] [NET] ixp2000/enp2611: don't set non-existent
 member get_stats
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090810094027.GA22200@pengutronix.de>
References: <1249677761-19470-5-git-send-email-u.kleine-koenig@pengutronix.de>
	<20090809.214906.143672876.davem@davemloft.net>
	<20090810094027.GA22200@pengutronix.de>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Date: Mon, 10 Aug 2009 11:40:27 +0200

> Yes, I tried that, but stopped when I saw it's declared const.  I don't
> know if this is required.  If yes then the only way to fix it is to add
> a platform callback that is called if non-NULL.

The easiest way to handle this is to have another copy of the ops,
which has the other get_stats member value, and to assign that as
the netdev_ops when the relevant condition holds.

> I don't want to invest time here without a word by the maintainers
> though.

But we can't apply the patch you initially posted, that's for sure
:-)
