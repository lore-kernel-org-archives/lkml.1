Return-Path: <linux-kernel-owner+w=401wt.eu-S1753308AbYKZI3s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308AbYKZI3s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 03:29:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750921AbYKZI3j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 03:29:39 -0500
Received: from genesysrack.ru ([195.178.208.66]:40859 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750696AbYKZI3i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 03:29:38 -0500
Date: Wed, 26 Nov 2008 11:29:36 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: john@johnmccutchan.com, arnd@arndb.de, mtk.manpages@gmail.com, hch@lst.de,
       rlove@rlove.org, linux-api@vger.kernel.org,
       linux-kernel@vger.kernel.org, pavel@suse.cz, davidn@davidnewall.com,
       Eric Paris <eparis@redhat.com>
Subject: Re: [take2] Inotify: nested attributes support.
Message-ID: <20081126082936.GB17525@ioremap.net>
References: <20081125194234.GA24449@ioremap.net> <20081125162434.4feacbbf.akpm@linux-foundation.org> <20081126074239.GA17525@ioremap.net> <20081126001538.4b1c7c99.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081126001538.4b1c7c99.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2008 at 12:15:38AM -0800, Andrew Morton (akpm@linux-foundation.org) wrote:
> OK, so we have a super-duper framework which will allow us to add pids
> (and other things) to inotify messages.

Yup :)

> This still doesn't provide a reason for anyone to be interested in the
> code!  Why do we want pids in inotify messages?
 
I actually cared only about myself :)
I started the thread and implementation, because my application has to
differentiate IO made by itself and any IO made by system (another
users, crons, whatever else), inotify did not give me that info, so I
extended it. As of others: PID/TID may be used by watching applications
to reduce own load to not process own IO, things like beagle may show
who actually made changes into the file.

> And how does this work give that pids are (no longer) system-wide unique?

It gets pids from the caller's task_struct (via current), so its data is
as unique as process calling getpid() or syscall(__NR_gettid).

-- 
	Evgeniy Polyakov
