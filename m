Return-Path: <linux-kernel-owner+w=401wt.eu-S1755143AbXJIF0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755143AbXJIF0a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 01:26:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751634AbXJIF0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 01:26:23 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40677
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751556AbXJIF0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 01:26:23 -0400
Date: Mon, 08 Oct 2007 22:26:22 -0700 (PDT)
Message-Id: <20071008.222622.22041332.davem@davemloft.net>
To: benh@kernel.crashing.org
Cc: david-b@pacbell.net, linux-usb-users@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, greg@kroah.com
Subject: Re: OHCI root_port_reset() deadly loop...
From: David Miller <davem@davemloft.net>
In-Reply-To: <1191906816.6355.62.camel@pasglop>
References: <20071008.165420.42793456.davem@davemloft.net>
	<20071009040917.DC7FC237446@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
	<1191906816.6355.62.camel@pasglop>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Tue, 09 Oct 2007 15:13:36 +1000

> I'm not even sure module load order is 100% fault proof here since
> khubd spawns as a thread...

I'm concerned about that as well, thanks for bringing it up.

My understanding, however, is that the critical thing is that the EHCI
device reset being done by the EHCI driver probe occurs and completes
first.  If that is true, then just making sure EHCI loads initially is
a sufficient constraint to fix this problem.
