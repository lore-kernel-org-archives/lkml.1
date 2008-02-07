Return-Path: <linux-kernel-owner+w=401wt.eu-S934770AbYBGWYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934770AbYBGWYc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 17:24:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933554AbYBGWYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 17:24:05 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:19082 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761354AbYBGWYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 17:24:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=GJBXly6dv7NHwqskf4v/EteIV1deEeD3+iGVLARf/KluhC9ICja6eQegdQmVr7m+lnb/hnr+8To+2GnWO/8kfLlZHZLemLR3vCGJmaOi7LHNVEXmkVr6+KSQXRXbU6cgrqE6mpM9V9iiW/522d4ht9A7b0LvLgeVYM3dk3+EcGc=
Message-ID: <8120cfd40802071424h5cf04861x63a88ea18508eda9@mail.gmail.com>
Date: Thu, 7 Feb 2008 23:24:00 +0100
From: "Harald Arnesen" <skogtun.linux@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: Latest git oopses during boot
Cc: "Harald Arnesen" <skogtun.harald@gmail.com>,
       "FUJITA Tomonori" <tomof@acm.org>, akpm@linux-foundation.org,
       matthew@wil.cx, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp
In-Reply-To: <alpine.LFD.1.00.0802071404400.2896@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8120cfd40802070144l79830c2cs6329c302697ecc8b@mail.gmail.com>
	 <20080207020214.0f0cf1c7.akpm@linux-foundation.org>
	 <8120cfd40802070314x2799bcbatf42e3fe824a18c22@mail.gmail.com>
	 <20080207233239Z.tomof@acm.org>
	 <8120cfd40802070933r42a98537v78feb7ee8e748a94@mail.gmail.com>
	 <alpine.LFD.1.00.0802070956380.2883@woody.linux-foundation.org>
	 <8120cfd40802071248x20ed938dh52cd9e314219613b@mail.gmail.com>
	 <alpine.LFD.1.00.0802071304420.2896@woody.linux-foundation.org>
	 <87hcgkzbry.fsf@basilikum.skogtun.org>
	 <alpine.LFD.1.00.0802071404400.2896@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/7/08, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
>
> On Thu, 7 Feb 2008, Harald Arnesen wrote:
> >
> > I'll try applying the patch to a freshly downloaded git-tree.
>
> Ok, good.
>
> > Shall I try another compiler? I have at least these two:
> >
> > gcc version 3.4.6 (Ubuntu 3.4.6-6ubuntu2)
> > gcc version 4.1.3 20070929 (prerelease) (Ubuntu 4.1.2-16ubuntu2)
>
> I would suggest a patch mis-application problem first (or possibly even
> the patch itself being broken - I simply didn't look very closely at the
> patch, but it *looked* ok).
>
> If it's a compiler bug, it's a pretty big one, and quite frankly, I doubt
> it. Compiler bugs do happen, but they are pretty rare, and they tend to
> have more subtle effects than the one you see.
>
> However:
>
> > in addition to the self-compiled 4.2.3 I used for the tests.
>
> 4.2.3? Really? That's pretty damn recent, and so almost totally untested.
> That does make a compiler bug at least more likely.
>
> So yes, if you already have other compilers installed, you should try
> them. If it really is a compiler bug, it's a really bad one, and you would
> want to let the gcc people know.
>
> Still, I'd double-check that the
>
>         asc_dvc_varp->overrun_buf = kzalloc(ASC_OVERRUN_BSIZE, GFP_KERNEL);
>
> line was added properly first. You should see it way after the point where
> it did
>
>         asc_dvc_varp = &boardp->dvc_var.asc_dvc_var;
>
> to initialize it (and both statements should be inside a
>
>         if (ASC_NARROW_BOARD(boardp)) {
>
> conditional - please check that the source code looks sane too).
>
>                         Linus

I just re-downloaded an re-patched and re-compiled (with gcc 4.2.3),
and now the kernel boots. I must have screwed up the previous
patching.

It now works, with Fujita's patch applied.
-- 
Hilsen Harald
