Return-Path: <linux-kernel-owner+w=401wt.eu-S1754224AbYJVIVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224AbYJVIVn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 04:21:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752167AbYJVIVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 04:21:25 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:49164 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160AbYJVIVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 04:21:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=CM2Yd4kE9BquZna6e3vzi/F66a3zgbeaR1J8WTTZG6gbQprRJeS5G1fTKyCfdg3oYn
         CdcngHVQL4aJnkhGFe+uqh8U+ffFgx/Mu5eFYFbd2h7wvQjKRcfwUfAlNpVAJ5iGi23O
         Hr0yIHf25pF2TDPkoLNljf1fkcx5KrkIKkwh8=
Message-ID: <a4423d670810220121k27ab3d1dp1921ea282786eebc@mail.gmail.com>
Date: Wed, 22 Oct 2008 12:21:23 +0400
From: "Alexander Beregalov" <a.beregalov@gmail.com>
To: "Dave Chinner" <david@fromorbit.com>, lachlan@sgi.com,
       "Christoph Hellwig" <hch@infradead.org>,
       "Arjan van de Ven" <arjan@infradead.org>, xfs@oss.sgi.com,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: BUG: sleeping function called from invalid context at kernel/rwsem.c:131 XFS? (was: Re: linux-next: Tree for October 17)
In-Reply-To: <20081022075838.GK18495@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a4423d670810170954h7ca130aaw8895380a4c6b125@mail.gmail.com>
	 <a4423d670810171013g5bc19c1cm3f7d9c014ee70349@mail.gmail.com>
	 <20081017203710.GA27187@infradead.org>
	 <20081017135510.7127c4e7@infradead.org>
	 <a4423d670810200758m3cea3841h40988afc8eaf81@mail.gmail.com>
	 <20081020163327.GA15651@infradead.org>
	 <a4423d670810201013w6448cb38w402771799cefb5f5@mail.gmail.com>
	 <20081020223549.GA21152@disturbed>
	 <a4423d670810210442y51b62fc2naf6cb649e6b26942@mail.gmail.com>
	 <20081022075838.GK18495@disturbed>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Ah, OK, I see the problem, though I don't understand why I'm not
> seeing the might_sleep() triggering all the time given that I always
> build with:
>
> $ grep SLEEP .config
> CONFIG_DEBUG_SPINLOCK_SLEEP=y
>
> Basically the above commit moved xfs_ilock() inside
> radix_tree_preload()/radix_tree_preload_end(), which means we are
> taking a rwsem() while we have an elevated preempt count. I'll
> get a patch out to fix it.
Could it cause the I/O dead lock or should I continue trying to reproduce it?
