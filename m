Return-Path: <linux-kernel-owner+w=401wt.eu-S932352AbXLMVTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932352AbXLMVTd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 16:19:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754775AbXLMVTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 16:19:23 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45873 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761990AbXLMVTV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 16:19:21 -0500
Date: Thu, 13 Dec 2007 16:18:58 -0500
From: Jeff Layton <jlayton@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org,
       nfsv4@linux-nfs.org
Subject: Re: [PATCH 2/6] SUNRPC: Break up __svc_create_thread and make
 svc_create_kthread
Message-ID: <20071213161858.4bf8b770@tleilax.poochiereds.net>
In-Reply-To: <20071213210643.GA28117@infradead.org>
References: <1197578428-26815-1-git-send-email-jlayton@redhat.com>
	<1197578428-26815-2-git-send-email-jlayton@redhat.com>
	<1197578428-26815-3-git-send-email-jlayton@redhat.com>
	<20071213210643.GA28117@infradead.org>
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Dec 2007 21:06:44 +0000
Christoph Hellwig <hch@infradead.org> wrote:

> On Thu, Dec 13, 2007 at 03:40:24PM -0500, Jeff Layton wrote:
> > Move the initialization that happens prior to thread creation to a
> > new function (svc_prepare_thread) so that we can call it from a new
> > thread creation routine. Add a new function svc_create_kthread that
> > spawns svc threads using kthread API.
> > 
> > We should be able to eventually convert all of the callers to the
> > kthread API, at which point we can drop __svc_create_thread.
> 
> > +static struct svc_rqst *
> > +svc_prepare_thread(svc_thread_fn func, struct svc_serv *serv,
> > +		   struct svc_pool *pool)
> 
> Could you just export this helper? I'd rather have callers have full
> control over how they create their threads and call into a helper to
> initialize the sunrpc state.
> 

Sure, sounds reasonable. Once I collect comments on this patch and do a
respin, I'll plan to export that symbol.

Thanks,
-- 
Jeff Layton <jlayton@redhat.com>
