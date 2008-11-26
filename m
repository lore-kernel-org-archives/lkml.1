Return-Path: <linux-kernel-owner+w=401wt.eu-S1753810AbYKZIjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810AbYKZIjn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 03:39:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751793AbYKZIjd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 03:39:33 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54402 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751157AbYKZIjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 03:39:32 -0500
Date: Wed, 26 Nov 2008 00:38:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: john@johnmccutchan.com, arnd@arndb.de, mtk.manpages@gmail.com, hch@lst.de,
       rlove@rlove.org, linux-api@vger.kernel.org,
       linux-kernel@vger.kernel.org, pavel@suse.cz, davidn@davidnewall.com,
       Eric Paris <eparis@redhat.com>
Subject: Re: [take2] Inotify: nested attributes support.
Message-Id: <20081126003825.2b9a92be.akpm@linux-foundation.org>
In-Reply-To: <20081126082936.GB17525@ioremap.net>
References: <20081125194234.GA24449@ioremap.net>
	<20081125162434.4feacbbf.akpm@linux-foundation.org>
	<20081126074239.GA17525@ioremap.net>
	<20081126001538.4b1c7c99.akpm@linux-foundation.org>
	<20081126082936.GB17525@ioremap.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Nov 2008 11:29:36 +0300 Evgeniy Polyakov <zbr@ioremap.net> wrote:

> On Wed, Nov 26, 2008 at 12:15:38AM -0800, Andrew Morton (akpm@linux-foundation.org) wrote:
> > OK, so we have a super-duper framework which will allow us to add pids
> > (and other things) to inotify messages.
> 
> Yup :)
> 
> > This still doesn't provide a reason for anyone to be interested in the
> > code!  Why do we want pids in inotify messages?
>  
> I actually cared only about myself :)
> I started the thread and implementation, because my application has to
> differentiate IO made by itself and any IO made by system (another
> users, crons, whatever else), inotify did not give me that info, so I
> extended it. As of others: PID/TID may be used by watching applications
> to reduce own load to not process own IO, things like beagle may show
> who actually made changes into the file.

hrm.  Well this is the sort of information which reviewers want to know
all about before looking at an implementation.

> > And how does this work give that pids are (no longer) system-wide unique?
> 
> It gets pids from the caller's task_struct (via current), so its data is
> as unique as process calling getpid() or syscall(__NR_gettid).

That means that the code delivers non-unique process identifiers to
userspace.  A client gets pid=42 but there are seven processes on the
machine with that pid.  Problem.


