Return-Path: <linux-kernel-owner+w=401wt.eu-S1759609AbXIQUtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759609AbXIQUtV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 16:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757130AbXIQUtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 16:49:10 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42234 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757126AbXIQUtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 16:49:08 -0400
Date: Mon, 17 Sep 2007 13:48:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Paul Menage" <menage@google.com>
Cc: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add a refcount check in dput()
Message-Id: <20070917134835.88c8f470.akpm@linux-foundation.org>
In-Reply-To: <6599ad830709171121r1ded056j7dc676bb6f37e231@mail.gmail.com>
References: <20070910221319.302473D66CF@localhost>
	<20070915013913.880b4c70.akpm@linux-foundation.org>
	<6599ad830709171121r1ded056j7dc676bb6f37e231@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Sep 2007 11:21:35 -0700
"Paul Menage" <menage@google.com> wrote:

> On 9/15/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > >
> > > +     BUG_ON(!atomic_read(&dentry->d_count));
> > >  repeat:
> > >       if (atomic_read(&dentry->d_count) == 1)
> > >               might_sleep();
> >
> > eek, much too aggressive.
> 
> How about the equivalent BUG_ON() in dget()? I figure that they ought
> to both be of the same strictness.

The one in dget() is known not to trigger - it's been there for a long time.

My problem with new BUG_ON's is that they get added thinking "no way will
this trigger" and lo, they do trigger and lots of people get their testing
disrupted for a whole release.



Long-standing checks like the one in dget() should perhaps be removed now
that we know they don't trigger - move them under some CONFIG_DEBUG_foo
option.
