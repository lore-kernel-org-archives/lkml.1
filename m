Return-Path: <linux-kernel-owner+w=401wt.eu-S1030490AbXCCWPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030490AbXCCWPA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 17:15:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030489AbXCCWPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 17:15:00 -0500
Received: from smtp.osdl.org ([65.172.181.24]:47408 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030490AbXCCWO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 17:14:59 -0500
Date: Sat, 3 Mar 2007 14:14:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: bert hubert <bert.hubert@netherlabs.nl>
Cc: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: userspace pagecache management tool
Message-Id: <20070303141448.1ed70e6d.akpm@linux-foundation.org>
In-Reply-To: <20070303214108.GA28961@outpost.ds9a.nl>
References: <20070303122935.f1ab0067.akpm@linux-foundation.org>
	<45E9DD4A.2060806@redhat.com>
	<20070303131204.6706a95c.akpm@linux-foundation.org>
	<45E9E910.2070804@redhat.com>
	<20070303214108.GA28961@outpost.ds9a.nl>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Mar 2007 22:41:09 +0100 bert hubert <bert.hubert@netherlabs.nl> wrote:

> > How can you make global policy decisions based on the intent
> > of one program?
> 
> By not doing so.

yup.

> Andrew's program is fine in principle, except that the
> linux kernel treats the communication of a program's intent as a global
> instruction.

argh.

That felt good - let's do it again.

argh.


It is *not* a global instruction.  It uses setenv, so the user's policy
affects only the target process and its forked children.


> Also, Andrew's description is a tad misleasing, as the size of the page
> cache might be altered a lot in case content is accessed that was previously
> cached!

That's true.

Although if the user knows that he'll want to use that data again soon, and
he elects to purge it all from cache beforehand then we're dealing with a pretty
dumb user.

If this user doesn't plan to use the data again, but some other user does,
then he loses.


> With my userspace hat on, I'd love to have a proper way to communicate my
> *program's* expectations to the kernel, without stomping other programs.

That is the aim and effect of this work.

> Also with the same hat on, I hope to rarely *need* to communicate my
> expectations because the kernel correctly predicts many cases.

yup.  It's those odd cases where it goes wrong which I'm addressing here.

And of course there's no way for the kernel to work out that it's about to
go wrong - kernel can't read user's mind.


Well.  That's not strictly true.  One could envisage a database-backed
learning program which observes the users work patterns and, based on
various pattern-matchings, works out what the best strategy is likely to be
when the user starts some operation which he has performed previously.

