Return-Path: <linux-kernel-owner+w=401wt.eu-S1757555AbZEVO4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757555AbZEVO4n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 10:56:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756685AbZEVO4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 10:56:36 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34603 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756619AbZEVO4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 10:56:35 -0400
Date: Fri, 22 May 2009 16:56:34 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Nick Piggin <npiggin@suse.de>,
       Mel Gorman <mel@csn.ul.ie>, Peter Ziljstra <a.p.ziljstra@chello.nl>,
       San Mehat <san@android.com>, Arve Hj?nnev?g <arve@android.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Warn when we run out of swap space (was Re: Misleading OOM
	messages)
Message-ID: <20090522145634.GA27257@elf.ucw.cz>
References: <alpine.DEB.1.10.0905141729180.30187@qirst.com> <20090514213403.GB14741@elf.ucw.cz> <1242337299.28440.47.camel@nimitz> <20090515130547.GA1976@elf.ucw.cz> <alpine.DEB.1.10.0905151358430.26559@qirst.com> <20090515200213.GA1406@ucw.cz> <alpine.DEB.1.10.0905151713230.26489@qirst.com> <20090519203944.GD1362@ucw.cz> <alpine.DEB.1.10.0905220942450.23842@qirst.com> <alpine.DEB.1.10.0905221016340.23657@qirst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0905221016340.23657@qirst.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-05-22 10:17:15, Christoph Lameter wrote:
> 
> Subject: Warn if we run out of swap space
> 
> Running out of swap space means that the evicton of anonymous pages may no longer
> be possible which can lead to OOM conditions.
> 
> Print a warning when swap space first becomes exhausted.
> 
> Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

WARN_ONCE... will it mean a backtrace? That's quite an overkill for
something that is not a kernel fault (and where backtrace is useless).

But  yes, I agree in principle.
									Pavel

> @@ -412,6 +412,7 @@ swp_entry_t get_swap_page(void)
>  	nr_swap_pages++;
>  noswap:
>  	spin_unlock(&swap_lock);
> +	WARN_ONCE(1, "All of swap is in use. Some pages cannot be swapped out.");
>  	return (swp_entry_t) {0};
>  }

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
