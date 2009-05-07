Return-Path: <linux-kernel-owner+w=401wt.eu-S1762934AbZEGWwP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762934AbZEGWwP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 18:52:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758773AbZEGWv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 18:51:57 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39310 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752814AbZEGWv4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 18:51:56 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/5] mm: Add __GFP_NO_OOM_KILL flag
Date: Fri, 8 May 2009 00:50:41 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc4-rjw; KDE/4.2.2; x86_64; ; )
Cc: rientjes@google.com, fengguang.wu@intel.com,
       linux-pm@lists.linux-foundation.org, pavel@ucw.cz,
       torvalds@linux-foundation.org, jens.axboe@oracle.com,
       alan-jenkins@tuffmail.co.uk, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org
References: <nY3-4PrO6XH.A.xtB.yw85JB@chimera> <200905080014.49426.rjw@sisk.pl> <20090507153824.df54658c.akpm@linux-foundation.org>
In-Reply-To: <20090507153824.df54658c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905080050.41973.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 08 May 2009, Andrew Morton wrote:
> On Fri, 8 May 2009 00:14:48 +0200
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > IOW, you need to freeze the user space totally before trying to disable the
> > OOM killer.
> 
> Not necessarily.  We only need to take action if a task is about to
> start oom-killing - presumably by taking a nap.
> 
> If a process is sitting there happily computing pi then we can leave it
> running.

Well, the point is we don't really know what the task is going to do next.
Is it going to continue computing pi, or is it going to execl(huge_binary), for
example?

If we knew what tasks were going to do in advance, the whole freezing wouldn't
really be necessary. :-)
