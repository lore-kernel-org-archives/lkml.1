Return-Path: <linux-kernel-owner+w=401wt.eu-S1760063AbYBZCmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760063AbYBZCmQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 21:42:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758252AbYBZCmD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 21:42:03 -0500
Received: from c60.cesmail.net ([216.154.195.49]:56674 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757122AbYBZCmB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 21:42:01 -0500
Message-ID: <20080225214200.yge03wi7ksoccw0k@webmail.spamcop.net>
Date: Mon, 25 Feb 2008 21:42:00 -0500
From: Pavel Roskin <proski@gnu.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Pekka Paalanen <pq@iki.fi>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: [RFC] mmiotrace full patch, preview 1
References: <20080224190323.77adf683@daedalus.pq.iki.fi>
	<20080225144922.ae716e7d.akpm@linux-foundation.org>
	<20080225233449.GA25448@infradead.org>
In-Reply-To: <20080225233449.GA25448@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	DelSp=Yes	format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 7BIT
User-Agent: Internet Messaging Program (IMP) H3 (4.1.4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Christoph Hellwig <hch@infradead.org>:

> On Mon, Feb 25, 2008 at 02:49:22PM -0800, Andrew Morton wrote:
>> the things which it finds.
>>
>> > +static DECLARE_MUTEX(kmmio_init_mutex);
>>
>> That's not a mutex.
>>
>> > +	down(&kmmio_init_mutex);
>>
>> It's a semaphore.  Please do convert it to a mutex.
>>
>> Andy, I'd say that addition of new semaphores is worth a warning - they're
>> rarely legitimate.
>
> I'm not sure that any semaphore should be a warning, but the initializer
> for semaphore used as binary mutex (DECLARE_MUTEX and init_MUTEX) are
> worth it.

It looks like a mutex, it acts like a mutex, but it isn't a mutex,  
it's a trap for the unwary.  Weird.  I was annoyed by it before; now I  
see a fellow developer actually getting into that trap.

I'd say, rename DECLARE_MUTEX to DECLARE_SEMAPHORE and let external  
code be fixed one way or another (i.e. stick with the "mutex" name or  
stick with the semaphore functionality if it's really needed).

-- 
Regards,
Pavel Roskin
