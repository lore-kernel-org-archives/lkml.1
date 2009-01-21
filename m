Return-Path: <linux-kernel-owner+w=401wt.eu-S1763939AbZAULdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763939AbZAULdR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 06:33:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756228AbZAULdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 06:33:00 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:36138 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756072AbZAULdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 06:33:00 -0500
Date: Wed, 21 Jan 2009 12:34:43 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Size of sector_t in userspace [Was: fix 41 'make headers_check' warnings]
Message-ID: <20090121113443.GA1579@uranus.ravnborg.org>
References: <1232273454.23100.9.camel@localhost.localdomain> <20090118110221.GA29602@elte.hu> <1232501276.3123.49.camel@localhost.localdomain> <20090121055356.GA26731@uranus.ravnborg.org> <20090121082125.GW30821@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090121082125.GW30821@kernel.dk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2009 at 09:21:25AM +0100, Jens Axboe wrote:
> On Wed, Jan 21 2009, Sam Ravnborg wrote:
> > Hi Jens.
> > 
> > In an attempt to fix some of the issues in our exported Headers jsr
> > encountered some strange stuff in types.h.
> > 
> > types.h is exported to userspace where we do not have access to CONFIG_*
> > symbols.
> > Despite this we use CONFGI_LBD to decide the size of sector_t like this:
> > 
> > #ifdef CONFIG_LBD
> > typedef u64 sector_t;
> > typedef u64 blkcnt_t;
> > #else
> > typedef unsigned long sector_t;
> > typedef unsigned long blkcnt_t;
> > #endif
> > 
> > But as CONFIG_LBD is never defined in userspace sector_t is now 32
> > bit on 32 bit boxes and 64 bit on 64 bit boxes (in userspace).
> > 
> > Is sector:t (and the companion blkcnt_t) really used by userspace?
> > If it is - what size is it expected to have?
> 
> I don't think it's used by userspace, at least it cannot be used in
> userspace <-> kernelspace interactions, since the size isn't fixed.

Thanks Jens.

In that case I suggest we should make it private to the kernel.
We should not expose types from the kernel that is not used
in the kerenl.

Jaswinder - move it inside a ifdef __KERNEL__ / endif block.
Reference Jens' answer above and Cc: Jens on the patch.

Thanks,
	Sam
