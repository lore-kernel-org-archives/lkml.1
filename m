Return-Path: <linux-kernel-owner+w=401wt.eu-S1757585AbZAVJui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757585AbZAVJui (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 04:50:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754426AbZAVJu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 04:50:29 -0500
Received: from tservice.ru ([195.178.208.66]:40164 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755318AbZAVJu2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 04:50:28 -0500
Date: Thu, 22 Jan 2009 12:50:26 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: David Rientjes <rientjes@google.com>
Cc: Nikanth Karthikesan <knikanth@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Snook <csnook@redhat.com>,
       Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
       Paul Menage <menage@google.com>, containers@lists.linux-foundation.org
Subject: Re: [RFC] [PATCH] Cgroup based OOM killer controller
Message-ID: <20090122095026.GA10579@ioremap.net>
References: <200901211638.23101.knikanth@suse.de> <200901212054.34929.knikanth@suse.de> <alpine.DEB.2.00.0901211241040.21080@chino.kir.corp.google.com> <200901221042.30957.knikanth@suse.de> <alpine.DEB.2.00.0901220036440.28850@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0901220036440.28850@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2009 at 12:43:38AM -0800, David Rientjes (rientjes@google.com) wrote:
> For example, if your task triggers an oom as the result of its exclusive 
> cpuset placement, the oom killer should prefer to kill a task within that 
> cpuset to allow for future memory freeing.

This it not true for all cases. What if you do need to start this task
and free something else outside the given set? This should be an
administrative decision and not forced by the kernel. We used to have it
that way, but it does not mean that it is the only correct way to do the
things.

> So, with your proposal, an administrator can specify the oom priority of 
> an entire aggregate of tasks but the behavior may not be desired for a 
> cpuset-constrained oom, while it may be perfectly legitimate for a global 
> unconstrained oom.

In this case administrator will not do this. It is up to him to decide
and not some inner kernel policy.

-- 
	Evgeniy Polyakov
