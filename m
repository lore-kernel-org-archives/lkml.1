Return-Path: <linux-kernel-owner+w=401wt.eu-S932701AbZJ1ITM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932701AbZJ1ITM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 04:19:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932660AbZJ1ITK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 04:19:10 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36480 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932653AbZJ1ITH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 04:19:07 -0400
Date: Wed, 28 Oct 2009 09:19:09 +0100
From: Andi Kleen <andi@firstfloor.org>
To: David Miller <davem@davemloft.net>
Cc: andi@firstfloor.org, airlied@linux.ie, dri-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: Re: is avoiding compat ioctls possible?
Message-ID: <20091028081909.GP7744@basil.fritz.box>
References: <20091027.230450.222178419.davem@davemloft.net> <20091028.005342.60092591.davem@davemloft.net> <20091028075908.GO7744@basil.fritz.box> <20091028.011141.267473962.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091028.011141.267473962.davem@davemloft.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 28, 2009 at 01:11:41AM -0700, David Miller wrote:
> From: Andi Kleen <andi@firstfloor.org>
> Date: Wed, 28 Oct 2009 08:59:08 +0100
> 
> >>  	}
> >> -	chunk_array_ptr = (uint64_t *)(unsigned long)(cs->chunks);
> >> +#ifdef CONFIG_COMPAT
> >> +	if (is_compat_task())
> > 
> > Are the COMPAT ifdefs really needed? The compiler should optimize that
> > away anyways on non compat aware architectures, shouldn't it?
> 
> There are no non-compat is_compat_task() definitions, nor are there
> non-compat build definitions of compat_uptr_t and the assosciated
> interfaces.

That seems wrong then, better fix that too? It would be certainly better
than adding a lot of ifdefs.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
