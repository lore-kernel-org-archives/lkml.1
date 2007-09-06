Return-Path: <linux-kernel-owner+w=401wt.eu-S1758096AbXIFMkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758096AbXIFMkz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 08:40:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756213AbXIFMks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 08:40:48 -0400
Received: from 74-93-104-98-Washington.hfc.comcastbusiness.net ([74.93.104.98]:33258
	"EHLO picasso.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755805AbXIFMkr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 08:40:47 -0400
Date: Thu, 06 Sep 2007 05:40:38 -0700 (PDT)
Message-Id: <20070906.054038.74750747.davem@davemloft.net>
To: matthew@wil.cx
Cc: shaohua.li@intel.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, akpm@linux-foundation.org,
       gregkh@suse.de
Subject: Re: [RFC] disable PCIE 'Enable No Snoop' bit by default
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070906115730.GE14130@parisc-linux.org>
References: <1189056908.24368.9.camel@sli10-conroe.sh.intel.com>
	<20070906115730.GE14130@parisc-linux.org>
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Wilcox <matthew@wil.cx>
Date: Thu, 6 Sep 2007 05:57:31 -0600

> I'm not sure your analysis is correct.  Here's what my draft copy of
> the pcie 2.0 spec says:
> 
>   Enble No Snoop ­ If this bit is Set, the Function is permitted to
>   Set the No Snoop bit in the Requester Attributes of transactions it
>   initiates that do not require hardware enforced cache coherency (see
>   Section 2.2.6.5). Note that setting this bit to 1b should not cause
>   a Function to Set the No Snoop attribute on all transactions that it
>   initiates. Even when this bit is Set, a Function is only permitted
>   to Set the No Snoop attribute on a transaction when it can guarantee
>   that the address of the transaction is not stored in any cache in
>   the system.  This bit permitted to be hardwired to 0b if a Function
>   would never Set the No Snoop attribute in transactions it initiates.
>   Default value of this bit is 1b.
> 
> That implies that devices are only allowed to set it when it's safe to
> do so ... and we don't need to turn it off.

This is my understanding of this area of PCI-E as well, and I
also agree that therefore we should not turn this bit off.

