Return-Path: <linux-kernel-owner+w=401wt.eu-S1753809Ab0ADS5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809Ab0ADS5Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 13:57:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753528Ab0ADS5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 13:57:22 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:39395 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411Ab0ADS5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 13:57:21 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; CHARSET=US-ASCII; delsp=yes; format=flowed
Date: Mon, 04 Jan 2010 11:57:16 -0700
From: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFC][PATCH v3] readahead: introduce O_RANDOM for POSIX_FADV_RANDOM
In-reply-to: <20100104165044.GD25663@yahoo-inc.com>
To: Quentin Barnes <qbarnes@yahoo-inc.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Wu Fengguang <fengguang.wu@intel.com>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>, Steven Whitehouse <swhiteho@redhat.com>,
       David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Jonathan Corbet <corbet@lwn.net>
Message-id: <DA85D310-01F9-4043-88C4-4C6EAEE3A62C@sun.com>
X-Mailer: Apple Mail (2.936)
References: <20091225000717.GA26949@yahoo-inc.com>
 <87aax18xms.fsf@basil.nowhere.org> <20091230051540.GA16308@localhost>
 <20091230052402.GB26364@localhost> <873a2s8hmp.fsf@basil.nowhere.org>
 <20100104045020.GA21021@localhost>
 <20100104161719.a0bb35ad.sfr@canb.auug.org.au>
 <20100104073328.GA3422@infradead.org> <20100104165044.GD25663@yahoo-inc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-01-04, at 09:50, Quentin Barnes wrote:
> On Sun, Jan 03, 2010 at 11:33:28PM -0800, Christoph Hellwig wrote:
>> On Mon, Jan 04, 2010 at 04:17:19PM +1100, Stephen Rothwell wrote:
>>>> @@ -80,6 +80,10 @@
>>>> #define O_NDELAY	O_NONBLOCK
>>>> #endif
>>>>
>>>> +#ifndef O_RANDOM
>>>> +#define O_RANDOM	010000000	/* random access pattern hint */
>>>> +#endif
>>>
>>> This value conflicts with O_CLOEXEC on alpha and parisc and  
>>> O_NOATIME on
>>> sparc.
>>
>> Also when I tried to use this value for O_RSYNC and tested it I could
>> not actually see it getting propagated by the open code.
>>
>> Eitherway I don't think an O_ value is a good idea for a simple  
>> access
>> pattern hint.
>
> I was surprised by Wu's O_RANDOM approach, but after thinking about
> it, I liked it.  I'm used to seeing (on non-UNIX OSes) a parameter
> as part of the open syscall that announces to the OS what the app's
> access strategy through that file descriptor will be for that file.
> An issue with the current fadvise(2) approach is for random access
> files it necessitates two syscalls (open plus fadvise) for what
> could be or should be only one syscall (open).


Given that syscall overhead is very minimal, especially since fadvise  
is only setting some in-memory state and doesn't have to flush cache  
or anything, I don't see that as a significant reason to consume an O_  
flag.  Those flags are essentially limited to 32-bit values, or 32-bit  
applications wouldn't be able to use all of the flags, and we are  
already into the mid-20's of bits.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

