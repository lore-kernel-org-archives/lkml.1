Return-Path: <linux-kernel-owner+w=401wt.eu-S1754399AbXLSJCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754399AbXLSJCu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 04:02:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752051AbXLSJCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 04:02:35 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:41850 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174AbXLSJCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 04:02:33 -0500
Date: Wed, 19 Dec 2007 11:02:30 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Jonathan Corbet <corbet@lwn.net>
cc: alan@redhat.com, viro@zeniv.linux.org.uk, hch@infradead.org,
       peterz@infradead.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [RFC/PATCH 2/8] revoke: inode revoke lock V7
In-Reply-To: <2605.1197995509@vena.lwn.net>
Message-ID: <Pine.LNX.4.64.0712191100310.26683@sbz-30.cs.Helsinki.FI>
References: <2605.1197995509@vena.lwn.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jonathan,

(Thanks for the review!)

On Tue, 18 Dec 2007, Jonathan Corbet wrote:
> This is a relatively minor detail in the rather bigger context of this
> patch, but...
> 
> > @@ -642,6 +644,7 @@ struct inode {
> >  	struct list_head	inotify_watches; /* watches on this inode */
> >  	struct mutex		inotify_mutex;	/* protects the watches list */
> >  #endif
> > +	wait_queue_head_t	i_revoke_wait;
> 
> That seems like a relatively hefty addition to every inode in the system
> when revoke - I think - will be a fairly rare operation.  Would there be
> any significant cost to using a single, global revoke-wait queue instead
> of growing the inode structure?

No, that's a good idea. I'll change it for the next patchset. Thanks!

                       Pekka
