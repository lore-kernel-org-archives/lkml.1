Return-Path: <linux-kernel-owner+w=401wt.eu-S1756014AbZCTVcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014AbZCTVcT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 17:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751703AbZCTVcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 17:32:08 -0400
Received: from brinza.cc.columbia.edu ([128.59.29.8]:34090 "EHLO
	brinza.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060AbZCTVcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 17:32:07 -0400
Message-ID: <49C40AEE.6040309@cs.columbia.edu>
Date: Fri, 20 Mar 2009 17:30:22 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: Christoph Hellwig <hch@infradead.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       containers <containers@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 5/8] add f_op for checkpointability
References: <20090227203425.F3B51176@kernel>	<20090227203431.D1E697CB@kernel> <20090228205329.GB4254@infradead.org>	<1236013556.26788.466.camel@nimitz>	<20090303131528.GB10931@infradead.org> <1237583604.8286.294.camel@nimitz>
In-Reply-To: <1237583604.8286.294.camel@nimitz>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Dave Hansen wrote:
> On Tue, 2009-03-03 at 08:15 -0500, Christoph Hellwig wrote:
>> On Mon, Mar 02, 2009 at 09:05:56AM -0800, Dave Hansen wrote:
>>> On Sat, 2009-02-28 at 15:53 -0500, Christoph Hellwig wrote:
>>>> Also the double-use of the op seem not very nice to me.  Is there any
>>>> real life use case were you would have the operation on a file but
>>>> sometimes not allow checkpoiting?
>>> I'm still reaching here...
>>>
>>> I was thinking of /proc.  Opening your own /proc/$$/* would certainly be
>>> considered OK.  But, doing it for some other process not in your pid
>>> namespace would not be OK and would not be checkpointable.
>>>
>>> I know we're not quite in real-life territory here, yet, but I'm still
>>> thinking.
>> That mighr be a good enough excuse, I was just wondering what the use
>> case was.
> 
> I just thought of another one: unlinked files and directories.  They're
> a pain to checkpoint and won't be supported for a while.  Holding open
> an unlinked file would make a process uncheckpointable for a bit.

Actually, unlinked directories are the easiest to restore: you recreate it,
open it, and then immediately delete them. This works, because an unlinked
directory does not hold any data except for its existence.

For unlinked files, in physical file systems (non pseudo), for many apps
they are small in size, so a first approximation would be to save the
contents of that file with the checkpoint image, and on restart recreate
the file, put the contents, open it, and then unlink it again.

Oren.

> 
> -- Dave
> 
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/containers
> 
