Return-Path: <linux-kernel-owner+w=401wt.eu-S1762180AbYEEV1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762180AbYEEV1j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 17:27:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761572AbYEEV1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 17:27:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40294 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761354AbYEEV1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 17:27:21 -0400
Date: Mon, 5 May 2008 14:26:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, sam@ravnborg.org, viro@ftp.linux.org.uk,
       hpa@zytor.com, Andy Whitcroft <apw@shadowen.org>
Subject: Re: [rfc] the kernel workflow & trivial "global -> static" patches
 (was: Re: [2.6 patch] make sched_feat_{names,open} static)
Message-Id: <20080505142604.389f05c6.akpm@linux-foundation.org>
In-Reply-To: <20080505210712.GD1544@cs181133002.pp.htv.fi>
References: <20080505182942.GA17139@cs181133002.pp.htv.fi>
	<20080505201906.GA900@elte.hu>
	<20080505134252.c82a64f6.akpm@linux-foundation.org>
	<20080505210712.GD1544@cs181133002.pp.htv.fi>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 May 2008 00:07:12 +0300
Adrian Bunk <bunk@kernel.org> wrote:

> On Mon, May 05, 2008 at 01:42:52PM -0700, Andrew Morton wrote:
> > On Mon, 5 May 2008 22:19:06 +0200
> > Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > Firstly, the practical problem: today "make namespacecheck" emits way 
> > > too many false positives even on an allyesconfig build
> > 
> > We don't actually care about what comes out of `make namespacecheck'.  We
> > care about the _difference_ in its output when a patch is applied.
> > 
> > So a script which reports on what changes a particular patch has upon
> > namespacecheck output might be the way to go.  If it is fast enough then it
> > can be run on a per-patch basis alongside checkpatch.
> 
> "make namespacecheck" works on the binary objects.
> 
> - touching header files can result in a complete rebuild
> - if a patch alters which objects get built you should start with
>   a clean object dir
> 
> The question is therefore basically whether a complete rebuild of an
> all*config kernel is fast enough for you...
> 

That would be quite a bother.

I do think that we should aim to get these things fixed _before_ the
offending patches get into mainline.  It's dopey to append a sprinkle of
fixups against any particular patch after it has hit mainline when we have
the tools to fix those things up beforehand.

And it'd help to educate submitters to check their own stuff.  So when
these post-facto fixups are prepared then it is good to rub people's
noses^W^W^Wgently remind submitters about the problems in their work.
Probably you are already doing this.



Actually, we could perhaps do a lot of this at the checkpatch level?  If
checkpatch sees a global symbol being added and the same patch does not add
references to that symbol from a different file then whine.  Obviously this
will generate false positives but that's OK.
