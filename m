Return-Path: <linux-kernel-owner+w=401wt.eu-S1754029AbZIISzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029AbZIISzU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 14:55:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752931AbZIISzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 14:55:20 -0400
Received: from zcars04e.nortel.com ([47.129.242.56]:63313 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721AbZIISzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 14:55:19 -0400
Message-ID: <4AA7F9E5.4070506@nortel.com>
Date: Wed, 09 Sep 2009 12:54:29 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Daniel Walker <dwalker@fifo99.com>
CC: Jack Steiner <steiner@sgi.com>, mingo@elte.hu, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: SGU UV Add volatile to macros that access chipset
 registers
References: <20090909154246.GA26716@sgi.com>	 <1252512600.14793.125.camel@desktop>  <20090909180110.GA10311@sgi.com> <1252519885.14793.135.camel@desktop>
In-Reply-To: <1252519885.14793.135.camel@desktop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Sep 2009 18:55:17.0166 (UTC) FILETIME=[12552CE0:01CA317F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2009 12:11 PM, Daniel Walker wrote:
> On Wed, 2009-09-09 at 13:01 -0500, Jack Steiner wrote:
>> Volatile is being added to the accessor functions that are used to
>> read/write memory-mapped I/O registers located within the UV chipset.
>> The use of volatile is hidden within the functions and is not exposed
>> to the users of the functions.
>>
>> Note that the use is limited to the accessor functions in the header
>> file. No .c files are changed or need to know about volatile.
>>
>>
>> This seems to be consistent with other uses of volatile within the kernel.
> 
> The document that I cited specifically addresses memory accessors as not
> needing the volatile keyword .. So your still not addressing exactly why
> your code needs it .. Are your accessors special in some way? Is there
> some defect your seeing without the volatile keyword?


>From that document:

"There are still a few rare situations where volatile makes sense in the
kernel:

  - The above-mentioned accessor functions might use volatile on
    architectures where direct I/O memory access does work.
    Essentially, each accessor call becomes a little critical section
    on its own and ensures that the access happens as expected by the
    programmer."


However, the fact that these functions are returning volatile pointers
is a bit sketchy.  Normally accesses to such memory would be wrapped
entirely in a read/write function which would handle the volatility
internally to the function.

In this case there's no point in the function returning a "volatile
unsigned long *" if it's going to be cast to a volatile pointer before
being dereferenced.

Chris
