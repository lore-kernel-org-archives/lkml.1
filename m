Return-Path: <linux-kernel-owner+w=401wt.eu-S1761518AbZC0UY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761518AbZC0UY0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 16:24:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754624AbZC0UYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 16:24:14 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:59598 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754555AbZC0UYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 16:24:14 -0400
Date: Fri, 27 Mar 2009 21:26:14 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: liqin.chen@sunplusct.com, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH 5/13] score - New architecure port to SunplusCT S+CORE processor
Message-ID: <20090327202614.GA22054@uranus.ravnborg.org>
References: <OFE9A5E3A2.37B73BA8-ON48257586.0008CFAC-48257586.00091B05@sunplusct.com> <20090327184013.GB21149@uranus.ravnborg.org> <200903272019.53689.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200903272019.53689.arnd@arndb.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 27, 2009 at 08:19:53PM +0100, Arnd Bergmann wrote:
> On Friday 27 March 2009, Sam Ravnborg wrote:
> > > +struct shmid64_ds {
> > > +       struct ipc64_perm       shm_perm;       /* operation perms */
> > > +       size_t                  shm_segsz;      /* size of segment (bytes) 
> > > */
> > > +       __kernel_time_t         shm_atime;      /* last attach time */
> > > +       __kernel_time_t         shm_dtime;      /* last detach time */
> > > +       __kernel_time_t         shm_ctime;      /* last change time */
> > > +       __kernel_pid_t          shm_cpid;       /* pid of creator */
> > > +       __kernel_pid_t          shm_lpid;       /* pid of last operator */
> > > +       unsigned long           shm_nattch;     /* no. of current attaches 
> > > */
> > > +       unsigned long           __unused1;
> > > +       unsigned long           __unused2;
> > > +};
> > 
> > This is an exported header and you mix wide specific and generic types.
> > The recommended way is to stick to the __[u]{32,64}int versions + the kernel
> > specific types as __kernel_pid_t.
> > In other words avoid use of int, long etc in your exported headers.
> > 
> 
> This is correct in general, but in this particular case (SysV IPC) it is
> exactly what most of the other architectures do. It's basically impossible
> to get this right, so simply doing the same as x86 is the best option
> I found (unlike most of the other headers).

Thats strange indeed.
This structure will then change layout depending on the target bit-size
of the compiler.

>From x86:
#ifdef __i386__
        unsigned long           __unused1;
#endif
        __kernel_time_t         shm_dtime;      /* last detach time */
#ifdef __i386__
        unsigned long           __unused2;
#endif

long is 64 bit in one case and 32 bit in another case.
I'm confused..

I would expect it to be safer to be bit-size neutral in our
exported headers.
But the score people know there userlend best so let them decide.

Still they should audit all their exported headers.
They cannot assume it was right because they copied them from
somewhere.

	Sam
