Return-Path: <linux-kernel-owner+w=401wt.eu-S1758560AbZCWR6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758560AbZCWR6i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 13:58:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757266AbZCWR62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 13:58:28 -0400
Received: from tomts36-srv.bellnexxia.net ([209.226.175.93]:57216 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755678AbZCWR61 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 13:58:27 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEADNkx0lMQW1W/2dsb2JhbACBUNFWg34G
Date: Mon, 23 Mar 2009 13:58:20 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Masahiro Tamori <masahiro.tamori@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, ltt-dev <ltt-dev@lists.casi.polymtl.ca>,
       linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       linux-nfs@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [Patch] ltt-relay-alloc mmap support (due to NFS lack of
	splice support)
Message-ID: <20090323175820.GH24084@Krystal>
References: <91e0b5050903170224k51c4895eq8a1491da7a7a9741@mail.gmail.com> <20090320152857.GB30019@Krystal> <91e0b5050903230534g57d1ef8byd14a1fb5ca807192@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <91e0b5050903230534g57d1ef8byd14a1fb5ca807192@mail.gmail.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 13:54:11 up 23 days, 14:20,  1 user,  load average: 1.08, 0.65,
	0.62
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Masahiro Tamori (masahiro.tamori@gmail.com) wrote:
> 2009/3/21 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>:
> > * Masahiro Tamori (masahiro.tamori@gmail.com) wrote:
[...]
> >> Our customer will use NFS to store trace data not storage device for
> >> embedded devices.
> >> Since newer lttng use splice() even if NFS can not support splice(),
> >> I create a patch to support to mmap of ltt-relay-alloc.
> >>
[...]
> >> ltt-relay-alloc mmap support
> >>
> >> Splice syscall does not support NFS. We can not save trace data to
> >> NFS directory. If this feature is enabled, you can use mmap()
> >> instead of splice().
> >>
> >
> >
> > Hi Masahiro,
> >
> > Maybe we should consider implementing splice() support in NFS instead ?
> >
> > I removed the mmap support from the ltt-relay-alloc files because splice
> > is more efficient and does not require to vmap the pages.  Unless there
> > is a strong argument telling what in NFS makes it impossible to
> > implement splice(), I don't really see the gain in putting back the
> > old mmap() mechanism we had.
> >
> > Maybe the NFS people will have some information about this ?
> >
> > Thanks,
> >
> > Mathieu
> >
> 
> Hello Mathieu,
> 
> I think that the best solution is NFS can support splice() even if
> it cannot zero copy.
> 
> The splice() will be used by any other tools, hence NFS should support
> it sooner or later.
> 
> If technical issue is remained to support splice() in NFS,
> we should support mmap in LTTng until the problem is resolved.
> Embedded people will want to use LTTng with NFS,
> though this is a bad choice.
> 
> Thank you,
> Masahiro Tamori
> 

There was a LKML thread on NFS splice support back in 2006 :

http://lkml.indiana.edu/hypermail/linux/kernel/0603.3/2102.html

I don't know what happened with this ? I have tested NFS v2 and v3 and
have seen they do not support splice, but haven't tested NFSv4.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
