Return-Path: <linux-kernel-owner+w=401wt.eu-S1755636AbZKIWHR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636AbZKIWHR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 17:07:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755611AbZKIWHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 17:07:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41015 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755592AbZKIWHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 17:07:15 -0500
Date: Mon, 9 Nov 2009 17:03:11 -0600
From: David Teigland <teigland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       cluster-devel@redhat.com, device@lanana.org, gregkh@suse.de,
       linux-kernel@vger.kernel.org, rubini@vision.unipv.it
Subject: Re: [Cluster-devel] Re: [PATCH] misc: use a proper range for minor number dynamic allocation
Message-ID: <20091109230311.GA820@redhat.com>
References: <1256340497-19320-1-git-send-email-cascardo@holoscopio.com> <20091109132836.6cf7f559.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091109132836.6cf7f559.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 09, 2009 at 01:28:36PM -0800, Andrew Morton wrote:
> On Fri, 23 Oct 2009 21:28:17 -0200
> Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com> wrote:
> 
> > The current dynamic allocation of minor number for misc devices has some
> > drawbacks.
> > 
> > First of all, the range for dynamic numbers include some statically
> > allocated numbers. It goes from 63 to 0, and we have numbers in the
> > range from 1 to 15 already allocated. Although, it gives priority to the
> > higher and not allocated numbers, we may end up in a situation where we
> > must reject registering a driver which got a static number because a
> > driver got its number with dynamic allocation. Considering fs/dlm/user.c
> > allocates as many misc devices as lockspaces are created, and that we
> > have more than 50 users around, it's not unreasonable to reach that
> > situation.
> 
> What is this DLM behaviour of which you speak?  It sounds broken.

One for each userland lockspace, I know of three userland apps using dlm:
1. rgmanager which is at the end of its life
2. clvmd which is switching to a different lock manager
3. ocfs2 tools, where the userland portion is transient; it only exists
   while the tool executes.

That said, it shouldn't be a problem to switch to a single device in the
next version of the interface.

Dave

