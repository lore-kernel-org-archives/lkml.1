Return-Path: <linux-kernel-owner+w=401wt.eu-S1760898AbXJYXrc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760898AbXJYXrc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 19:47:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753238AbXJYXrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 19:47:24 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36642 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751684AbXJYXrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 19:47:22 -0400
Date: Thu, 25 Oct 2007 16:46:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zach Brown <zach.brown@oracle.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 01/31] Add an ERR_CAST() macro to complement ERR_PTR and
 co. [try #5]
Message-Id: <20071025164658.8fdc04cc.akpm@linux-foundation.org>
In-Reply-To: <47212215.8080003@oracle.com>
References: <20071025163352.5057.59344.stgit@warthog.procyon.org.uk>
	<20071025163357.5057.35399.stgit@warthog.procyon.org.uk>
	<47212215.8080003@oracle.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Oct 2007 16:09:09 -0700
Zach Brown <zach.brown@oracle.com> wrote:

> 
> > + * ERR_CAST - Explicitly cast an error-valued pointer to another pointer type
> > + * @ptr: The pointer to cast.
> > + *
> > + * Explicitly cast an error-valued pointer to another pointer type in such a
> > + * way as to make it clear that's what's going on.
> > + */
> > +static inline void *ERR_CAST(const void *ptr)
> > +{
> > +	return (void *) ptr;
> > +}
> 
> Just to nit, surely you don't need the cast inside the function.  The
> casting happens at the call site between the argument and returned pointer.
> 

It'll warn without the cast.

btw, nit time.  This style:

	return (void *)ptr;

outnumbers this style

	return (void *) ptr;

by 4 to 1.  And I don't find the space attractive, useful or logical,
personally.

