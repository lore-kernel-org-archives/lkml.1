Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752404Ab0APJT5 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 04:19:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752198Ab0APJT4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 04:19:56 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51782
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751049Ab0APJTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 04:19:55 -0500
Date: Sat, 16 Jan 2010 01:20:04 -0800 (PST)
Message-Id: <20100116.012004.166836523.davem@davemloft.net>
To: Tristram.Ha@Micrel.Com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        shemminger@vyatta.com
Subject: Re: [PATCH 2.6.33 1/3] net: Micrel KSZ8841/2 PCI Ethernet driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <14385191E87B904DBD836449AA30269D021A4A@MORGANITE.micrel.com>
References: <14385191E87B904DBD836449AA30269D021A4A@MORGANITE.micrel.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ha, Tristram" <Tristram.Ha@Micrel.Com>
Date: Fri, 15 Jan 2010 18:57:59 -0800

> The KSZ8842 has a switch with lots of hardware configurations.  The =
> driver uses the proc system to allow users to configure the switch.  If =
> this is not desired the whole thing can be removed by not calling the =
> init_proc() function.

I think there needs to be a serious discussion about how
this driver uses bridge layer internals by doing things like:

+/* Needed for STP support. */
+#ifdef CONFIG_KSZ8842_STP
+#include <../net/bridge/br_private.h>
+#endif

and uses procfs to configure the ports.

Stephen please look this over and make suggestions for better
ways to support and configure these kinds of devices.

Thanks.
