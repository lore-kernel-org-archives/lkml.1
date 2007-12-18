Return-Path: <linux-kernel-owner+w=401wt.eu-S1759954AbXLRQjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759954AbXLRQjA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 11:39:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756442AbXLRQiu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 11:38:50 -0500
Received: from vena.lwn.net ([206.168.112.25]:38279 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756776AbXLRQit (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 11:38:49 -0500
X-Greylist: delayed 420 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Dec 2007 11:38:49 EST
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: alan@redhat.com, viro@zeniv.linux.org.uk, hch@infradead.org,
       peterz@infradead.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [RFC/PATCH 2/8] revoke: inode revoke lock V7 
From: corbet@lwn.net (Jonathan Corbet)
In-reply-to: Your message of "Fri, 14 Dec 2007 17:16:17 +0200."
             <Pine.LNX.4.64.0712141715440.28689@sbz-30.cs.Helsinki.FI> 
Date: Tue, 18 Dec 2007 09:31:49 -0700
Message-ID: <2605.1197995509@vena.lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a relatively minor detail in the rather bigger context of this
patch, but...

> @@ -642,6 +644,7 @@ struct inode {
>  	struct list_head	inotify_watches; /* watches on this inode */
>  	struct mutex		inotify_mutex;	/* protects the watches list */
>  #endif
> +	wait_queue_head_t	i_revoke_wait;

That seems like a relatively hefty addition to every inode in the system
when revoke - I think - will be a fairly rare operation.  Would there be
any significant cost to using a single, global revoke-wait queue instead
of growing the inode structure?

jon
