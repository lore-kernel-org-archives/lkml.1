Return-Path: <linux-kernel-owner+w=401wt.eu-S1754874AbZG0IJ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874AbZG0IJ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 04:09:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754771AbZG0IJ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 04:09:59 -0400
Received: from mail09.linbit.com ([212.69.161.110]:59633 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754738AbZG0IJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 04:09:58 -0400
Date: Mon, 27 Jul 2009 10:09:57 +0200
From: Lars Ellenberg <lars.ellenberg@linbit.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Philipp Reisner <philipp.reisner@linbit.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: linux-next: drbd tree build failure
Message-ID: <20090727080957.GA8046@barkeeper1-xen.linbit>
References: <20090727154816.24e81531.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090727154816.24e81531.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 27, 2009 at 03:48:16PM +1000, Stephen Rothwell wrote:
> Hi Philipp,
> 
> Today's linux-next build (x86_64 allmodconfig) failed like this:
> 
> drivers/block/drbd/drbd_main.c: In function 'drbd_thread_current_set_cpu':
> drivers/block/drbd/drbd_main.c:1592: error: implicit declaration of function 'set_cpus_allowed'
> 
> Introduced by commit 8a4ebc3fbd90072ac870064a930fe612eea6d9a1 ("DRBD:
> main") from the drbd interacting with commit
> 84cf7f02712e3491fb9776f950a8c4f413204c8b
> ("cpumask:remove-set_cpus_allowed") from the rr tree.
> 
> I am not sure what the transformation to the new infrastructure is here -
> maybe Rusty can help?
> 
> For today, I have reverted the rr tree commit above but we need a better
> solution.

I think we can easily use set_cpus_allowed_ptr() instead,
as in fact, we do not have the cpu mask on the stack.
But embeded in struct drbd_conf.


-- 
: Lars Ellenberg
: LINBIT | Your Way to High Availability
: DRBD/HA support and consulting http://www.linbit.com

DRBD® and LINBIT® are registered trademarks of LINBIT, Austria.
