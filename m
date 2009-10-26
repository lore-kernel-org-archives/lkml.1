Return-Path: <linux-kernel-owner+w=401wt.eu-S1754278AbZJZS5L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754278AbZJZS5L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 14:57:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753483AbZJZS5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 14:57:10 -0400
Received: from zrtps0kp.nortel.com ([47.140.192.56]:50828 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383AbZJZS5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 14:57:09 -0400
Message-ID: <4AE5F04E.3050908@nortel.com>
Date: Mon, 26 Oct 2009 12:54:06 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: "Leonidas ." <leonidas137@gmail.com>
CC: Noah Watkins <noah@noahdesu.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Difference between atomic operations and memory barriers
References: <f22d86810910261019yc77dbf0sa7688a98e7b98267@mail.gmail.com>	 <7ADB5FD7-9C97-4987-BC20-997258B25FD2@noahdesu.com> <f22d86810910261122j6c9e57e8pd4a257090f65c727@mail.gmail.com>
In-Reply-To: <f22d86810910261122j6c9e57e8pd4a257090f65c727@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Oct 2009 18:57:06.0064 (UTC) FILETIME=[1CA7F100:01CA566E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/2009 12:22 PM, Leonidas . wrote:
> On Mon, Oct 26, 2009 at 11:49 PM, Noah Watkins <noah@noahdesu.com> wrote:
>>> Trying to understand difference between atomic ops and memory barriers.
>>>
>> There is a bit of info in:
>>    Documentation/atomic_ops.txt

> Thanks for the pointer, there are no atomic operations for pointers, right?
> I guess barrier is what we need in that case.

You need barriers for the atomics too, at least in some cases.  From
that document:

*** WARNING: atomic_read() and atomic_set() DO NOT IMPLY BARRIERS! ***


For simple assignments, I'm fairly sure linux assumes that writes to
individual variables are atomic.  ie, if you're assigning to an int you
won't get half of the assignment completed while the other half isn't.

What the atomic ops buy you is the ability to do increment-and-test,
compare-and-exchange, etc. in an atomic fashion.

Barriers are needed to make sure that operations are visible on other
cpus in the correct order, and to ensure that the compiler doesn't
reorder the operations.

If you use the normal locking mechanisms (mutexes, spinlocks, etc.) the
barriers are implicit in the lock.

Chris
