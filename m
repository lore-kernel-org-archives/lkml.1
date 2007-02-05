Return-Path: <linux-kernel-owner+w=401wt.eu-S933459AbXBEVTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933459AbXBEVTe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 16:19:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933460AbXBEVTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 16:19:34 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:45638 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933459AbXBEVTd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 16:19:33 -0500
Message-ID: <45C79F60.50305@garzik.org>
Date: Mon, 05 Feb 2007 16:19:28 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Alan <alan@lxorguk.ukuu.org.uk>
CC: Mark Lord <lkml@rtr.ca>, Patrick Ale <patrick.ale@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: hdparm for lib_pata
References: <8d158e1f0702030041xaa34440r125a39a85d498f4c@mail.gmail.com>	<45C773D6.3010009@rtr.ca> <20070205190947.680f2237@localhost.localdomain>
In-Reply-To: <20070205190947.680f2237@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan wrote:
>> Userspace PIO mode changes are NOT a good idea,
> 
> I would disagree there, but they are not high priority. We do need to
> allow set_features/xfer but we need to snoop it and mode set properly
> around it. There are cases you want to control this, more so admittedly
> for DMA speeds.

*Bingo*

That's the entire reason why libata does not support hdparm changing 
modes, etc.:  there is a lot involved in allowing random SET FEATURES - 
XFER MODE commands from userspace.  In some cases you have to stop all 
traffic on ports B,C,D,... in order to change the speed on port A.

	Jeff



