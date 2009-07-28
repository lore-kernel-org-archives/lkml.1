Return-Path: <linux-kernel-owner+w=401wt.eu-S1752872AbZG1Cwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872AbZG1Cwo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 22:52:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751984AbZG1Cwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 22:52:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36074 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751137AbZG1Cwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 22:52:43 -0400
Date: Mon, 27 Jul 2009 19:52:35 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH] mm: Make it easier to catch NULL cache names
In-Reply-To: <1248745735.30993.38.camel@pasglop>
Message-ID: <alpine.LFD.2.01.0907271951390.3186@localhost.localdomain>
References: <1248745735.30993.38.camel@pasglop>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 28 Jul 2009, Benjamin Herrenschmidt wrote:
>
> Right now, if you inadvertently pass NULL to kmem_cache_create() at boot
> time, it crashes much later after boot somewhere deep inside sysfs which
> makes it very non obvious to figure out what's going on.

Please don't do BUG_ON() when there are alternatives.

In this case, something like

	if (WARN_ON(!name))
		return NULL;

would probably have worked too.

		Linus
