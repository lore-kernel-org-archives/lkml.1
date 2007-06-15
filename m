Return-Path: <linux-kernel-owner+w=401wt.eu-S1756685AbXFON2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685AbXFON2a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 09:28:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754877AbXFON2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 09:28:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47096 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754810AbXFON2F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 09:28:05 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Introduce compat_u64 and compat_s64 types
Date: Fri, 15 Jun 2007 15:27:44 +0200
User-Agent: KMail/1.9.6
Cc: David Howells <dhowells@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Airlie <airlied@linux.ie>, linux-arch@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
References: <200706151355.57464.ak@suse.de> <200706151454.28854.ak@suse.de> <20070615141544.5a8e234e@the-village.bc.nu>
In-Reply-To: <20070615141544.5a8e234e@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706151527.45143.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> And debug simulators that can be made to trap such accesses, and in most
> cases processors which fault such an access (so you find it) but don't
> provide enough information to restart.
> 
> The testing isn't that hard for a given embedded system and having done
> work Linux does not need other changes re-breaking things.

Hopefully everybody who deploys these systems knows this. It seems
like a open death trap to me, especially since the consequences
are so severe: remote packet of death, could be a recall for 
a network conntected embedded device that doesn't easily allow firmware 
update. And they would rightfully blame Linux.

It would be much safer if the parts of the stack that weren't
audited/tested were marked this way and check for BROKEN_UNALIGNED or similar.

Also frankly I'm surprised that whoever designed these systems
didn't learn from the old M68000 who made this mistake the first time.

-Andi
