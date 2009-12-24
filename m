Return-Path: <linux-kernel-owner+w=401wt.eu-S1756996AbZLXLDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756996AbZLXLDY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 06:03:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752737AbZLXLDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 06:03:21 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:50322 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722AbZLXLDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 06:03:20 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Eric Blake <ebb9@byu.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       bugzilla-daemon@bugzilla.kernel.org, bugme-daemon@bugzilla.kernel.org,
       Ulrich Drepper <drepper@redhat.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [Bugme-new] [Bug 14832] New: futimens (AT_FDCWD, arg) should fail
References: <bug-14832-10286@http.bugzilla.kernel.org/>
	<20091222143137.7f9b4e8b.akpm@linux-foundation.org>
	<4B321663.2050603@byu.net>
Date: Thu, 24 Dec 2009 20:03:14 +0900
In-Reply-To: <4B321663.2050603@byu.net> (Eric Blake's message of "Wed, 23 Dec
	2009 06:08:51 -0700")
Message-ID: <87vdfwk51p.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.90 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Blake <ebb9@byu.net> writes:

>> afacit, if filename==NULL and dfd==-1 then fget() will return NULL and
>> the syscall returns -EBAFD.
>
> Yes, that's true if dfd==-1.  But My complaint was not about dfd==-1, but
> about dfd==AT_FDCWD, in which case, this block of code is skipped, and you
> end up operating on the current directory ".".  My point is that the line:
>  if (filename == NULL && dfd != AT_FDCWD) {
> should probably be:
>  if (filename == NULL) {
> assuming that fget(AT_FDCWD) likewise fails.

No, it changes utimensat() behavior. If error was EBADF, it seems fd
shouldn't be AT_FDCWD. So, this behavior would be right thing as
utimensat().

[EBADF] The path argument does not specify an absolute path and the fd
    argument is neither AT_FDCWD nor a valid file descriptor open for
    reading or searching.

>> Your report doesn't tell us what kernel version you're testing.  We did
>> fix a few things ni this area, but it was a long time ago.
>
> Yesterday, Ulrich patched glibc to avoid the issue from the library side
> of things (I first raised the report against glibc 2 months ago, along
> with a proposed patch:
> http://sources.redhat.com/bugzilla/show_bug.cgi?id=10992).  But there is
> still the case of newer kernels and unpatched glibc, where it would also
> be nice to patch the kernel.  I reproduced the bug on
> 2.6.31.6-166.fc12.i686, where this test (part of coreutils' configure
> script) failed with status 2:

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
