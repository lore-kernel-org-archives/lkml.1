Return-Path: <linux-kernel-owner+w=401wt.eu-S1751076AbZH1Wjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751076AbZH1Wjj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 18:39:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750799AbZH1Wjj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 18:39:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61986 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715AbZH1Wji (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 18:39:38 -0400
Subject: Re: [PATCH 1/9] task_struct: add PF_NONOTIFY for fanotify to use
From: Eric Paris <eparis@redhat.com>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       netdev@vger.kernel.org, davem@davemloft.net, viro@zeniv.linux.org.uk,
       alan@linux.intel.com, hch@infradead.org
In-Reply-To: <20090828223626.GA8283@ioremap.net>
References: <20090828185542.8014.22791.stgit@paris.rdu.redhat.com>
	 <20090828223626.GA8283@ioremap.net>
Content-Type: text/plain
Date: Fri, 28 Aug 2009 18:39:28 -0400
Message-Id: <1251499168.28787.2.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-08-29 at 02:36 +0400, Evgeniy Polyakov wrote:
> Hi.
> 
> On Fri, Aug 28, 2009 at 02:55:42PM -0400, Eric Paris (eparis@redhat.com) wrote:
> > Since fanotify opens file descriptors inside the kernel for it's listeners
> > it needs a way to make sure that 2 fanotify listeners, both which listen to
> > open events do not continuously see each others open events (and get into a
> > livelock reporting on each other's activity).  This fix is to create a new
> > tast_struct flags called PF_NONOTIFY.  If this flag is set in a task no
> > fanotify events will be generated for that task.   fanotify will set the
> > flag before and open call and will clear it immediately after.
> 
> Is there a way to get old-school notifications with the object
> information instead of opened file desriptor, which may suffer rlimit
> problems and scalability issues with too many opened/closed descriptors?

Use inotify.

-Eric

