Return-Path: <linux-kernel-owner+w=401wt.eu-S1763088AbXHFGir@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763088AbXHFGir (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 02:38:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762510AbXHFGi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 02:38:26 -0400
Received: from mail.gmx.net ([213.165.64.20]:39288 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1762319AbXHFGiZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 02:38:25 -0400
X-Authenticated: #24879014
X-Provags-ID: V01U2FsdGVkX199PspFiv59Bo1y9nu5GH10ZpEbucfgVr0WK+Ts31
	w31uLGoucqmreD
Message-ID: <46B6C17D.4050201@gmx.net>
Date: Mon, 06 Aug 2007 08:36:45 +0200
From: Michael Kerrisk <mtk-manpages@gmx.net>
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Kirill Korotaev <dev@openvz.org>, lkml <linux-kernel@vger.kernel.org>,
       Pavel Emelianov <xemul@openvz.org>, Cedric Le Goater <clg@fr.ibm.com>
Subject: Re: CLONE_NEWIPC documentation
References: <46B599D8.8010003@gmx.net> <m1ejiikw4a.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1ejiikw4a.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Eric W. Biederman wrote:
> Michael Kerrisk <mtk-manpages@gmx.net> writes:
> 
>> Hello Kirill,
>>
>> In 2.6.19, your patch to add support for CLONE_NEWIPC was included.  Is
>> there there some for-userland-programmers documentation of this flag
>> somewhere?  Would you be able to send some documentation to me (ideally as
>> a patch to the clone.2 man page, but otherwise some plain text will do).
>>
>> If this flag is also supported for unshare(), then could you please send me
>> a patch/text for that too?
> 
> In case someone else doesn't do better here is a short summary.

Thanks Eric.  That looks to cover a lot of the essentials.  Anyone else see
something important that should be documented?

And a further question: is CLONE_NEWIPC implemented for unshare()?

Cheers,

Michael


> CLONE_NEWIPC creates a new ipc namespace for the new child and all
> of it's children.  So far CAP_SYS_ADMIN is required.
> 
> An IPC namespace creates a new context for looking up and listing
> SYSV IPC shared memory, message queues, and semaphores.  Only allowing
> finding of SYSV IPC objects in this namespace.
> 
> For most practical purposes two processes in different SYSV IPC
> namespaces might as well be on different machines.  As they cannot
> find each others SYSV IPC resources, and so cannot interact with
> each other that way.
> 
> The implementation is essentially just a lookup of the objects
> in a different table when doing name to object translation so
> there should be no measurable overhead.
> 
> When the last process in a SYSV IPC namespace exits any remaining
> objects in that SYSV IPC namespace are destroyed.
> 
> Eric
> 

-- 
Michael Kerrisk
maintainer of Linux man pages Sections 2, 3, 4, 5, and 7

Want to help with man page maintenance?  Grab the latest tarball at
http://www.kernel.org/pub/linux/docs/manpages/
read the HOWTOHELP file and grep the source files for 'FIXME'.
