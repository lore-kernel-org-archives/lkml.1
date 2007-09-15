Return-Path: <linux-kernel-owner+w=401wt.eu-S1752597AbXIOMP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597AbXIOMP0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 08:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751053AbXIOMPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 08:15:12 -0400
Received: from mx1.Informatik.Uni-Tuebingen.De ([134.2.12.5]:37787 "EHLO
	mx1.informatik.uni-tuebingen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750945AbXIOMPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 08:15:10 -0400
From: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joern Engel <joern@logfs.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Christoph Lameter <clameter@sgi.com>, andrea@suse.de,
       torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
       Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
In-Reply-To: <20070915014449.4f9cdb51.akpm@linux-foundation.org> (Andrew
	Morton's message of "Sat, 15 Sep 2007 01:44:49 -0700")
References: <20070911060349.993975297@sgi.com>
	<200709110452.20363.nickpiggin@yahoo.com.au>
	<20070911121225.GE13132@lazybastard.org>
	<20070915014449.4f9cdb51.akpm@linux-foundation.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) XEmacs/21.4.19 (linux)
Date: Sat, 15 Sep 2007 14:14:42 +0200
Message-ID: <87ir6c3z2l.fsf@informatik.uni-tuebingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Tue, 11 Sep 2007 14:12:26 +0200 Jörn Engel <joern@logfs.org> wrote:
>
>> While I agree with your concern, those numbers are quite silly.  The
>> chances of 99.8% of pages being free and the remaining 0.2% being
>> perfectly spread across all 2MB large_pages are lower than those of SHA1
>> creating a collision.
>
> Actually it'd be pretty easy to craft an application which allocates seven
> pages for pagecache, then one for <something>, then seven for pagecache, then
> one for <something>, etc.
>
> I've had test apps which do that sort of thing accidentally.  The result
> wasn't pretty.

Except that the applications 7 pages are movable and the <something>
would have to be unmovable. And then they should not share the same
memory region. At least they should never be allowed to interleave in
such a pattern on a larger scale.

The only way a fragmentation catastroph can be (proovable) avoided is
by having so few unmovable objects that size + max waste << ram
size. The smaller the better. Allowing movable and unmovable objects
to mix means that max waste goes way up. In your example waste would
be 7*size. With 2MB uper order limit it would be 511*size.

I keep coming back to the fact that movable objects should be moved
out of the way for unmovable ones. Anything else just allows
fragmentation to build up.

MfG
        Goswin
