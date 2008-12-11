Return-Path: <linux-kernel-owner+w=401wt.eu-S1757890AbYLKU2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757890AbYLKU2V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 15:28:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756929AbYLKU2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 15:28:08 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:60381 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756920AbYLKU2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 15:28:07 -0500
Date: Thu, 11 Dec 2008 20:28:00 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Yuri Tikhonov <yur@emcraft.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Geert.Uytterhoeven@sonycom.com,
       dhowells@redhat.com, miltonm@bga.com, wd@denx.de, dzu@denx.de,
       yanok@emcraft.com
Subject: Re: [PATCH][v2] fork_init: fix division by zero
Message-ID: <20081211202800.GQ28946@ZenIV.linux.org.uk>
References: <200812101950.51958.yur@emcraft.com> <20081211121635.ff58193f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081211121635.ff58193f.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2008 at 12:16:35PM -0800, Andrew Morton wrote:
> > +#if (8 * THREAD_SIZE) > PAGE_SIZE
> >  	max_threads = mempages / (8 * THREAD_SIZE / PAGE_SIZE);
> > +#else
> > +	max_threads = mempages * (PAGE_SIZE / (8 * THREAD_SIZE));
> > +#endif
> 
> The expression you've chosen here can be quite inacccurate, because
> ((PAGE_SIZE / (8 * THREAD_SIZE)) is a small number.  The way to
> preserve accuracy is
> 
> 	max_threads = (mempages * PAGE_SIZE) / (8 * THREAD_SIZE);
> 
> so how about avoiding the nasty ifdefs and doing

Are you sure?  Do they actually cross the page boundaries?
