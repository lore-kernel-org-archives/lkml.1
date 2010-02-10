Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316Ab0BJJkm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 04:40:42 -0500
Received: from mail.up.ac.za ([137.215.6.44]:58079 "EHLO mail.up.ac.za"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753562Ab0BJJkk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 04:40:40 -0500
X-Greylist: delayed 2448 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Feb 2010 04:40:40 EST
Message-ID: <4B727535.6060701@up.ac.za>
Date: Wed, 10 Feb 2010 10:58:29 +0200
From: Paul Schutte <paul@up.ac.za>
User-Agent: Icedove 1.5.0.14eol (X11/20090105)
MIME-Version: 1.0
To: Goswin von Brederlow <goswin-v-b@web.de>
CC: Tejun Heo <tj@kernel.org>, fuse-devel@lists.sourceforge.net,
       Lars Wendler <polynomial-c@gentoo.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Miklos Szeredi <mszeredi@suse.cz>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [fuse-devel] [PATCH] FUSE/CUSE: implement direct mmap support
References: <4B70FBE4.7050700@kernel.org> <87k4ulo5w2.fsf@frosties.localdomain>
In-Reply-To: <87k4ulo5w2.fsf@frosties.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

I am just sharing my thoughts on the matter.

Maybe one can implement a separate "fuse sync" ioctl which can then be 
called by a user space program say "fusersync" to sync all the fuse 
filesystems you are allowed to.

I implemented sync to my filesystem by means of an extended attribute.
I now do "setfattr -nsync /mountpoint" to get the syncing done.

This has the drawback that you can not easily put it in a script because 
you need to know the mount point. I know one can write smart scripts to 
figure out the mountpoint, but it would be nice if you can just say 
"fusersync" and all the fuse filesystems that you are allowed to will 
just sync.

One can then maybe rename the system wide sync to say "sync.system" and 
put a script in it's place which calls "fusersync;sync.system"

Hopefully this idea might be useful.

Regards
Paul

Goswin von Brederlow wrote:
> Tejun Heo <tj@kernel.org> writes:
>
>   
>> Implement FUSE direct mmap support.  The server can redirect client
>> mmap requests to any SHMLBA aligned offset in the custom address space
>> attached to the fuse channel.  The address space is managed by the
>> server using mmap/munmap(2).  The SHMLBA alignment requirement is
>> necessary to avoid cache aliasing issues on archs with virtually
>> indexed caches as FUSE direct mmaps are basically shared memory
>> between clients and the server.
>>
>> The direct mmap address space is backed by pinned kernel pages which
>> are allocated on the first fault either from a client or the server.
>> If used carelessly, this can easily waste and drain memory.
>> Currently, a server must have CAP_SYS_ADMIN to manage dmmap regions by
>> mmapping and munmapping the channel fd.
>>     
>
> Does that mean that for example in unionfs-fuse when a user wants to
> mmap a file I can just mmap the actual underlying file from the real
> filesystem and any read/write access would then shortcut fuse and go
> directly to the real file?
>
> MfG
>         Goswin
>
> ------------------------------------------------------------------------------
> SOLARIS 10 is the OS for Data Centers - provides features such as DTrace,
> Predictive Self Healing and Award Winning ZFS. Get Solaris 10 NOW
> http://p.sf.net/sfu/solaris-dev2dev
> _______________________________________________
> fuse-devel mailing list
> fuse-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/fuse-devel
>   
