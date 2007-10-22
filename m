Return-Path: <linux-kernel-owner+w=401wt.eu-S1752996AbXJVX6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996AbXJVX6S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 19:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751222AbXJVX6D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 19:58:03 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59658
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751115AbXJVX6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 19:58:00 -0400
Date: Mon, 22 Oct 2007 16:58:22 -0700 (PDT)
Message-Id: <20071022.165822.126577184.davem@davemloft.net>
To: khc@pm.waw.pl
Cc: jeff@garzik.org, barkalow@iabervon.org, linas@austin.ibm.com,
       chunhao.huang@hotmail.com, gregkh@suse.de, htejun@gmail.com,
       brice.goglin@gmail.com, david.gaarenstroom@gmail.com,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       shane.huang@amd.com, linux-ide@vger.kernel.org, brice@myri.com
Subject: Re: [patch] PCI: disable MSI on more ATI NorthBridges
From: David Miller <davem@davemloft.net>
In-Reply-To: <m3ejfmu3a5.fsf@maximus.localdomain>
References: <Pine.LNX.4.64.0710221555190.32497@iabervon.org>
	<471D0ADC.7000005@garzik.org>
	<m3ejfmu3a5.fsf@maximus.localdomain>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Tue, 23 Oct 2007 01:40:18 +0200

> Jeff Garzik <jeff@garzik.org> writes:
> 
> > In general it is documented that INTX_DISABLE should apply only to
> > INTx# so devices that disable MSI based on that bit are out of spec.
> 
> The wording is:
> 10: This bit disables the device from asserting INTx#. A value of 0
> enables the assertion of its INTx# signal. A value of 1 disables the
> assertion of its INTx# signal. This bit's state after RST# is 0. Refer
> to Section 6.8.1.3 for control of MSI.
> 
> So strictly speaking it mandates disabling/enabling INTx but says
> nothing about other things (e.g. MSI). Some common sense dictates
> it shouldn't disable MSI, I guess.

Right, and every vendor I've spoken to who had the INTX_DISABLE
bug clearly acknowledged that it was a bug in their RTL design
and that they considered the spec to be clear on this matter
in that INTX_DISABLE should not influence MSI in any way.

> The "MSI Enable" description doesn't leave any doubt:
> 0: MSI Enable: If 1, the function is permitted to use MSI to request
> service and is prohibited from using its INTx# pin [...]

Things get more complicated with PCI-Express because INTx# isn't an
out-of-band "pin", but rather a message sent over the bus :-)
