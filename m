Return-Path: <linux-kernel-owner+w=401wt.eu-S1759801AbZDQJk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759801AbZDQJk4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 05:40:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757524AbZDQJkr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 05:40:47 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:55654 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754629AbZDQJkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 05:40:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=PsTvecJebPBDPansOJNkzWSjZEtXEqrPuAQfHI4G0eb+3qeXgKEydNuKkCtu82MLWj
         sQtR/iuh8uZVVzS0bKEFC8pMPj7MpGZmJyO9JgZQ9H4hxoQULaDEmpShlpljzl9TZSXK
         Qm3FTil6e97rfC1G9hgQbmfgspvntYVmbDVEA=
Date: Fri, 17 Apr 2009 11:40:42 +0200
From: Andrea Righi <righi.andrea@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: menage@google.com, balbir@linux.vnet.ibm.com, guijianfeng@cn.fujitsu.com,
       kamezawa.hiroyu@jp.fujitsu.com, agk@sourceware.org, axboe@kernel.dk,
       baramsori72@gmail.com, chlunde@ping.uio.no, dave@linux.vnet.ibm.com,
       dpshah@google.com, eric.rannaud@gmail.com, fernando@oss.ntt.co.jp,
       taka@valinux.co.jp, lizf@cn.fujitsu.com, matt@bluehost.com,
       dradford@bluehost.com, ngupta@google.com, randy.dunlap@oracle.com,
       roberto@unbit.it, ryov@valinux.co.jp, s-uchida@ap.jp.nec.com,
       subrata@linux.vnet.ibm.com, yoshikawa.takuya@oss.ntt.co.jp,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/9] bio-cgroup controller
Message-ID: <20090417094042.GB8689@linux>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	menage@google.com, balbir@linux.vnet.ibm.com,
	guijianfeng@cn.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com,
	agk@sourceware.org, axboe@kernel.dk, baramsori72@gmail.com,
	chlunde@ping.uio.no, dave@linux.vnet.ibm.com, dpshah@google.com,
	eric.rannaud@gmail.com, fernando@oss.ntt.co.jp, taka@valinux.co.jp,
	lizf@cn.fujitsu.com, matt@bluehost.com, dradford@bluehost.com,
	ngupta@google.com, randy.dunlap@oracle.com, roberto@unbit.it,
	ryov@valinux.co.jp, s-uchida@ap.jp.nec.com,
	subrata@linux.vnet.ibm.com, yoshikawa.takuya@oss.ntt.co.jp,
	containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <1239740480-28125-1-git-send-email-righi.andrea@gmail.com> <1239740480-28125-4-git-send-email-righi.andrea@gmail.com> <20090416152937.b2188370.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090416152937.b2188370.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 16, 2009 at 03:29:37PM -0700, Andrew Morton wrote:
> On Tue, 14 Apr 2009 22:21:14 +0200
> Andrea Righi <righi.andrea@gmail.com> wrote:
> 
> > Subject: [PATCH 3/9] bio-cgroup controller
> 
> Sorry, but I have to register extreme distress at the name of this. 
> The term "bio" is well-established in the kernel and here we have a new
> definition for the same term: "block I/O".
> 
> "bio" was a fine term for you to have chosen from the user's
> perspective, but from the kernel developer perspective it is quite
> horrid.  The patch adds a vast number of new symbols all into the
> existing "bio_" namespace, many of which aren't related to `struct bio'
> at all.
> 
> At least, I think that's what's happening.  Perhaps the controller
> really _is_ designed to track `struct bio'?  If so, that's an odd thing
> to tell userspace about.
> 
> 
> > The controller bio-cgroup is used by io-throttle to track writeback IO
> > and for properly apply throttling.
> 
> Presumably it tracks all forms of block-based I/O and not just delayed
> writeback.

For the general case bio-cgroup tracks all forms of block IO, in this
particular case (only for the io-throttle controller) I used bio-cgroup
to track writeback IO. Synchronous IO is accounted directly in
submit_bio() and throttled as well, imposing explicit sleeps via
schedule_timeout_killable().

-Andrea
