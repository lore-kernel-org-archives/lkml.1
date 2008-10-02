Return-Path: <linux-kernel-owner+w=401wt.eu-S1753997AbYJBPV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997AbYJBPV4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 11:21:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752599AbYJBPVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 11:21:49 -0400
Received: from mail-in-16.arcor-online.net ([151.189.21.56]:41878 "EHLO
	mail-in-16.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752414AbYJBPVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 11:21:48 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: [PATCH] Give kjournald a IOPRIO_CLASS_RT io priority
To: Jens Axboe <jens.axboe@oracle.com>, Dave Chinner <david@fromorbit.com>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Reply-To: 7eggert@gmx.de
Date: Thu, 02 Oct 2008 17:32:04 +0200
References: <bimJN-4cO-5@gated-at.bofh.it> <biosl-6bq-9@gated-at.bofh.it> <biqkw-aK-3@gated-at.bofh.it> <birgx-1pQ-9@gated-at.bofh.it> <bisPe-3xx-9@gated-at.bofh.it> <bisYW-3HQ-13@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1KlQ9s-0003Oh-Cz@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <jens.axboe@oracle.com> wrote:
> On Thu, Oct 02 2008, Dave Chinner wrote:
>> On Thu, Oct 02, 2008 at 09:55:11AM +0200, Jens Axboe wrote:

>> > Good point. I think we should mark the IO as sync, and maintain the same
>> > priority level. Any IO that ends up being waited on is sync by
>> > definition, we just need to expand the coverage a bit.
>> 
>> That's what XFS has always done - mark the journal I/O as sync.
>> Still, once you load up the elevator, the sync I/O can still get
>> delayed for hundreds of milliseconds before dispatch, which was
>> why I started looking at boosting the priority of the log I/O.
>> It proved to be much more effective at getting the log I/O
>> dispatched than the existing "mark it sync" technique....
> 
> Sure, just marking it as sync is not a magic bullet. It'll be in the
> first priority for that class, but it'll share bandwidth with other
> processes. So if you have lots of IO going on, it can take hundreds of
> miliseconds before being dispatched.

Sounds like you need a priority class besides sync and async.


