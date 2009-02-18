Return-Path: <linux-kernel-owner+w=401wt.eu-S1756667AbZBRXxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667AbZBRXxT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 18:53:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753311AbZBRXxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 18:53:08 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57780 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753114AbZBRXxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 18:53:06 -0500
Date: Wed, 18 Feb 2009 15:52:31 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: hch@infradead.org, rth@twiddle.net, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] alpha: binfmt_aout fix
Message-Id: <20090218155231.8b8c8b9f.akpm@linux-foundation.org>
In-Reply-To: <20090217114054.GA26176@jurassic.park.msu.ru>
References: <20090217104956.GC25856@jurassic.park.msu.ru>
	<20090217110842.GA22272@infradead.org>
	<20090217114054.GA26176@jurassic.park.msu.ru>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Feb 2009 14:40:56 +0300
Ivan Kokshaysky <ink@jurassic.park.msu.ru> wrote:

> On Tue, Feb 17, 2009 at 06:08:42AM -0500, Christoph Hellwig wrote:
> > I think the proper fix for this is to make sure newly registered
> > binfmts are added to the tail of the list, not the front.
> 
> Yes, I was thinking about that. But then I need to make sure
> that alpha binfmt_loader is registered first, which is not
> possible at the moment as binfmts get registered at core_initcall
> level.
> If it's acceptable to change binfmts initcall level to, say,
> fs_initcall, then changing list_add() to list_add_tail() would
> certainly work fine here.
> 

It would make sense to register the core, default handlers first and
to permit arch-specific handlers to then override (or to front-end) the
core handlers.

But that sounds a bit risky for 2.6.29.  Is this fix needed in 2.6.29? 
If so, perhaps we should merge version 1 as a temporary thing.  But if
so, please let's not do the temporary-thing-which-hangs-around-forever thing?
