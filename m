Return-Path: <linux-kernel-owner+w=401wt.eu-S1753232AbZA0XbF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232AbZA0XbF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 18:31:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751121AbZA0Xav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 18:30:51 -0500
Received: from mx2.redhat.com ([66.187.237.31]:37068 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750994AbZA0Xau (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 18:30:50 -0500
Date: Tue, 27 Jan 2009 18:30:45 -0500
From: Jeff Layton <jlayton@redhat.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-nfs@vger.kernel.org, cluster-devel@redhat.com,
       teigland@redhat.com
Subject: Re: [PATCH 1/2] dlm: initialize file_lock struct in GETLK before
 copying conflicting lock
Message-ID: <20090127183045.58582d21@tleilax.poochiereds.net>
In-Reply-To: <20090127223401.GL9151@fieldses.org>
References: <1232651764-10799-1-git-send-email-jlayton@redhat.com>
	<1232651764-10799-2-git-send-email-jlayton@redhat.com>
	<20090127223401.GL9151@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jan 2009 17:34:01 -0500
"J. Bruce Fields" <bfields@fieldses.org> wrote:

> On Thu, Jan 22, 2009 at 02:16:03PM -0500, Jeff Layton wrote:
> > dlm_posix_get fills out the relevant fields in the file_lock before
> > returning when there is a lock conflict, but doesn't clean out any of
> > the other fields in the file_lock.
> > 
> > When nfsd does a NFSv4 lockt call, it sets the fl_lmops to
> > nfsd_posix_mng_ops before calling the lower fs. When the lock comes back
> > after testing a lock on GFS2, it still has that field set. This confuses
> > nfsd into thinking that the file_lock is a nfsd4 lock.
> > 
> > Fix this by making DLM reinitialize the file_lock before copying the
> > fields from the conflicting lock.
> > 
> > Signed-off-by: Jeff Layton <jlayton@redhat.com>
> 
> I'll leave this one to gfs2 people to apply unless I'm told otherwise.
> 
> --b.
> 

That should be fine. Dave T. has taken this into his tree and is
pushing it to Linus.

Thanks,
-- 
Jeff Layton <jlayton@redhat.com>
