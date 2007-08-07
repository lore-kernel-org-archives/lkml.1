Return-Path: <linux-kernel-owner+w=401wt.eu-S934800AbXHGO5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934800AbXHGO5A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 10:57:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934428AbXHGO4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 10:56:42 -0400
Received: from cluster-g.mailcontrol.com ([85.115.41.190]:44638 "EHLO
	cluster-g.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934325AbXHGO4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 10:56:40 -0400
Message-ID: <46B885CC.6030404@csr.com>
Date: Tue, 07 Aug 2007 15:46:36 +0100
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-list@drzeus.cx>
CC: linux-kernel@vger.kernel.org
Subject: Re: [patch 4/4] sdio: disable CD resistor
References: <11858961933491-git-send-email-david.vrabel@csr.com>	<20070804152304.65ed8f1b@poseidon.drzeus.cx>	<46B6F877.7060504@csr.com>	<20070806171207.59fafa18@poseidon.drzeus.cx>	<46B73F18.5030109@csr.com>	<20070806220145.66b97559@poseidon.drzeus.cx>	<46B86ADB.90000@csr.com>	<46B86BDF.8050700@csr.com> <20070807154342.47f63cfe@poseidon.drzeus.cx>
In-Reply-To: <20070807154342.47f63cfe@poseidon.drzeus.cx>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Aug 2007 14:46:42.0915 (UTC) FILETIME=[C5261330:01C7D901]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman wrote:
> On Tue, 07 Aug 2007 13:55:59 +0100
> David Vrabel <david.vrabel@csr.com> wrote:
> 
>> sdio: disable CD resistor
>>
>> Disable the card detect resistor to ensure all data lines are equally
>> loaded. Not doing this can have a negative impact on buses with
>> marginal signal quality.
>>
>> Signed-off-by: David Vrabel <david.vrabel@csr.com>
> 
> I'm not sure about this. I've seen several hosts which lack a
> mechanical detect switch.

If host is correctly designed it will have identical pull-ups on all the
DAT lines, and therefore this internal pull-up should be disconnected.

However, given that disabling the pull-up may cause 4 bit transfers to
fail on hardware that omits a host-side pull-up on DAT3 I agree that the
resistor should remain enabled.

Is there an example driver for a host that uses pin 1/DAT3 sensing for
card detection?  I'm curious about how removal detections work.

App Note on card detection goes into the use of this resistor in more
detail but I don't believe this document is publicly available :(.

David
-- 
David Vrabel, Software Engineer, Drivers group  Tel: +44 (0)1223 692562
CSR plc, Churchill House, Cambridge Business Park, Cowley Road, CB4 0WZ


.
