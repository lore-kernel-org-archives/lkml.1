Return-Path: <linux-kernel-owner+w=401wt.eu-S933483AbYD1L2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933483AbYD1L2z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 07:28:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763049AbYD1L2r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 07:28:47 -0400
Received: from smtp.nokia.com ([192.100.122.230]:27882 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763195AbYD1L2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 07:28:46 -0400
Message-ID: <4815B3AE.5010500@nokia.com>
Date: Mon, 28 Apr 2008 14:23:26 +0300
From: Adrian Hunter <ext-adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: ext ext Christoph Hellwig <hch@infradead.org>
CC: Artem Bityutskiy <dedekind@yandex.ru>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 26/26] UBIFS: include FS to compilation
References: <1206629746-4298-1-git-send-email-Artem.Bityutskiy@nokia.com> <1206629746-4298-27-git-send-email-Artem.Bityutskiy@nokia.com> <84144f020804010039n47133bd3l63f02258a2670e72@mail.gmail.com> <47F1F7A6.5020105@yandex.ru> <20080426093553.GA17730@infradead.org> <48157812.5090909@nokia.com> <20080428090032.GA14100@infradead.org>
In-Reply-To: <20080428090032.GA14100@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Apr 2008 11:28:21.0570 (UTC) FILETIME=[F6DCB220:01C8A922]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
>Artem Bityutskiy wrote:
>>Pekka Enberg wrote:
>>>>Artem Bityutskiy wrote:
>>>>  +config UBIFS_FS_DEBUG_MSG_GEN
>>>>  +
>>>>  +config UBIFS_FS_DEBUG_MSG_JRN
>>>>  +
>>>>  +config UBIFS_FS_DEBUG_MSG_CMT
>>>>  +
>>>>  +config UBIFS_FS_DEBUG_MSG_BUDG
>>>>  +
>>>>  +config UBIFS_FS_DEBUG_MSG_LOG
>>>>  +
>>>>  +config UBIFS_FS_DEBUG_MSG_TNC
>>>>  +
>>>>  +config UBIFS_FS_DEBUG_MSG_LP
>>>>  +
>>>>  +config UBIFS_FS_DEBUG_MSG_FIND
>>>>  +
>>>>  +config UBIFS_FS_DEBUG_MSG_MNT
>>>>  +
>>>>  +config UBIFS_FS_DEBUG_MSG_IO
>>>>  +
>>>>  +config UBIFS_FS_DEBUG_MSG_GC
>>>>  +
>>>>  +config UBIFS_FS_DEBUG_MSG_SCAN
>>>
>>> But these don't make much sense to me. Why would you want to be able
>>> to compile out printks at this granularity? Why not enable all of them
>>> when CONFIG_UBIFS_FS_DEBUG is enabled? 
>>
>>Well, its just more convenient for us. If I know the bug is somewhere in
>>the journal, I enable the journal messages - less flooding. We may
>>lessen the amount, but it is still handy to have some classes of
>>prints separate.
>>
>>We will think how to lessen the amount and granularity of this. 
>>
> On Mon, Apr 28, 2008 at 10:09:06AM +0300, Adrian Hunter wrote:
>>Christoph Hellwig wrote:
>>> It's everything but convenient :)  Please make it one config option to
>>> compile in all debug code and then have a module option to select the
>>> verbosity level at runtime.
>> Surely that judgement should be made by people who actually debug UBIFS.
> 
> I've debugged enough code including filesystems far more complex than
> ubifs so you can happily trust my judgement.  Even if not you can simply
> switch on your brain and notice that a runtime/boottime switch is always
> more convenient than a compile-time switch, and the only reason against
> it would be a performance penalty.

You have gone off on a tangent.  The original context was discussing the
need for granulated debug messages.  I have restored the context above.

Addressing the original discussion, the convenience is best expressed by
example.  Say you want to try improving the garbage collector.  It is
convenient to be able to get messages just about the garbage collector.
Say you want to add index node merging to the TNC, it is convenient to
get messages just about the TNC.  And so on.  Hence my original point
stands:  the convenience is evident to someone working with the code, but
not to someone who isn't.

Note also, that switching on all the debug messages is not exactly
inconvenient.  After all, you just select all the config options.

You seem to have mistakenly inferred I was impugning your judgement.  That
was not the point.

Coming back to your issue of a mount-time option for debug messages.  I am
not sure any other file systems do that.  In general I would say having to
switch on the debug config option and also change either the kernel command
line or init scripts, seems in fact much less convenient.

