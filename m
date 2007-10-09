Return-Path: <linux-kernel-owner+w=401wt.eu-S1756908AbXJIPmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756908AbXJIPmY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 11:42:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756086AbXJIPmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 11:42:17 -0400
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:31684 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755354AbXJIPmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 11:42:16 -0400
Message-ID: <470BA14C.90608@panasas.com>
Date: Tue, 09 Oct 2007 17:42:04 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Michael Stiller <ms@2scale.net>, linux-kernel@vger.kernel.org
Subject: Re: howto boost write(2) performance?
References: <1191937817.3641.9.camel@blackberry> <p73odf849rq.fsf@bingen.suse.de>
In-Reply-To: <p73odf849rq.fsf@bingen.suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Oct 2007 15:42:06.0324 (UTC) FILETIME=[F2144B40:01C80A8A]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09 2007 at 16:56 +0200, Andi Kleen <andi@firstfloor.org> wrote:
> Michael Stiller <ms@2scale.net> writes:
>> The write(2) performance is not good enough, the writer threads take to
>> much time, and i ask you for ideas, howto to boost the write
>> performance. 
> 
> You could use an O_DIRECT write if the data is suitably aligned
> and your IO sizes are big enough (O_DIRECT is usually a loss
> on small IOs). It will also be synchronous, but if you do it 
> from a separate thread anyways that should be fine.
> 
> -Andi

If your target is a SCSI target you can gain up to 15% by using
sg. Search on the net for the "sg utils" package. The source code
of sg_dd and others are a grate example of how to do it.

Other wise O_DIRECT is your friend. Also look for asynchronous
I/O so you have a few pending IO buffers to keep the pipes full.

Boaz

