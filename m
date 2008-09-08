Return-Path: <linux-kernel-owner+w=401wt.eu-S1753732AbYIHOFO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732AbYIHOFO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 10:05:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752752AbYIHOE6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 10:04:58 -0400
Received: from 2-1-3-15a.ens.sth.bostream.se ([82.182.31.214]:45955 "EHLO
	zoo.weinigel.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706AbYIHOE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 10:04:57 -0400
Message-ID: <48C53107.7090103@weinigel.se>
Date: Mon, 08 Sep 2008 16:04:55 +0200
From: Christer Weinigel <christer@weinigel.se>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Ben Dooks <ben-linux@fluff.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [patch 2/3] s3cmci - call pio_tasklet from IRQ
References: <20080908124848.541807034@zoo.weinigel.se> <20080908124909.554600509@zoo.weinigel.se> <20080908134656.GB30478@trinity.fluff.org>
In-Reply-To: <20080908134656.GB30478@trinity.fluff.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Dooks wrote:
> On Mon, Sep 08, 2008 at 02:48:50PM +0200, Christer Weinigel wrote:
>> Scheduling a tasklet to perform the pio transfer introduces a bit of
>> extra processing, just call pio_tasklet directly from the interrupt
>> instead.  Writing up to 64 bytes to a FIFO is probably uses less CPU
>> than scheduling a tasklet anyway.
> 
> Hmm, i'd be interested to find out how long these are taking... I might
> try and rig up something to test the time being taken via an SMDK.
> 
> If the fifo read/writes are taking significant amounts of time, then the
> pio tasklet will at least improve the interrupt latencies invloved, as
> iirc we're currently running the main irq handler in IRQ_DISABLED mode
> to stop any problems with re-enternancy.... I'll check this and see what
> is going on.

It should be possible to set a flag and then call the pio_task after the 
spin_unlock_irqrestore instead.  I didn't want to do that to change as 
little of the logic as possible, but it's probably better to do that.

I'm also thinking of changing send_request to do a busy wait for 
commands without data, that will probably need a bit larger changes.

   /Christer
