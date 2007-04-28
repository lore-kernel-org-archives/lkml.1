Return-Path: <linux-kernel-owner+w=401wt.eu-S1161824AbXD1PlI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161824AbXD1PlI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 11:41:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161855AbXD1PlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 11:41:08 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:59278 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161824AbXD1PlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 11:41:06 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
References: <20070424222105.883597089@sgi.com>
	<m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com>
	<Pine.LNX.4.64.0704252154250.29271@schroedinger.engr.sgi.com>
	<m1abwvofke.fsf@ebiederm.dsl.xmission.com>
	<4633283C.2000301@drzeus.cx>
Date: Sat, 28 Apr 2007 09:39:48 -0600
In-Reply-To: <4633283C.2000301@drzeus.cx> (Pierre Ossman's message of "Sat, 28
	Apr 2007 12:55:56 +0200")
Message-ID: <m17irwfqyj.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman <drzeus-list@drzeus.cx> writes:

> Eric W. Biederman wrote:
>> 
>> I have a hard time believe that device hardware limits don't allow them
>> to have enough space to handle larger requests.  If so it was a poor
>> design by the hardware manufacturers.
>> 
>
> In the MMC layer, the block size is a major bottle neck. None of the currently
> supported hardware supports scatter/gather so we're restricted to servicing a
> single continuous chunk of memory at a time. And since latency is substantial
> for MMC/SD, good performance is several orders above 4k. We get ~8 MB/s for
> cards which are supposed to do 20 MB/s (which has been tested against other
> systems where we can get larger memory chunks), and the peasants are getting a
> bit unruly.
>
> I plan to experiment with some bounce buffer scheme to get performance up, but
> getting large blocks directly would make such hacks unnecessary.

My problem with the proposed scheme is not that it uses large pages,
but rather that it requires large pages.  So in the mmc case you would
go from getting 20MB/s soon after the system booted to failing to be
able to do I/O at all a couple of days later when memory gets
fragmented.

I think a reliable 8MB/s is much better than an unreliable 20MB/s.

With your bounce buffer scheme it seems probable that we can even
get a reliable 20MB/s.

So I'm interested to hear that we have several in tree users that
could benefit.

I do think large block support if we don't require large pages makes
sense.

Eric
