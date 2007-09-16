Return-Path: <linux-kernel-owner+w=401wt.eu-S1751958AbXIPFK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958AbXIPFK4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 01:10:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751685AbXIPFKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 01:10:37 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40872 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751564AbXIPFKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 01:10:35 -0400
Date: Sat, 15 Sep 2007 22:10:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Brownell <david-b@pacbell.net>
Cc: cebbert@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: Two identical entries for "rtc" in /proc/devices
Message-Id: <20070915221015.02aad5ea.akpm@linux-foundation.org>
In-Reply-To: <20070915185020.16BB51F9EAA@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
References: <46E07DDA.2040907@redhat.com>
	<20070915004421.33d552d3.akpm@linux-foundation.org>
	<20070915185020.16BB51F9EAA@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Sep 2007 11:50:21 -0700 David Brownell <david-b@pacbell.net> wrote:

> > On Thu, 06 Sep 2007 18:23:22 -0400 Chuck Ebbert <cebbert@redhat.com> wrote:
> >
> > > # ls -li
> > > total 0
> > > 4026532007 -r--r--r-- 1 root root 0 Sep  6 18:18 nvram
> > > 4026532067 -r--r--r-- 1 root root 0 Sep  6 18:18 rtc
> > > 4026532067 -r--r--r-- 1 root root 0 Sep  6 18:18 rtc
> > > 4026532056 -rw-r--r-- 1 root root 0 Sep  6 18:18 snd-page-alloc
> >
> > Next -mm has
> >
> > procfs-detect-duplicate-names.patch
> > procfs-detect-duplicate-names-fix.patch
> > procfs-detect-duplicate-names-fix-fix-2.patch
> >
> > which will at least tell us who the second offender is.
> 
> Semes pretty clear that this must be procfs itself...
> when a filesystem sees a name in a directory, it should
> refuse to make another file with the same name.  And it
> should *never* reuse inode numbers...
> 

procfs can reject the attempt to create the file, but the bottom line
is that two different callsites are trying to create the same file.  One
of those callsites needs fixing?
