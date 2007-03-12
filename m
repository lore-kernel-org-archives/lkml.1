Return-Path: <linux-kernel-owner+w=401wt.eu-S1751653AbXCLSnF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751653AbXCLSnF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 14:43:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751704AbXCLSnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 14:43:05 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:55093 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653AbXCLSnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 14:43:02 -0400
Subject: Re: [RFC][PATCH 2/7] RSS controller core
From: Dave Hansen <hansendc@us.ibm.com>
To: Herbert Poetzl <herbert@13thfloor.at>
Cc: Andrew Morton <akpm@linux-foundation.org>, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org, menage@google.com, xemul@sw.ru
In-Reply-To: <20070312010039.GC21861@MAIL.13thfloor.at>
References: <45ED7DEC.7010403@sw.ru> <45ED80E1.7030406@sw.ru>
	 <20070306140036.4e85bd2f.akpm@linux-foundation.org>
	 <45F3F581.9030503@sw.ru>
	 <20070311045111.62d3e9f9.akpm@linux-foundation.org>
	 <20070312010039.GC21861@MAIL.13thfloor.at>
Content-Type: text/plain
Date: Mon, 12 Mar 2007 11:42:59 -0700
Message-Id: <1173724979.11945.103.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

How about we drill down on these a bit more.

On Mon, 2007-03-12 at 02:00 +0100, Herbert Poetzl wrote:
>  - shared mappings of 'shared' files (binaries 
>    and libraries) to allow for reduced memory
>    footprint when N identical guests are running

So, it sounds like this can be phrased as a requirement like:

	"Guests must be able to share pages."

Can you give us an idea why this is so?  On a typical vserver system,
how much memory would be lost if guests were not permitted to share
pages like this?  How much does this decrease the density of vservers?

>  - virtual 'physical' limit should not cause
>    swap out when there are still pages left on
>    the host system (but pages of over limit guests
>    can be preferred for swapping)

Is this a really hard requirement?  It seems a bit fluffy to me.  An
added bonus if we can do it, but certainly not the most important
requirement in the bunch.

What are the consequences if this isn't done?  Doesn't a loaded system
eventually have all of its pages used anyway, so won't this always be a
temporary situation?

This also seems potentially harmful if we aren't able to get pages
*back* that we've given to a guest.  Tasks can pin pages in lots of
creative ways.

>  - accounting and limits have to be consistent
>    and should roughly represent the actual used
>    memory/swap (modulo optimizations, I can go
>    into detail here, if necessary)

So, consistency is important, but is precision?  If we, for instance,
used one of the hashing schemes, we could have some imprecise decisions
made but the system would stay consistent overall.

This requirement also doesn't seem to push us in the direction of having
distinct page owners, or some sharing mechanism, because both would be
consistent.

>  - OOM handling on a per guest basis, i.e. some
>    out of memory condition in guest A must not
>    affect guest B

I'll agree that this one is important and well stated as-is.  Any
disagreement on this one?

-- Dave

