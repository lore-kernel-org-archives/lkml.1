Return-Path: <linux-kernel-owner+w=401wt.eu-S1757395AbXLLPNQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757395AbXLLPNQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 10:13:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756227AbXLLPM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 10:12:59 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59999
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753071AbXLLPM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 10:12:58 -0500
Date: Wed, 12 Dec 2007 07:12:54 -0800 (PST)
Message-Id: <20071212.071254.180816076.davem@davemloft.net>
To: jesse.brandeburg@intel.com
Cc: joonwpark81@gmail.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au,
       auke-jan.h.kok@intel.com
Subject: Re: [PATCH] [NET]: Fix Ooops of napi net_rx_action.
From: David Miller <davem@davemloft.net>
In-Reply-To: <36D9DB17C6DE9E40B059440DB8D95F5203FBAF94@orsmsx418.amr.corp.intel.com>
References: <36D9DB17C6DE9E40B059440DB8D95F5203F82FC3@orsmsx418.amr.corp.intel.com>
	<b25c3fa70712111612o16a62b49g6709aa728f31e27a@mail.gmail.com>
	<36D9DB17C6DE9E40B059440DB8D95F5203FBAF94@orsmsx418.amr.corp.intel.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
Date: Tue, 11 Dec 2007 16:38:37 -0800

> @@ -3933,6 +3933,10 @@ quit_polling:
>                         e1000_set_itr(adapter);
>                 netif_rx_complete(poll_dev, napi);
>                 e1000_irq_enable(adapter);
> +               if (work_done == weight)
> +                       return work_done - 1;
> +               else
> +                       return work_done;

Don't do this.

If you processed "weight" worth of packets, return that
exact value and do not netif_rx_complete() and do not
re-enable interrupts.

That is the only correct fix.
