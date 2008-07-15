Return-Path: <linux-kernel-owner+w=401wt.eu-S1761392AbYGODE6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761392AbYGODE6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 23:04:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755620AbYGODEl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 23:04:41 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:45948 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755597AbYGODEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 23:04:40 -0400
Message-ID: <487C142E.8000207@keyaccess.nl>
Date: Tue, 15 Jul 2008 05:06:22 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: David Miller <davem@davemloft.net>, david@lang.hm, arjan@infradead.org,
       akpm@linux-foundation.org, dwmw2@infradead.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel,
 use it in more drivers.
References: <alpine.DEB.1.10.0807141750290.14223@asgard.lang.hm> <20080714.185207.203328391.davem@davemloft.net> <487C0A12.9060906@keyaccess.nl> <20080714.192425.241878700.davem@davemloft.net> <alpine.LFD.1.10.0807141934060.3017@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0807141934060.3017@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: 1.0 (+)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15-07-08 04:39, Linus Torvalds wrote:

> On Mon, 14 Jul 2008, David Miller wrote:
>> They states that it was being done on a technical basis rather
>> than being predominantly a legal one.
> 
> No.
> 
> Yes, the original reason for request_firmware() was obviously very much 
> partly legal.
> 
> HOWEVER.
> 
> Once you have a model that is required (for whatever reasons) for some 
> drivers, we're much better off using the _same_ model for all drivers, 
> whether it is necessary for legal reasons for those other drivers.
> 
> Put this way: if you do a distro, you _need_ to support firmware loading 
> anyway. And once you do that, it's just annoying how some drivers then do 
> something odd and special for the same thing, for no real good reason.

There's little alternative infrastructure in declaring a static array of 
unsigned char though.

Yes, it still makes sense to make everyone use request_firmware() if 
only because these other drivers now all of a sudden have a more 
accessible way of updating their firmwares, but David's objective is 
legal here.

Which is fine.

But the very clear _technical_ objection about this not providing for 
keeping modules and their firmware together for those that really do 
want it to be that way was not at all addressed. Note, this while still 
using request_firmware(), just at the option of the kernel builder with 
the firmware compiled into the module. Right now, this allows the 
firmware to be compiled into the vmlinux only which makes fairly little 
sense if the driver itself is a module.

Rene.
