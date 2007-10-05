Return-Path: <linux-kernel-owner+w=401wt.eu-S1760695AbXJEJXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760695AbXJEJXg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 05:23:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753864AbXJEJX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 05:23:29 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:42740 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbXJEJX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 05:23:28 -0400
To: a.p.zijlstra@chello.nl
CC: akpm@linux-foundation.org, miklos@szeredi.hu, wfg@mail.ustc.edu.cn,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-reply-to: <1191572520.22357.42.camel@twins> (message from Peter Zijlstra on
	Fri, 05 Oct 2007 10:22:00 +0200)
Subject: Re: [PATCH] remove throttle_vm_writeout()
References: <E1IdPla-0002Bd-00@dorka.pomaz.szeredi.hu>
	 <20071004145640.18ced770.akpm@linux-foundation.org>
	 <E1IdZLg-0002Wr-00@dorka.pomaz.szeredi.hu>
	 <20071004160941.e0c0c7e5.akpm@linux-foundation.org>
	 <E1Ida56-0002Zz-00@dorka.pomaz.szeredi.hu>
	 <20071004164801.d8478727.akpm@linux-foundation.org>
	 <E1Idanu-0002c1-00@dorka.pomaz.szeredi.hu>
	 <20071004174851.b34a3220.akpm@linux-foundation.org> <1191572520.22357.42.camel@twins>
Message-Id: <E1IdjOa-0002qg-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 05 Oct 2007 11:22:56 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> So how do we end up with more writeback pages than that? should we teach
> pdflush about these limits as well?

Ugh.

I think we should rather fix vmscan to not spin when all pages of a
zone are already under writeout.  Which is the _real_ problem,
according to Andrew.

Miklos
