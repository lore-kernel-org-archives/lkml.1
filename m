Return-Path: <linux-kernel-owner+w=401wt.eu-S1755573AbXIWG4z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573AbXIWG4z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 02:56:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752212AbXIWG4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 02:56:46 -0400
Received: from mx1.Informatik.Uni-Tuebingen.De ([134.2.12.5]:45792 "EHLO
	mx1.informatik.uni-tuebingen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753188AbXIWG4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 02:56:45 -0400
From: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
To: Andrea Arcangeli <andrea@suse.de>
Cc: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>,
       Mel Gorman <mel@skynet.ie>, Andrew Morton <akpm@linux-foundation.org>,
       Joern Engel <joern@logfs.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Christoph Lameter <clameter@sgi.com>, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
References: <20070911060349.993975297@sgi.com>
	<200709110452.20363.nickpiggin@yahoo.com.au>
	<20070911121225.GE13132@lazybastard.org>
	<20070915014449.4f9cdb51.akpm@linux-foundation.org>
	<87ir6c3z2l.fsf@informatik.uni-tuebingen.de>
	<20070915155100.GA21861@v2.random> <20070916181504.GB16406@skynet.ie>
	<20070916185052.GG6708@v2.random>
	<87lkb643ug.fsf@informatik.uni-tuebingen.de>
	<20070918193102.GC7541@v2.random>
Date: Sun, 23 Sep 2007 08:56:39 +0200
In-Reply-To: <20070918193102.GC7541@v2.random> (Andrea Arcangeli's message of
	"Tue, 18 Sep 2007 21:31:02 +0200")
Message-ID: <87d4w97tug.fsf@informatik.uni-tuebingen.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea Arcangeli <andrea@suse.de> writes:

> On Mon, Sep 17, 2007 at 12:56:07AM +0200, Goswin von Brederlow wrote:
>> When has free ever given any usefull "free" number? I can perfectly
>> fine allocate another gigabyte of memory despide free saing 25MB. But
>> that is because I know that the buffer/cached are not locked in.
>
> Well, as you said you know that buffer/cached are not locked in. If
> /proc/meminfo would be rubbish like you seem to imply in the first
> line, why would we ever bother to export that information and even
> waste time writing a binary that parse it for admins?

As a user I know it because I didn't put a kernel source into /tmp. A
programm can't reasonably know that.

>> On the other hand 1GB can instantly vanish when I start a xen domain
>> and anything relying on the free value would loose.
>
> Actually you better check meminfo or free before starting a 1G of Xen!!

Xen has its own memory pool and can quite agressively reclaim memory
from dom0 when needed. I just ment to say that the number in
/proc/meminfo can change in a second so it is not much use knowing
what it said last minute.

>> The only sensible thing for an application concerned with swapping is
>> to whatch the swapping and then reduce itself. Not the amount
>> free. Although I wish there were some kernel interface to get a
>> preasure value of how valuable free pages would be right now. I would
>> like that for fuse so a userspace filesystem can do caching without
>> cripling the kernel.
>
> Repeated drop caches + free can help.

I would kill any programm that does that to find out how much free ram
the system has.

MfG
        Goswin
