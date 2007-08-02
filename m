Return-Path: <linux-kernel-owner+w=401wt.eu-S1754280AbXHBJXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280AbXHBJXc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 05:23:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752680AbXHBJXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 05:23:18 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42265
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752090AbXHBJXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 05:23:17 -0400
Date: Thu, 02 Aug 2007 02:23:17 -0700 (PDT)
Message-Id: <20070802.022317.66176729.davem@davemloft.net>
To: joachim.deguara@amd.com
Cc: mchan@broadcom.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, michal.k.k.piotrowski@gmail.com,
       netdev@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [REGRESSION] tg3 dead after s2ram
From: David Miller <davem@davemloft.net>
In-Reply-To: <200708021115.10812.joachim.deguara@amd.com>
References: <1186002023.18322.7.camel@dell>
	<200708021005.45773.joachim.deguara@amd.com>
	<200708021115.10812.joachim.deguara@amd.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Joachim Deguara" <joachim.deguara@amd.com>
Date: Thu, 2 Aug 2007 11:15:05 +0200

> Seams like even if powersave shuts down the network that the device should 
> still work after a suspend to ram, so who is at fault here?

It's a good question.

The pci_enable() is done on the PCI device at probe time, at least in
the tg3 driver, and with such a model restoring and saving of PCI
config space should not be dependant upon whether the netdev is
running or not.
