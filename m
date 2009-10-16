Return-Path: <linux-kernel-owner+w=401wt.eu-S1757815AbZJPJXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757815AbZJPJXq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 05:23:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757465AbZJPJXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 05:23:46 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:34985 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388AbZJPJXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 05:23:45 -0400
Date: Fri, 16 Oct 2009 11:24:18 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>, lkml <linux-kernel@vger.kernel.org>,
       linux-mips <linux-mips@linux-mips.org>,
       Chungki woo <chungki.woo@gmail.com>
Subject: Re: BUG? linux-mips flush_dcache_page
Message-ID: <20091016092418.GA3686@linux-mips.org>
References: <20091016141719.de606482.minchan.kim@barrios-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091016141719.de606482.minchan.kim@barrios-desktop>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 16, 2009 at 02:17:19PM +0900, Minchan Kim wrote:

> Many code of kernel fs usually allocate high page and flush.
> But flush_dcache_page of mips checks PageHighMem to avoid flush
> so that data consistency is broken, I think. 

What processor and cache configuration?

> I found it's by you and Atsushi-san on 585fa724. 
> Why do we need the check?
> Could you elaborte please? 

The if statement exists because __flush_dcache_page would crash if a page
is not mapped.  This of course isn't correct but that wasn't a problem
since highmem still is only supported on machines that don't have aliases.

  Ralf
