Return-Path: <linux-kernel-owner+w=401wt.eu-S1752318AbXC0ISw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318AbXC0ISw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 04:18:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753023AbXC0ISw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 04:18:52 -0400
Received: from smtp.osdl.org ([65.172.181.24]:44769 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750977AbXC0ISv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 04:18:51 -0400
Date: Tue, 27 Mar 2007 00:18:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch resend v4] update ctime and mtime for mmaped write
Message-Id: <20070327001834.04dc375e.akpm@linux-foundation.org>
In-Reply-To: <E1HW6eb-0003WX-00@dorka.pomaz.szeredi.hu>
References: <E1HVZyn-0008T8-00@dorka.pomaz.szeredi.hu>
	<20070326140036.f3352f81.akpm@linux-foundation.org>
	<E1HVwy4-0002UD-00@dorka.pomaz.szeredi.hu>
	<20070326153153.817b6a82.akpm@linux-foundation.org>
	<E1HW5am-0003Mc-00@dorka.pomaz.szeredi.hu>
	<20070326232214.ee92d8c4.akpm@linux-foundation.org>
	<E1HW6Ec-0003Tv-00@dorka.pomaz.szeredi.hu>
	<20070326234957.6b287dda.akpm@linux-foundation.org>
	<E1HW6eb-0003WX-00@dorka.pomaz.szeredi.hu>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Mar 2007 10:03:41 +0200 Miklos Szeredi <miklos@szeredi.hu> wrote:

> But Peter Staubach says a RH custumer has files written thorugh mmap,
> which are not being backed up.

Yes, I expect the backup problem is the major real-world hurt arising from
this bug.

But I expect we could adequately plug that problem at munmap()-time.  Or,
better, do_wp_page().  As I said - half-assed.

It's a question if whether the backup problem is the only thing which is hurting
in the real-world, or if people have other problems.

(In fact, what's wrong with doing it in do_wp_page()?  The timestamp could
be up to 30 seconds too early, but that's heaps better than what we have
now..)


