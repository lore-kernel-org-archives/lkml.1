Return-Path: <linux-kernel-owner+w=401wt.eu-S1761371AbXEXBgG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761371AbXEXBgG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 21:36:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757257AbXEXBfz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 21:35:55 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:48261 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756737AbXEXBfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 21:35:55 -0400
Date: Wed, 23 May 2007 18:35:52 -0700
From: Paul Jackson <pj@sgi.com>
To: Paul Menage <menage@google.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, menage@google.com
Subject: Re: [PATCH] Reduce cpuset.c write_lock_irq() to read_lock()
Message-Id: <20070523183552.e0ae95db.pj@sgi.com>
In-Reply-To: <20070524012316.98BFB3D65BA@localhost>
References: <20070524012316.98BFB3D65BA@localhost>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul M wrote:
> cpuset.c:update_nodemask() uses a write_lock_irq() on tasklist_lock to
> block concurrent forks; a read_lock() suffices and is less intrusive.

Seems reasonable to me - thanks.

> -		write_lock_irq(&tasklist_lock);		/* block fork */
> +		read_lock(&tasklist_lock);		/* block fork */
>  		if (atomic_read(&cs->count) <= ntasks)
>  			break;				/* got enough */
> -		write_unlock_irq(&tasklist_lock);	/* try again */
> +		read_unlock(&tasklist_lock);	/* try again */

Too bad you didn't keep the nicely aligned comments aligned ;).

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
