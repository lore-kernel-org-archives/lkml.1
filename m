Return-Path: <linux-kernel-owner+w=401wt.eu-S1755341AbXGUX1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341AbXGUX1t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 19:27:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751946AbXGUX1l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 19:27:41 -0400
Received: from cantor.suse.de ([195.135.220.2]:36260 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751902AbXGUX1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 19:27:40 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Oleg Verych <olecom@flower.upol.cz>
Subject: Re: [PATCH] [9/58] x86_64: Always use builtin memcpy on gcc 4.3
Date: Sun, 22 Jul 2007 01:27:35 +0200
User-Agent: KMail/1.9.6
Cc: jh@suse.cz, patches@x86-64.org, linux-kernel@vger.kernel.org
References: <200707191154.642492000@suse.de> <20070719095453.5434214E04@wotan.suse.de> <E1ICOBm-0003zf-Ms@flower>
In-Reply-To: <E1ICOBm-0003zf-Ms@flower>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707220127.35975.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 22 July 2007 01:16:42 Oleg Verych wrote:
> * From: Andi Kleen <ak@suse.de>
> * Date: Thu, 19 Jul 2007 11:54:53 +0200 (CEST)
> >
> > Jan asked to always use the builtin memcpy on gcc 4.3 mainline because
> > it should generate better code than the old macro. Let's try it.
> 
> Unfortunately such info is hard to find. The discuss@x86-64 list is
> empty. So, let me ask how this memcpy relates to recently submitted
> for glibc one [0]?

It doesn't relate at all. The kernel still uses its own memcpy.

Note that a lot of the traditional memcpy optimizations (like WC copies) 
are pointless in kernel space because the kernel rarely deals with continuous 
memory areas larger than a 4K page.

The only difference from the patch is that instead of using an own
heuristic when to use an out of line memcpy trust gcc's heuristic.

-Andi

