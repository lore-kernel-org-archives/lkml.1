Return-Path: <linux-kernel-owner+w=401wt.eu-S1755806AbZAJWdy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755806AbZAJWdy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 17:33:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753695AbZAJWdq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 17:33:46 -0500
Received: from mx2.redhat.com ([66.187.237.31]:42083 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752943AbZAJWdp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 17:33:45 -0500
Date: Sat, 10 Jan 2009 23:31:30 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Casey Dahlin <cdahlin@redhat.com>
Cc: Scott James Remnant <scott@canonical.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Roland McGrath <roland@redhat.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RESEND][RFC PATCH v2] waitfd
Message-ID: <20090110223130.GA28581@redhat.com>
References: <49639EB8.40204@redhat.com> <4963ABF0.6070400@redhat.com> <20090107123457.GB16268@elte.hu> <20090107171922.GA18000@redhat.com> <1231598863.11642.55.camel@quest> <49690FC9.4010403@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49690FC9.4010403@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10, Casey Dahlin wrote:
>
> Scott James Remnant wrote:
>> On Wed, 2009-01-07 at 18:19 +0100, Oleg Nesterov wrote:
>>
>>> Please note that unlike other sys_...fd() syscalls, sys_waitfd()
>>> doesn't allow to pass O_CLOEXEC. Looks like we need a separate
>>> "flags" argument...
>>>
>>> Also, ioctl(FIONBIO) or fcntl(O_NONBLOCK) have no effect on
>>> waitfd, not very good.
>>>
>>> I'd suggest to remove WNOHANG from waitfd_ctx->ops and treat
>>> (->f_flags & O_NONBLOCK) as WNOHANG.
>>>
>>> (can't resist, ->ops is not the best name ;)
>>>
>>>
>> Definitely agree here, waitfd() doesn't need WNOHANG - we already have
>> ONONBLOCK.
>>
>> That also solves one of the strangest behaves of waitid when you use
>> WNOHANG (it returns zero and you have to check whether it changed the
>> struct), now you just read() - if no child you get EAGAIN, if a child
>> you read a struct.
>>
> From the perspective of waitfd, the only difference between WNOHANG and
> O_NONBLOCK is which argument you put the flags in.

No. Please see the note about ioctl/fcntl above.

Oleg.

