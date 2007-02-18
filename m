Return-Path: <linux-kernel-owner+w=401wt.eu-S2992955AbXBRAlK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992955AbXBRAlK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 19:41:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992957AbXBRAlK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 19:41:10 -0500
Received: from wx-out-0506.google.com ([66.249.82.230]:47624 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992955AbXBRAlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 19:41:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=clsxjDi1EFPqeziaRn8pdCQHZ6GIxlhshXqQv/3+DUHJU9rf+jtjlXvH6ILW4j7x9IJ7QuTdrf7uiagAr0/JQVrg9FLKuBW8by8ZAIBpmamtCFon8ehmTdH5mT8ZL+x6A+q/vk9fTFfxj5r9mvyT/aFwD2Tr2ciHO9FzTOAvLlg=
Message-ID: <f44c5fdf0702171641l43fb62d9h73df322634ae26d6@mail.gmail.com>
Date: Sun, 18 Feb 2007 01:41:07 +0100
From: "Radoslaw Szkodzinski" <astralstorm@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [ck] Re: 2.6.20-ck1
Cc: "Con Kolivas" <kernel@kolivas.org>, "Chuck Ebbert" <cebbert@redhat.com>,
       "michael chang" <thenewme91@gmail.com>,
       "ck mailing list" <ck@vds.kolivas.org>,
       "linux kernel mailing list" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070217154746.7ff10870.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200702162110.03355.kernel@kolivas.org>
	 <200702171417.28376.kernel@kolivas.org> <45D74D34.5020201@redhat.com>
	 <200702180800.07393.kernel@kolivas.org>
	 <20070217154746.7ff10870.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/18/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> Generally, the penalties for getting this stuff wrong are very very high:
> orders of magnitude slowdowns in the right situations.  Which I suspect
> will make any system-wide knob ultimately unsuccessful.
>

Yes, they were. Now, it's an extremely light and well-tuned patch.
kprefetchd should only run on a totally idle system now.

> The ideal way of getting this *right* is to change every application in the
> world to get smart about using sync_page_range() and/or posix_fadvise(),
> then to add a set of command-line options to each application in the world
> so the user can control its pagecache handling.

We don't live in a perfect world. :-)

> Obviously that isn't practical.  But what _could_ be done is to put these
> pagecache smarts into glibc's read() and write() code.  So the user can do:
>
>         MAX_PAGECACHE=4M MAX_DIRTY_PAGECACHE=2M rsync foo bar
>
> This will provide pagecache control for pretty much every application.  It
> has limitations (fork+exec behaviour??) but will be useful.

Not too useful for interactive applications with unpredictable memory
consumption behaviour, where swap-prefetch still helps.

> A kernel-based solution might use new rlimits, but would not be as flexible
> or successful as a libc-based one, I suspect.
