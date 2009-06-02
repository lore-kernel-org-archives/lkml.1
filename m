Return-Path: <linux-kernel-owner+w=401wt.eu-S1757398AbZFBPhR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757398AbZFBPhR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 11:37:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755498AbZFBPhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 11:37:06 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:46216 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754355AbZFBPhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 11:37:04 -0400
Date: Tue, 2 Jun 2009 11:37:01 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: "Larry H." <research@subreption.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Change ZERO_SIZE_PTR to point at unmapped space
In-Reply-To: <20090531022158.GA9033@oblivion.subreption.com>
Message-ID: <alpine.DEB.1.10.0906021130410.23962@gentwo.org>
References: <20090530192829.GK6535@oblivion.subreption.com> <alpine.LFD.2.01.0905301528540.3435@localhost.localdomain> <20090530230022.GO6535@oblivion.subreption.com> <alpine.LFD.2.01.0905301902010.3435@localhost.localdomain>
 <20090531022158.GA9033@oblivion.subreption.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 May 2009, Larry H. wrote:

> Let me provide you with a realistic scenario:
>
> 	1. foo.c network protocol implementation takes a sockopt which
> 	sets some ACME_OPTLEN value taken from userland.
>
> 	2. the length is not validated properly: it can be zero or an
> 	integer overflow / signedness issue allows it to wrap to zero.
>
> 	3. kmalloc(0) ensues, and data is copied to the pointer
> 	returned. if this is the default ZERO_SIZE_PTR*, a malicious user
> 	can mmap a page at NULL, and read data leaked from kernel memory
> 	everytime that setsockopt is issued.
> 	(*: kmalloc of zero returns ZERO_SIZE_PTR)

Cannot happen. The page at 0L is not mapped. This will cause a fault.

You are assuming the system has already been breached. Then of course all
bets are off.

> The performance impact, if any, is completely negligible. The security
> benefits of this utterly simple change well surpass the downsides.

Dont see any security benefit. If there is a way to breach security
of the kernel via mmap then please tell us and then lets fix
the problem and not engage in dealing with secondary issues.

Semantics of mmap(NULL, ...) is that the kernel selects a valid address
for you. How are you mapping something at 0L?

