Return-Path: <linux-kernel-owner+w=401wt.eu-S1758396AbYE0SdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758396AbYE0SdX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 14:33:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756045AbYE0SdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 14:33:10 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:48291 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756139AbYE0SdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 14:33:09 -0400
Message-ID: <483C5414.6050308@freescale.com>
Date: Tue, 27 May 2008 13:33:56 -0500
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: Trent Piepho <tpiepho@freescale.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>, linux-arch@vger.kernel.org,
       linuxppc-dev@ozlabs.org, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: MMIO and gcc re-ordering issue
References: <1211852026.3286.36.camel@pasglop>  <20080526.184047.88207142.davem@davemloft.net>  <1211854540.3286.42.camel@pasglop>  <20080526.192812.184590464.davem@davemloft.net> <1211859542.3286.46.camel@pasglop> <alpine.LFD.1.10.0805270833060.2958@woody.linux-foundation.org> <Pine.LNX.4.64.0805271043150.7453@t2.domain.actdsltmp>
In-Reply-To: <Pine.LNX.4.64.0805271043150.7453@t2.domain.actdsltmp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trent Piepho wrote:
> Is there an issue with anything _besides_ coherent DMA?
> 
> Could one have a special version of the accessors for drivers that
> want to assume they are strictly ordered vs coherent DMA memory?
> That would be much easier to get right, without slowing _everything_
> down.

It's better to be safe by default and then optimize the fast paths than 
to be relaxed by default and hang the machine in some piece of code that 
runs once a month.  "Premature optimization is the root of all evil", 
and what not.

> One could even go as far as to allow a driver to "#define 
> WANT_STRICT_IO" and then it would get the strict versions.  Add that
> to any driver that uses DMA and then worry about vetting those
> drivers.

See above -- if you must have a #define, then it should be WANT_RELAXED_IO.

-Scott

