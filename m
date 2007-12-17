Return-Path: <linux-kernel-owner+w=401wt.eu-S933309AbXLQUNl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933309AbXLQUNl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 15:13:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935021AbXLQTvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 14:51:42 -0500
Received: from nz-out-0506.google.com ([64.233.162.233]:51795 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934963AbXLQTvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 14:51:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=A+/o818vIgEZG/Hwp7yivtsTBDrh1IHPA276ilWtXNkbSnnR7bzFPUsN2hyoMl770EEBDo57pGiYW4cMYvlsm1ESLcKJyABWWHd1gCd7E6bMwd04ra0ZF9joKH8G2r/nwqPBNnoxFLzIXi5YZ2gmyi6pt9e8JHbElC3qMuFzWZk=
Message-ID: <84144f020712171151j5e2a2934qc8bf2fbc9020a545@mail.gmail.com>
Date: Mon, 17 Dec 2007 21:51:33 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "John Reiser" <jreiser@bitwagon.com>
Subject: Re: slab quirks in DEBUG, ctor, and initialization
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <47669A16.3010604@BitWagon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47669A16.3010604@BitWagon.com>
X-Google-Sender-Auth: e6e56aef41637c40
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

On Dec 17, 2007 5:47 PM, John Reiser <jreiser@bitwagon.com> wrote:
> In mm/slab.c, the DEBUG variant of cache_alloc_debugcheck_after
> might call  cachep->ctor(objp, cachep, 0);  but the non-DEBUG
> variant does absolutely nothing.  idr_pre_get is a routine
> which notices the difference.

How does ipr_pre_get notice this?

On Dec 17, 2007 5:47 PM, John Reiser <jreiser@bitwagon.com> wrote:
> Even when cache_alloc_debugcheck_after does invoke the ctor,
> then it is conditional upon  cachep->flags & SLAB_POISON.  This
> assumes that the only two states are poisoned and all-zero
> (from .bss static, or via a cleared new page frame.)
> So if SLAB_POISON is not specified, then a ctor which
> does anything other than memset(,0,) is out of luck.
> Instead: if a ctor is specified then it should be called
> for each successful allocation.

Sorry, I don't understand at all what's the problem is here. For the
common (non-poison) case, we initialize all objects *once* whenever a
cache is grown (see cache_grow calling cache_init_objs) which is the
whole point of having constructors. When poisoning is enabled, we
obviously cannot do this which is why we call the constructor for
every allocation.

                                Pekka
