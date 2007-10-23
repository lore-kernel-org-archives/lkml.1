Return-Path: <linux-kernel-owner+w=401wt.eu-S1752895AbXJWKOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895AbXJWKOR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 06:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751757AbXJWKN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 06:13:59 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:50778 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751658AbXJWKN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 06:13:57 -0400
Message-ID: <471DC95D.2060501@garzik.org>
Date: Tue, 23 Oct 2007 06:13:49 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: Daniel Barkalow <barkalow@iabervon.org>,
       Linas Vepstas <linas@austin.ibm.com>,
       Shane Huang <chunhao.huang@hotmail.com>, davem@davemloft.net,
       gregkh@suse.de, htejun@gmail.com, brice.goglin@gmail.com,
       david.gaarenstroom@gmail.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, shane.huang@amd.com,
       linux-ide@vger.kernel.org, Brice Goglin <brice@myri.com>
Subject: Re: [patch] PCI: disable MSI on more ATI NorthBridges
References: <BLU112-W5125F6D8BEB3DF6359D53E29F0@phx.gbl>	<20071019195749.GK29903@austin.ibm.com> <471911BE.2000405@garzik.org>	<Pine.LNX.4.64.0710221555190.32497@iabervon.org>	<471D0ADC.7000005@garzik.org> <m3ejfmu3a5.fsf@maximus.localdomain>
In-Reply-To: <m3ejfmu3a5.fsf@maximus.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa wrote:
> Jeff Garzik <jeff@garzik.org> writes:
> 
>> Note that INTX_DISABLE is a recent addition to PCI.
> 
> It's PCI 2.3.

Yes.


>>  Older PCI devices
>> support neither MSI nor INTX-disable, so make sure such devices don't
>> creep into your sample.
> 
> MSI has been introduced by PCI 2.2 (and thus PCI-X 1.0) so there may
> be devices with MSI but without INTx-disable bit. I guess I have some
> early PCI-X hardware with MSI but I don't know if they have INTx-disable
> bit and I can't currently test that.
> And it probably doesn't matter.

Time will tell :)


>> In general it is documented that INTX_DISABLE should apply only to
>> INTx# so devices that disable MSI based on that bit are out of spec.
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
> 
> The "MSI Enable" description doesn't leave any doubt:
> 0: MSI Enable: If 1, the function is permitted to use MSI to request
> service and is prohibited from using its INTx# pin [...]

Right.  I was merely describing the end result, the union of that 
language as it applies to the kernel.

	Jeff


