Return-Path: <linux-kernel-owner+w=401wt.eu-S1760916AbYHIBTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760916AbYHIBTh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 21:19:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755937AbYHIBTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 21:19:16 -0400
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:39118 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753695AbYHIBTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 21:19:14 -0400
Date: Fri, 8 Aug 2008 21:19:05 -0400
From: Theodore Tso <tytso@mit.edu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <peterz@infradead.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: Btrfs v0.16 released
Message-ID: <20080809011905.GB9967@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Andi Kleen <andi@firstfloor.org>,
	Chris Mason <chris.mason@oracle.com>,
	Peter Zijlstra <peterz@infradead.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
References: <1217962876.15342.33.camel@think.oraclecorp.com> <1218100464.8625.9.camel@twins> <1218105597.15342.189.camel@think.oraclecorp.com> <877ias66v4.fsf@basil.nowhere.org> <1218221293.15342.263.camel@think.oraclecorp.com> <20080808215625.GC9038@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080808215625.GC9038@one.firstfloor.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2008 at 11:56:25PM +0200, Andi Kleen wrote:
> > So, the mirroring turns a single large write into two large writes.
> > Definitely not free, but always a fixed cost.
> 
> Thanks for the explanation and the numbers. I see that's the advantage of 
> copy-on-write that you can actually always cluster the metadata together and 
> get always batched IO this way and then afford to do more of it. 
> 
> Still wondering what that will do to read seekiness.

In theory, if the elevator was smart enough, it could actually help
read seekiness; there are two copies of the metadata, and it shouldn't
matter which one is fetched.  So I could imagine a (hypothetical) read
request which says, "please give me the contents of block 4500 or
75000000 --- I don't care which, if the disk head is closer to one end
of the disk or another, use whichever one is most convenient".  Our
elevator algorithms are currently totally unable to deal with this
sort of request, and if SSD's are going to be coming on line as
quickly as some people are claiming, maybe it's not worth it to try to
implement that kind of thing, but at least in theory it's something
that could be done....

						- Ted
