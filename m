Return-Path: <linux-kernel-owner+w=401wt.eu-S1753711AbXLHOSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753711AbXLHOSU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 09:18:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751740AbXLHOSL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 09:18:11 -0500
Received: from mx1.redhat.com ([66.187.233.31]:33510 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751163AbXLHOSK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 09:18:10 -0500
Date: Sat, 8 Dec 2007 09:17:54 -0500
From: Jeff Layton <jlayton@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-nfs@vger.kernel.org, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NLM: Add lockd reference counting and clean up lockd
 startup and shutdown
Message-ID: <20071208091754.47ccc377@tleilax.poochiereds.net>
In-Reply-To: <20071208140747.GA11675@infradead.org>
References: <1197118932-4512-1-git-send-email-jlayton@redhat.com>
	<20071208140747.GA11675@infradead.org>
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 Dec 2007 14:07:47 +0000
Christoph Hellwig <hch@infradead.org> wrote:

> > +	mutex_lock(&nlmsvc_mutex);
> > +	while (atomic_read(&nlmsvc_ref) != 0) {
> 
> might be better to do the refcounting outside the thread and use the
> kthread api, which is something we still need to do for lockd anyway.
> 

Currently sending a SIGKILL to lockd tells it to drop all of its locks
without exiting. If we change lockd to use kthreads, will we have to
change that to use a different mechanism?

-- 
Jeff Layton <jlayton@redhat.com>
