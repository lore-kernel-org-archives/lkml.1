Return-Path: <linux-kernel-owner+w=401wt.eu-S1751508AbZH1Wg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751508AbZH1Wg0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 18:36:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751264AbZH1Wg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 18:36:26 -0400
Received: from tservice.net.ru ([195.178.208.66]:47820 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751060AbZH1WgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 18:36:25 -0400
Date: Sat, 29 Aug 2009 02:36:26 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       netdev@vger.kernel.org, davem@davemloft.net, viro@zeniv.linux.org.uk,
       alan@linux.intel.com, hch@infradead.org
Subject: Re: [PATCH 1/9] task_struct: add PF_NONOTIFY for fanotify to use
Message-ID: <20090828223626.GA8283@ioremap.net>
References: <20090828185542.8014.22791.stgit@paris.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090828185542.8014.22791.stgit@paris.rdu.redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Fri, Aug 28, 2009 at 02:55:42PM -0400, Eric Paris (eparis@redhat.com) wrote:
> Since fanotify opens file descriptors inside the kernel for it's listeners
> it needs a way to make sure that 2 fanotify listeners, both which listen to
> open events do not continuously see each others open events (and get into a
> livelock reporting on each other's activity).  This fix is to create a new
> tast_struct flags called PF_NONOTIFY.  If this flag is set in a task no
> fanotify events will be generated for that task.   fanotify will set the
> flag before and open call and will clear it immediately after.

Is there a way to get old-school notifications with the object
information instead of opened file desriptor, which may suffer rlimit
problems and scalability issues with too many opened/closed descriptors?

-- 
	Evgeniy Polyakov
