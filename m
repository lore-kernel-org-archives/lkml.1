Return-Path: <linux-kernel-owner+w=401wt.eu-S1757918AbXLaIU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757918AbXLaIU4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 03:20:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753730AbXLaIUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 03:20:46 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:39284 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753669AbXLaIUq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 03:20:46 -0500
Date: Mon, 31 Dec 2007 09:20:04 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       trivial@kernel.org, Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Richard Henderson <rth@twiddle.net>
Subject: Re: [PATCH 1/3] Remove unused dependency
Message-ID: <20071231082004.GA19690@uranus.ravnborg.org>
References: <1198306931-5258-1-git-send-email-joe@perches.com> <1198306931-5258-2-git-send-email-joe@perches.com> <20071222083323.GA22653@uranus.ravnborg.org> <1198313412.4895.24.camel@localhost> <20071222143128.GA24659@uranus.ravnborg.org> <1198351691.4895.42.camel@localhost> <20071230220018.GA16557@uranus.ravnborg.org> <1199060170.9887.27.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199060170.9887.27.camel@localhost>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 30, 2007 at 04:16:10PM -0800, Joe Perches wrote:
> On Sun, 2007-12-30 at 23:00 +0100, Sam Ravnborg wrote:
> > Can you please remind me what problem you are actually trying to solve here.
> > Your current approach it not good - we do not want .c code in include/*
> > And what is wrong with the current include path?
> 
> It's not a bit deal.
> 
> inflate.c is #include'd with different depth "../" prefixes.
> Currently, depths 1, 3, 4 and 5 are used.
> 
The relative path is the depending on the file that includes
inflate.c. The include uses '../../../...' to get to the
root of the kernel src tree and then fetching the file in
lib/.

> It seemed neater to take this inflate.c file, which can not
> be stand-alone compiled, and move it to somewhere on the
> include path so that it may be included via #include <inflate.c>
> 
> I was originally trying to make each file in a directory via
> 
> for file in $(ls lib/*.c) ; do file=${file%.c}.o ; make $file ; done

Use:
make lib/
Then you will build the right stuff - your approach is just broken.


What we should fix is the wrong dependencies in the various Makefiles.
But that require the relevant toolchains to test it and I lost them
when I recently upgraded my devel box (crosstool is my friend...).

	Sam
