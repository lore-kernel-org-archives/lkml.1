Return-Path: <linux-kernel-owner+w=401wt.eu-S1758988AbXGDDpw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758988AbXGDDpw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 23:45:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755302AbXGDDpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 23:45:43 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:32407 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbXGDDpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 23:45:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Y+cNcBd2GMWPKXHlXBGSA4ZNAKcSBs7+Eod0BOuZrNh7D8OBSIvjUuNV7PzuZuBFPhKD9I9EMQz227qfw0Zxh7nj0uIf+zzUHKrrGyi5+CwhJ+53bpyTfOgzJrjImfYjwrPKACpluMqqkowbqMa9NRnJZXI72jsx+UYVskC6d8w=
Message-ID: <a44ae5cd0707032045wa35095dg794608c2fd6d6633@mail.gmail.com>
Date: Tue, 3 Jul 2007 20:45:41 -0700
From: "Miles Lane" <miles.lane@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.22-rc6-mm1 -- Problems with suspend/resume.
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20070703183406.3cd17bc6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a44ae5cd0707031809p3d7c3b68gf2d5633736bb4f3@mail.gmail.com>
	 <20070703183406.3cd17bc6.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/3/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Tue, 3 Jul 2007 18:09:29 -0700 "Miles Lane" <miles.lane@gmail.com> wrote:
>
> > Sorry.  I don't know who else to include in the To: list.  Should I
> > send this again with .config information?  Would ps -Af help?
>
> Gosh, what a lot of output we generated.  It's pretty digestible though.
>
> It looks like these are the problem:
>
> cat           D 0000002B     0  5603      1 (NOTLB)
>        c8102e4c 00000096 80cc15ad 0000002b c1176c2c c8102e38 00000046 c7fb2bc0
>        c7fb2d50 c265c100 80cc15ad 0000002b 00000000 c8102e4c c7f12d00 c014b438
>        00000001 c036759c c63b6914 c8102e68 c63b68e0 00000246 c8102e88 c0367416
> Call Trace:
>  [<c0367416>] __mutex_lock_slowpath+0x1c7/0x32c
>  [<c036759c>] mutex_lock+0x21/0x24
>  [<f8ac10ca>] drm_vma_info+0x1f/0x310 [drm]
>  [<c01b514d>] proc_file_read+0x108/0x222
>  [<c01b19ed>] proc_reg_read+0x63/0x76
>  [<c01834aa>] vfs_read+0xb0/0x139
>  [<c018390e>] sys_read+0x3d/0x72
>  [<c0108162>] sysenter_past_esp+0x6b/0xb5
>  [<ffffe410>] 0xffffe410
>  =======================
> INFO: lockdep is turned off.
> tail          D 0000002C     0  5646      1 (NOTLB)
>        c811ce4c 00000096 7137dc36 0000002c c1175f98 c811ce38 00000046 c80e15e0
>        c80e1770 c265c100 7137dc36 0000002c 00000000 c811ce4c c7f11e00 c014b438
>        00000001 c036759c c63b6914 c811ce68 c63b68e0 00000246 c811ce88 c0367416
> Call Trace:
>  [<c0367416>] __mutex_lock_slowpath+0x1c7/0x32c
>  [<c036759c>] mutex_lock+0x21/0x24
>  [<f8ac10ca>] drm_vma_info+0x1f/0x310 [drm]
>  [<c01b514d>] proc_file_read+0x108/0x222
>  [<c01b19ed>] proc_reg_read+0x63/0x76
>  [<c01834aa>] vfs_read+0xb0/0x139
>  [<c018390e>] sys_read+0x3d/0x72
>  [<c0108162>] sysenter_past_esp+0x6b/0xb5
>  [<ffffe410>] 0xffffe410
>  =======================
> INFO: lockdep is turned off.
> cat           D 00000033     0  5910      1 (NOTLB)
>        c8107e4c 00000096 24ccdd52 00000033 c014b438 00000001 c8107e14 c7e9ed60
>        c7e9eef0 c265c100 24ccdd52 00000033 00000000 c8107e4c c7f11b80 c014b438
>        00000001 c036759c c63b6914 c8107e68 c63b68e0 00000246 c8107e88 c0367416
> Call Trace:
>  [<c0367416>] __mutex_lock_slowpath+0x1c7/0x32c
>  [<c036759c>] mutex_lock+0x21/0x24
>  [<f8ac10ca>] drm_vma_info+0x1f/0x310 [drm]
>  [<c01b514d>] proc_file_read+0x108/0x222
>  [<c01b19ed>] proc_reg_read+0x63/0x76
>  [<c01834aa>] vfs_read+0xb0/0x139
>  [<c018390e>] sys_read+0x3d/0x72
>  [<c0108162>] sysenter_past_esp+0x6b/0xb5
>  [<ffffe410>] 0xffffe410
>  =======================
> INFO: lockdep is turned off.
> cat           D 00000033     0  5926      1 (NOTLB)
>        c8160e4c 00000096 8cc85f27 00000033 c117483c c8160e38 00000046 c80e0af0
>        c80e0c80 c265c100 8cc85f27 00000033 00000000 c8160e4c c7f13480 c014b438
>        00000001 c036759c c63b6914 c8160e68 c63b68e0 00000246 c8160e88 c0367416
> Call Trace:
>  [<c0367416>] __mutex_lock_slowpath+0x1c7/0x32c
>  [<c036759c>] mutex_lock+0x21/0x24
>  [<f8ac10ca>] drm_vma_info+0x1f/0x310 [drm]
>  [<c01b514d>] proc_file_read+0x108/0x222
>  [<c01b19ed>] proc_reg_read+0x63/0x76
>  [<c01834aa>] vfs_read+0xb0/0x139
>  [<c018390e>] sys_read+0x3d/0x72
>  [<c0108162>] sysenter_past_esp+0x6b/0xb5
>  [<ffffe410>] 0xffffe410
>  =======================
> INFO: lockdep is turned off.
> cat           D 00000034     0  5950      1 (NOTLB)
>        c8084e4c 00000096 39b9c536 00000034 c117afbc c8084e38 00000046 c6ce15e0
>        c6ce1770 c265c100 39b9c536 00000034 00000000 c8084e4c c7f13200 c014b438
>        00000001 c036759c c63b6914 c8084e68 c63b68e0 00000246 c8084e88 c0367416
> Call Trace:
>  [<c0367416>] __mutex_lock_slowpath+0x1c7/0x32c
>  [<c036759c>] mutex_lock+0x21/0x24
>  [<f8ac10ca>] drm_vma_info+0x1f/0x310 [drm]
>  [<c01b514d>] proc_file_read+0x108/0x222
>  [<c01b19ed>] proc_reg_read+0x63/0x76
>  [<c01834aa>] vfs_read+0xb0/0x139
>  [<c018390e>] sys_read+0x3d/0x72
>  [<c0108162>] sysenter_past_esp+0x6b/0xb5
>  [<ffffe410>] 0xffffe410
>  =======================
>
> and I'm guessing that this kernel is one which has already oopsed in
> drm_vma_info()?
>
> If so, then problem solved: it oopsed with the lock held.  If not, then
> perhaps we have another problem in DRM.  Or the same one remanifesting.

Yes, it is.  Thanks.  Should I not report stuff like this when it is
generated after an OOPS?
Sorry to trouble you.

      Miles
