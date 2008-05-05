Return-Path: <linux-kernel-owner+w=401wt.eu-S1760026AbYEEVqy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760026AbYEEVqy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 17:46:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761038AbYEEVql
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 17:46:41 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:55845 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756826AbYEEVqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 17:46:40 -0400
Date: Tue, 6 May 2008 00:45:21 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, sam@ravnborg.org, viro@ftp.linux.org.uk,
       hpa@zytor.com, Andy Whitcroft <apw@shadowen.org>
Subject: Re: [rfc] the kernel workflow & trivial "global -> static" patches
	(was: Re: [2.6 patch] make sched_feat_{names,open} static)
Message-ID: <20080505214521.GE1544@cs181133002.pp.htv.fi>
References: <20080505182942.GA17139@cs181133002.pp.htv.fi> <20080505201906.GA900@elte.hu> <20080505134252.c82a64f6.akpm@linux-foundation.org> <20080505210712.GD1544@cs181133002.pp.htv.fi> <20080505142604.389f05c6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080505142604.389f05c6.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2008 at 02:26:04PM -0700, Andrew Morton wrote:
> On Tue, 6 May 2008 00:07:12 +0300
> Adrian Bunk <bunk@kernel.org> wrote:
> 
> > On Mon, May 05, 2008 at 01:42:52PM -0700, Andrew Morton wrote:
> > > On Mon, 5 May 2008 22:19:06 +0200
> > > Ingo Molnar <mingo@elte.hu> wrote:
> > > 
> > > > Firstly, the practical problem: today "make namespacecheck" emits way 
> > > > too many false positives even on an allyesconfig build
> > > 
> > > We don't actually care about what comes out of `make namespacecheck'.  We
> > > care about the _difference_ in its output when a patch is applied.
> > > 
> > > So a script which reports on what changes a particular patch has upon
> > > namespacecheck output might be the way to go.  If it is fast enough then it
> > > can be run on a per-patch basis alongside checkpatch.
> > 
> > "make namespacecheck" works on the binary objects.
> > 
> > - touching header files can result in a complete rebuild
> > - if a patch alters which objects get built you should start with
> >   a clean object dir
> > 
> > The question is therefore basically whether a complete rebuild of an
> > all*config kernel is fast enough for you...
> > 
> 
> That would be quite a bother.
> 
> I do think that we should aim to get these things fixed _before_ the
> offending patches get into mainline.  It's dopey to append a sprinkle of
> fixups against any particular patch after it has hit mainline when we have
> the tools to fix those things up beforehand.
> 
> And it'd help to educate submitters to check their own stuff.  So when
> these post-facto fixups are prepared then it is good to rub people's
> noses^W^W^Wgently remind submitters about the problems in their work.
> Probably you are already doing this.
> 
> Actually, we could perhaps do a lot of this at the checkpatch level?  If
> checkpatch sees a global symbol being added and the same patch does not add
> references to that symbol from a different file then whine.  Obviously this
> will generate false positives but that's OK.

Not sure what is possible at the checkpatch level.

Adding -Wmissing-prototypes to the CFLAGS (which was my original 
motivation for doing these patches) would help much, but it's still a 
long road until I can propose it without being lynched for the warnings 
it still generates...

Or teach people to use sparse?

After all, this thread erupted on a patch against kernel/sched.c
that fixes something sparse also warns about.

I just tried running sparse against this file - looks scary...

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

