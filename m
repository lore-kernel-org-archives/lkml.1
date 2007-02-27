Return-Path: <linux-kernel-owner+w=401wt.eu-S1750923AbXB0FcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750923AbXB0FcR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 00:32:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750925AbXB0FcR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 00:32:17 -0500
Received: from smtp.osdl.org ([65.172.181.24]:47334 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750870AbXB0FcR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 00:32:17 -0500
Date: Mon, 26 Feb 2007 21:32:04 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Dave Airlie" <airlied@gmail.com>
Cc: npiggin@suse.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       benh@kernel.crashing.org
Subject: Re: [patch 0/6] fault vs truncate/invalidate race fix
Message-Id: <20070226213204.14f8b584.akpm@linux-foundation.org>
In-Reply-To: <21d7e9970702262036h3575229ex3bf3cd4474a57068@mail.gmail.com>
References: <20070221023656.6306.246.sendpatchset@linux.site>
	<21d7e9970702262036h3575229ex3bf3cd4474a57068@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 27 Feb 2007 15:36:03 +1100 "Dave Airlie" <airlied@gmail.com> wrote:
> >
> > I've also got rid of the horrible populate API, and integrated nonlinear pages
> > properly with the page fault path.
> >
> > Downside is that this adds one more vector through which the buffered write
> > deadlock can occur. However this is just a very tiny one (pte being unmapped
> > for reclaim), compared to all the other ways that deadlock can occur (unmap,
> > reclaim, truncate, invalidate). I doubt it will be noticable. At any rate, it
> > is better than data corruption.
> >
> > I hope these can get merged (at least into -mm) soon.
> 
> Have these been put into mm?

Not yet - I need to get back on the correct continent, review the code,
stuff like that.  It still hurts that this work makes the write() deadlock
harder to hit, and we haven't worked out how to fix that.

> can I expect them in the next -mm so I
> can start merging up the drm memory manager code to my -mm tree..

What is the linkage between these patches and DRM?
