Return-Path: <linux-kernel-owner+w=401wt.eu-S1756637AbZAHPwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637AbZAHPwz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 10:52:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751816AbZAHPws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 10:52:48 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:14117 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751732AbZAHPwr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 10:52:47 -0500
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.29 -mm merge plans
References: <20090105004300.19ed52d1.akpm@linux-foundation.org>
	<20090106225744.GA10553@infradead.org>
	<20090106150855.5f362a2d.akpm@linux-foundation.org>
	<20090106232208.GA25103@infradead.org>
	<20090107021654.GD9448@disturbed>
From: Dmitri Monakhov <dmonakhov@openvz.org>
Date: Thu, 08 Jan 2009 18:50:15 +0300
In-Reply-To: <20090107021654.GD9448@disturbed> (Dave Chinner's message of "Wed\, 7 Jan 2009 13\:16\:54 +1100")
Message-ID: <m363kp6bm0.fsf@openvz.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Chinner <david@fromorbit.com> writes:

> On Tue, Jan 06, 2009 at 06:22:08PM -0500, Christoph Hellwig wrote:
>> On Tue, Jan 06, 2009 at 03:08:55PM -0800, Andrew Morton wrote:
>> > > Btw, this code is still not quite right.  We really need to call
>> > > ->setattr instead of vmtruncate here.  Complex filesystem need
>> > > transaction to properly free blocks, and those transactions are in
>> > > ->setattr not inside vmtruncate where ->truncate doesn't even have
>> > > a chance to get the handle to the transaction passed.
In fact ext3/4 opens transaction inside ->truncate() callback, but
because of function signature we can not properly handle any
errors inside truncate(see akpm's comment inside function)
>> > > 
>> > > As these patches don't make it worse this is not a NACK, but more of
>> > > a heads up.
>> > 
>> > Sure.  Maybe add a FIXME comment for now?
>> 
>> Ok.  I was planning to look into this again, and IIRC Dave already did
>> when he was at SGI, but his proof of concept patches got lost somewhere.
>
> Hmmmm - I think I posted the "it works for XFs but nothing else" POC
> patches to fsdevel when I first found this....
>
> <rummage>
>
> http://marc.info/?l=linux-fsdevel&m=120952722315259&w=2
>
> The thread starts here for those that want the whole story:
>
> http://marc.info/?l=linux-fsdevel&m=120946361527726&w=2
So AFAIU your proposal: for general(DIO_LOCKING) filesystems 
ATTR_NO_LOCK means what i_mutex and i_alloc_sem already held.
 
>
> Cheers,
>
> Dave.
