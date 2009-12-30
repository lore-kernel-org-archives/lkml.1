Return-Path: <linux-kernel-owner+w=401wt.eu-S1751810AbZL3BF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751810AbZL3BF2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 20:05:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751284AbZL3BF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 20:05:28 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:59696 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbZL3BF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 20:05:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=XYdmxSnqAcNy5LYP1DcgdgAjct3T66bUXspe4FXreZCJZ+/GMgFhQgrGTk8CqjkVZD
         xThy8GInkw1/MTeCGzCu3GQEAL8r+MXKe/TArhpIkxP3Z7OQnUrqMyV7s3eyrksxXJdY
         VDsbIL4JxCC+GYMf/GIfkG6gzGBhFnmuy6QU4=
Date: Wed, 30 Dec 2009 02:05:22 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: lockdep with reiserfs
Message-ID: <20091230010519.GD5258@nowhere>
References: <86802c440912222050o2d634667p4702a87171d045ed@mail.gmail.com> <20091223060634.GC14805@elte.hu> <86802c440912231630g6ae8d37cu4abf96f87fea3edf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <86802c440912231630g6ae8d37cu4abf96f87fea3edf@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 23, 2009 at 04:30:23PM -0800, Yinghai Lu wrote:
> 2009/12/22 Ingo Molnar <mingo@elte.hu>:
> >
> > * Yinghai Lu <yinghai@kernel.org> wrote:
> >
> >> x:~ # mount /dev/sda2 /xx
> >>
> >> [  277.586941] =======================================================
> >> [  277.594680] [ INFO: possible circular locking dependency detected ]
> >> [  277.601299] 2.6.33-rc1-tip-yh-00304-g97a015d-dirty #1007
> >> [  277.605492] -------------------------------------------------------
> >> [  277.622611] mount/19427 is trying to acquire lock:
> >> [  277.627353]  (&journal->j_mutex){+.+...}, at: [<ffffffff811c6d40>]
> >> do_journal_begin_r+0x9f/0x308
> >
> > Frederic has posted the patch below to lkml - does it do the trick for you?
> >
> with that patch, the problem still happen...
> 
> how to duplicate it:
> 1. boot sles 11 to user mode
> 2. hard reset the system
> 3. boot from network, current kernel with ramdisk as /
> 4. mount the root fs of sles11, will get this warning.
> 
> YH


Thanks for your report.

I have troubles to understand how that can happen since
the lock doesn't seem to be recursively acquired there.

Anyway, looking at the path, it seems to happen when unlinks
and truncate were unfinished (case of a hard reset) and become
resumed at mount time.

I'm trying to reproduce it, thanks!

