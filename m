Return-Path: <linux-kernel-owner+w=401wt.eu-S1759896AbYHUVUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759896AbYHUVUj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 17:20:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753561AbYHUVUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 17:20:31 -0400
Received: from mail.lang.hm ([64.81.33.126]:38590 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751923AbYHUVUa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 17:20:30 -0400
Date: Thu, 21 Aug 2008 14:19:11 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: douglas.leeder@sophos.com
cc: Eric Paris <eparis@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>, Adrian Bunk <bunk@kernel.org>,
       Casey Schaufler <casey@schaufler-ca.com>, davecb@sun.com,
       Jan Harkes <jaharkes@cs.cmu.edu>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       malware-list@lists.printk.net, malware-list-bounces@dmesg.printk.net
Subject: Re: [malware-list] scanner interface proposal was: [TALPA]	Intro
 linux interface for access scanning
In-Reply-To: <20080821143525.27F9F37655B@pmx1.sophos.com>
Message-ID: <alpine.DEB.1.10.0808211416440.24459@asgard.lang.hm>
References: <20080821143525.27F9F37655B@pmx1.sophos.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Aug 2008, douglas.leeder@sophos.com wrote:

> Eric Paris wrote on 2008-08-20 16:15:21:
>
>> At the moment I'm leaning towards a separate async notification system
>> for open/mtime change/close which will be a fire and forget notification
>> system with no access control mechanism.
>>
>> A second, although very similar, mechanism will block on read/mmap
>> (although I'm not so sure how to handle O_NONBLOCK without a kernel
>> fastpath/inode marking that actually gets used, this is really a serious
>> design issue with putting this at read/mmap.  I don't think we are ready
>> to give up on O_NONBLOCK for S_ISREG altogether just yet are we?) and
>> provide access control.  I also plan to include open() in the
>> blocking/access control based on a /proc tunable.  If applications can't
>> handle EPERM at read/mmap they can get it at open and suffer the
>> perf/blocking hit needlessly on open/stat sequences.
>
> I think these are excellent ideas.
>
> The kernel really does have to keep some record if it's going to do any
> scanning from read() calls, it can't go to userspace each time to check
> if a file is cached.
> (It might be the single open file descriptor that's marked though)

if you say that the hooks are in the kernel then it does make sense to try 
and have the checking of the cached state done in the kernel.

this will mean that the kernel will have to have some way of knowing which 
programs it should block when the check fails and which ones it should let 
go ahead anyway.

> O_NONBLOCK is then handled nicely, and we can avoid ever blocking that
> client process (which given they're trying non-blocking IO is probably
> a good thing).

I don't see how this follows.

David Lang
