Return-Path: <linux-kernel-owner+w=401wt.eu-S1753878AbXFOL4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878AbXFOL4v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 07:56:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752449AbXFOL4n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 07:56:43 -0400
Received: from mx2.suse.de ([195.135.220.15]:42087 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752407AbXFOL4m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 07:56:42 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] Introduce compat_u64 and compat_s64 types
Date: Fri, 15 Jun 2007 13:55:57 +0200
User-Agent: KMail/1.9.6
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Airlie <airlied@linux.ie>, linux-arch@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
References: <200706150159.l5F1xNgM000459@hera.kernel.org> <200706151128.39566.arnd@arndb.de> <200706151131.38429.arnd@arndb.de>
In-Reply-To: <200706151131.38429.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706151355.57464.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 June 2007 11:31:37 Arnd Bergmann wrote:
> One common problem with 32 bit system call and ioctl emulation
> is the different alignment rules between i386 and 64 bit machines.
> A number of drivers work around this by marking the compat
> structures as 'attribute((packed))', which is not the right
> solution because it breaks all the non-x86 architectures that
> want to use the same compat code.

Why does it break them? It should just make them a little slower.

The network code requires unaligned accesses to work
anyways so if your architecture doesn't support them it is already
remotely crashable.

-Andi

