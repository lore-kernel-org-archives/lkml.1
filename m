Return-Path: <linux-kernel-owner+w=401wt.eu-S1754239AbZAJVP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239AbZAJVP1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 16:15:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752681AbZAJVPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 16:15:13 -0500
Received: from mx2.redhat.com ([66.187.237.31]:39781 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778AbZAJVPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 16:15:12 -0500
Message-ID: <49690FC9.4010403@redhat.com>
Date: Sat, 10 Jan 2009 16:14:49 -0500
From: Casey Dahlin <cdahlin@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Scott James Remnant <scott@canonical.com>
CC: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Roland McGrath <roland@redhat.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RESEND][RFC PATCH v2] waitfd
References: <49639EB8.40204@redhat.com> <4963ABF0.6070400@redhat.com>	 <20090107123457.GB16268@elte.hu>  <20090107171922.GA18000@redhat.com> <1231598863.11642.55.camel@quest>
In-Reply-To: <1231598863.11642.55.camel@quest>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Scott James Remnant wrote:
> On Wed, 2009-01-07 at 18:19 +0100, Oleg Nesterov wrote:
>
>   
>> Please note that unlike other sys_...fd() syscalls, sys_waitfd()
>> doesn't allow to pass O_CLOEXEC. Looks like we need a separate
>> "flags" argument...
>>
>> Also, ioctl(FIONBIO) or fcntl(O_NONBLOCK) have no effect on
>> waitfd, not very good.
>>
>> I'd suggest to remove WNOHANG from waitfd_ctx->ops and treat
>> (->f_flags & O_NONBLOCK) as WNOHANG.
>>
>> (can't resist, ->ops is not the best name ;)
>>
>>     
> Definitely agree here, waitfd() doesn't need WNOHANG - we already have
> ONONBLOCK.
>
> That also solves one of the strangest behaves of waitid when you use
> WNOHANG (it returns zero and you have to check whether it changed the
> struct), now you just read() - if no child you get EAGAIN, if a child
> you read a struct.
>
> Scott
>   
 From the perspective of waitfd, the only difference between WNOHANG and
O_NONBLOCK is which argument you put the flags in. The API should only
support one or the other, but internally they would imply the same thing.

--CJD

