Return-Path: <linux-kernel-owner+w=401wt.eu-S1757368AbXJBNpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757368AbXJBNpo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 09:45:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751845AbXJBNph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 09:45:37 -0400
Received: from ns1.suse.de ([195.135.220.2]:60111 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754169AbXJBNpg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 09:45:36 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: discuss@x86-64.org
Subject: Re: [discuss] [PATCH] Inconsistent mmap()/mremap() flags
Date: Tue, 2 Oct 2007 15:45:32 +0200
User-Agent: KMail/1.9.6
Cc: Hugh Dickins <hugh@veritas.com>, Thayne Harbaugh <thayne@c2.net>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <1190958393.5128.85.camel@phantasm.home.enterpriseandprosperity.com> <1191308772.5200.66.camel@phantasm.home.enterpriseandprosperity.com> <Pine.LNX.4.64.0710021304230.26719@blonde.wat.veritas.com>
In-Reply-To: <Pine.LNX.4.64.0710021304230.26719@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710021545.32556.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> First call mmap with a low hint address, the new size you'll be wanting
> from the mremap, PROT_NONE, MAP_ANONYMOUS, -1, 0.  Then call mremap with
> old address, old size, new size, MREMAP_MAYMOVE|MREMAP_FIXED, and new
> address as returned by the preparatory mmap.

That's racy unfortunately in a multithreaded process. They would need to loop.

-Andi

