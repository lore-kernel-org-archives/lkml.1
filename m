Return-Path: <linux-kernel-owner+w=401wt.eu-S1763991AbXGaWhO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763991AbXGaWhO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 18:37:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758426AbXGaWg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 18:36:59 -0400
Received: from gate.crashing.org ([63.228.1.57]:39850 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758636AbXGaWg6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 18:36:58 -0400
In-Reply-To: <46A78E3F.1030904@ru.mvista.com>
References: <20070725165318.5331.23795.stgit@localhost.localdomain>	<20070725165326.5331.19920.stgit@localhost.localdomain> <46A78322.3080607@ru.mvista.com> <46A78E3F.1030904@ru.mvista.com>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <a414f3b506b7802a717e6e2c08befd1e@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Vitaly Bordug <vitb@kernel.crashing.org>, linux-ide@vger.kernel.org
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH 2/2] [POWERPC] MPC8349E-mITX: use platform IDE driver for CF	interface
Date: Wed, 1 Aug 2007 00:36:14 +0200
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>> +	ide@f0000000 {
>>> +		compatible = "mmio-ide";
>>> +		device_type = "ide";
>
>>     Why not "ata"?

The hardware is called (E)IDE, the protocol is called ATA.
Or that's what I was told -- I think there's some historic
revisionism involved, too.

>     Also, what mmio-ide in the compat properly means in the context of
> ide_platform which is able to handle both port and memory mapped IDE. 
> I think
> we must get rid with this crap, and since this IDE register mapping is 
> pretty
> much board specific, call it something like "mpc8349emitx-ide" instead.

"mmio-ide" simply is not specific enough.  The device_type
should go, too.

If this IDE interface is board-specific, thee "compatible"
property should include the board vendor name and board
name.  Oh, that's what "emitx" tries to do -- it could be
a bit clearer perhaps ;-)


Segher

