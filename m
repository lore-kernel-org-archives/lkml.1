Return-Path: <linux-kernel-owner+w=401wt.eu-S1755429AbYAISsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429AbYAISsb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 13:48:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753849AbYAISsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 13:48:23 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:47291 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115AbYAISsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 13:48:23 -0500
Date: Wed, 9 Jan 2008 18:48:14 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Jeff Layton <jlayton@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, akpm@linux-foundation.org,
       neilb@suse.de, linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] NLM: Add reference counting to lockd
Message-ID: <20080109184814.GA1562@infradead.org>
References: <1199820798-5289-1-git-send-email-jlayton@redhat.com> <1199820798-5289-2-git-send-email-jlayton@redhat.com> <1199820798-5289-3-git-send-email-jlayton@redhat.com> <1199820798-5289-4-git-send-email-jlayton@redhat.com> <1199820798-5289-5-git-send-email-jlayton@redhat.com> <1199820798-5289-6-git-send-email-jlayton@redhat.com> <1199820798-5289-7-git-send-email-jlayton@redhat.com> <20080109174707.GC30523@infradead.org> <20080109133621.72f611ec@tleilax.poochiereds.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080109133621.72f611ec@tleilax.poochiereds.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2008 at 01:36:21PM -0500, Jeff Layton wrote:
> I don't see a good alternative though. We need to be able to drop the
> and check the refcount in nlmsvc_unlink_block. That function is called
> from lockd, and we can't have lockd call kthread_stop on itself.
> 
> If you see a better way to do this, I'm certainly open to suggestions.
> 
> I'll note that my first stab at fixing this problem was to change the
> svc_wake_up() call in the rpc callback to a routine to wake up any
> lockd on the box that happened to be up. That sidesteps this entire
> problem of having to make sure lockd stays up. If we decided that was
> the right approach we could dump the last patch in this series
> altogether.
> 
> That said there could be other use after free bugs lurking in the lockd
> code so maybe keeping lockd up until nlm_blocked is empty is the right
> thing to do.

What about just not exiting from lockd as long as nlm_blocked is not
empty?  lockd_down still simply calls kthread_stop, but lockd only
honours it when nlm_blocked is empty?
