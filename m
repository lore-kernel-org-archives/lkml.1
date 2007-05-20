Return-Path: <linux-kernel-owner+w=401wt.eu-S1756234AbXETLjD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234AbXETLjD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 07:39:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755179AbXETLiy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 07:38:54 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:42180 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755178AbXETLix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 07:38:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=E8Ek5kQn/mj7x3+X8Cumq1umBHYxgnS2w0nR/KXM9Hs5wlOhCpdHQt8kxLKz/fdqAz69sg/DqoLhscWWbA4CNmH/kK6oWouECPF3v0sNnOw727p5SJT/WjZZE+XHg8Rg8s9o9bVZeDKgutcK+J6YwhBC2V45cSYecWhMaWQ03Iw=
Message-ID: <a781481a0705200438s634712e6v957d7085bca7407@mail.gmail.com>
Date: Sun, 20 May 2007 17:08:52 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Subject: Re: RFC: kconfig select warnings bogus?
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Sam Ravnborg" <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       "Roman Zippel" <zippel@linux-m68k.org>,
       "Kumar Gala" <galak@kernel.crashing.org>,
       "Simon Horman" <horms@verge.net.au>, "Adrian Bunk" <bunk@stusta.de>
In-Reply-To: <4650074A.6000307@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070519151523.GA26724@uranus.ravnborg.org>
	 <20070519110944.2a52061e.akpm@linux-foundation.org>
	 <a781481a0705191517n15eefe04i5458900c6ffe782d@mail.gmail.com>
	 <a781481a0705191549h602d331flf93c9d6c0261458f@mail.gmail.com>
	 <464F9A7B.1030708@s5r6.in-berlin.de>
	 <a781481a0705191753r25e0cay82785ed56c04b6eb@mail.gmail.com>
	 <a781481a0705191804u7f5a344cr92f2a1981c502bf7@mail.gmail.com>
	 <4650074A.6000307@s5r6.in-berlin.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/20/07, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> Satyam Sharma wrote:
> > You'll learn about the "default .. if .." Kconfig idiom after you try
> > this,
>
> I have seen these in the rest of the patch which I didn't quote.
>
> However you fix it --- don't remove "depends on" or "select".  You can
> interchange them, but not remove them, unless there wasn't a dependency
> to begin with.

They _can_ be removed, with absolutely no build failures at all, because
of the "default y if ..." on the dependency that is defined in some
arch/.../Kconfig.

In fact the whole _idea_ is to remove any mention of the arch-specific
dependency from arch-agnostic stuff in drivers/.../Kconfig's (be it
"depends" or "select") so as not to generate those "unknown symbols"
warnings that would come on other archs. Hence, the normal practice to
use the "default y if ..." idiom (for "bool" helper code like the original
examples on this thread) in arch/.../Kconfig files.
