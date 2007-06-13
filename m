Return-Path: <linux-kernel-owner+w=401wt.eu-S1759532AbXFMSlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759532AbXFMSlS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 14:41:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759340AbXFMSks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 14:40:48 -0400
Received: from rtr.ca ([64.26.128.89]:3338 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754934AbXFMSkq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 14:40:46 -0400
Message-ID: <46703A2D.6000207@rtr.ca>
Date: Wed, 13 Jun 2007 14:40:45 -0400
From: Mark Lord <liml@rtr.ca>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: albertl@mail.com
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: libata passthru: support PIO multi commands
References: <200706112200.l5BM0qFn005767@hera.kernel.org>	<20070611233917.4bd8c6d7@the-village.bc.nu>	<466DE438.70108@garzik.org>	<20070612111621.10074408@the-village.bc.nu>	<466EB937.6050807@garzik.org> <20070612170519.5f427a70@the-village.bc.nu> <466F5D11.7000404@tw.ibm.com>
In-Reply-To: <466F5D11.7000404@tw.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Albert Lee wrote:
> ..
> It looks like the ATA passthru commands contain more information than
> what libata needs to execute a command.
> 
> e.g. protocol number:
>      libata could possibly infer the protocol from the command opcode.
> 
> e.g. multi_count:
>      libata caches dev->multi_count. Passing multi_count along with
>      each passthru command looks useless for libata.     
> 
> e.g. t_dir:
>      libata could possible infer the direction from the command opcode
>      or from the protocol number (e.g. 4: PIO_IN / 5: PIO_OUT).

I wonder if the *intent* of the specification was that the low-level driver
should perform whatever setup is necessary to issue the command as given.

So if the command specifies a multcount of 8, then the LLD should issue the
appropriate initialization commands to use a multcount of 8, and then issue
the given R/W MULT command, and then perhaps reset the multcount back to
what it was normally (beforehand) ?

Ditto for the others.

I am *not* proposing that we actually do it this way,
but rather just suggesting a possible rationale.

What does the SAT spec say?  Any further hints as to the intent?

Cheers
