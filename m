Return-Path: <linux-kernel-owner+w=401wt.eu-S1752251Ab0AHFn1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752251Ab0AHFn1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 00:43:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751196Ab0AHFnY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 00:43:24 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:42487 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702Ab0AHFnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 00:43:24 -0500
Date: Fri, 8 Jan 2010 06:42:14 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
       Artem Bityutskiy <dedekind1@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: sections mismatch detection
Message-ID: <20100108054144.GA15827@merkur.ravnborg.org>
References: <1262772683.4263.147.camel@localhost> <20100106104823.GA30439@merkur.ravnborg.org> <4B44762C.1090605@suse.cz> <20100107150339.b66fadc5.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100107150339.b66fadc5.rdunlap@xenotime.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> I would prefer to see (logically) the same section mismatch not be
> reported multiple times, even though they are in different binary
> files.  This would reduce the noise level quite a bit IMO.

That would be nice but is not trivially doable.
We need to discover when there is a section mismatch
resulting from for example a function in kernel/*
calling a function in arch/$ARCH/kernel so we
need to execute the check on multiple levels
i order to catch the bugs as early as possible.

The easy 'fix' would be to execute the check only
on vmlinux.o (default behaviour) but the added
checks with the option enabled allows us to
be much more precise in reporting where
the section mismatch originate from.

	Sam
