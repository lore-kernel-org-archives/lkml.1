Return-Path: <linux-kernel-owner+w=401wt.eu-S1754606AbYKRUXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606AbYKRUXc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 15:23:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754347AbYKRUXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 15:23:04 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:15366 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754327AbYKRUXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 15:23:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=NdQwevOc0FG5SJ5e7Tj982A+A0+Sbh8KgkyYgvHtjmsgtVREI2rPBAAEcuhD/4g1Mf
         UoBQuvgKKCo7nSIXRaosbTNVZ7D8+jbJoxU4JbOU6f090zJKVo9OT8g3SDx8ZID9qz21
         bXOn+zx49ahPJzq8yy4NlxSoCH657UkMyCeTs=
Message-ID: <cfd18e0f0811181222y4cba081m18fc5cf86512b85f@mail.gmail.com>
Date: Tue, 18 Nov 2008 15:22:59 -0500
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
Reply-To: mtk.manpages@gmail.com
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [patch] Fix type errors in inotify interfaces
Cc: lkml <linux-kernel@vger.kernel.org>, "Robert Love" <rlove@google.com>,
       "Vegard Nossum" <vegard.nossum@gmail.com>,
       "Ulrich Drepper" <drepper@redhat.com>,
       "Michael Kerrisk" <mtk.manpages@gmail.com>
In-Reply-To: <4923230D.8090301@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4923230D.8090301@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I hope Robert doesn't mind if I drop a piece from our old offlist mail
conversation into this thread, for some background.

-------- Original Message --------
Subject: Re: Use of uint32_t in inotify APIs
Date: Tue, 20 Jun 2006 09:07:17 -0400
From: Robert Love <rlove@rlove.org>

On 6/20/06, Michael Kerrisk wrote:

Hi,

> The use of uint32_t seems a little strange in at least some of the
> above.  In particular, the watch descriptor returned by
> inotify_add_watch() is an "int", as is the "wd" field of the
> "inotify_event" structure, but in the prototype for inotify_rm_watch(),
> "wd" is uint32_t.  Is there a reason for this, or is it just cruft?

The unsigned parameter in inotify_rm_watch() is wrong.  I cannot think
we that should be the case.  But the problem lies not with glibc --
the function definition in the kernel is wrong, too.  It should be
fixed; everywhere else a watch descriptor is an __s32.

> Following on from this, is it really necessary that "mask" is uint32_t
> in the prototype for inotify_rm_watch()?  In most other glibc
> interfaces, bit masks are simply "int".

I think masks should be unsigned.  This definitely makes sense.

In the kernel, most of the inotify data types are __u32.

[...]

Also the 'wd' in the event structure should be 'int32_t' -- the kernel
uses the type '__s32' -- but perhaps glibc developers prefer to use a
straight 'int' since the types are identical.

In that case, inotify_rm_watch()'s 'wd' should be changed to '__s32'
in the kernel and 'int' in glibc.  Otherwise, '__s32' in the kernel
and 'int32_t' in glibc.  Since this change will affect ABI, it needs
to be made cautiously, but I don't see any issues.

     Robert Love
