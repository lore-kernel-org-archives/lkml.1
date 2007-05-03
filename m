Return-Path: <linux-kernel-owner+w=401wt.eu-S1161820AbXECKbO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161820AbXECKbO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 06:31:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161817AbXECKbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 06:31:13 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60861
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1161820AbXECKbM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 06:31:12 -0400
Date: Thu, 03 May 2007 03:31:13 -0700 (PDT)
Message-Id: <20070503.033113.25133545.davem@davemloft.net>
To: ilpo.jarvinen@helsinki.fi
Cc: michal.k.k.piotrowski@gmail.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: kernel BUG at include/net/tcp.h:739
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0705030841140.3607@kivilampi-30.cs.helsinki.fi>
References: <4638F14E.6000803@googlemail.com>
	<Pine.LNX.4.64.0705030841140.3607@kivilampi-30.cs.helsinki.fi>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ilpo_Järvinen" <ilpo.jarvinen@helsinki.fi>
Date: Thu, 3 May 2007 09:51:36 +0300 (EEST)

> [PATCH] [TCP]: Use S+L catcher only with SACK for now
> 
> TCP has a transitional state when SACK is not in use during
> which this invariant is temporarily broken. Without SACK,
> tcp_clean_rtx_queue does not decrement sacked_out. Therefore
> calls to tcp_sync_left_out before sacked_out is again
> corrected by tcp_fastretrans_alert can trigger this trap as
> sacked_out still has couple of segments that are already out
> of window.
> 
> Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>

It would be nice to fix non-SACK as you say, but this is good
enough for now.
