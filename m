Return-Path: <linux-kernel-owner+w=401wt.eu-S1754256AbYKZOCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256AbYKZOCQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 09:02:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752447AbYKZOCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 09:02:00 -0500
Received: from one.firstfloor.org ([213.235.205.2]:47509 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776AbYKZOCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 09:02:00 -0500
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, mpm@selenic.com, akpm@linux-foundation.org
Subject: Re: [PATCH] random: add a way to get some random bits into the entropy pools early on
From: Andi Kleen <andi@firstfloor.org>
References: <20081125132600.5112fb24@infradead.org>
Date: Wed, 26 Nov 2008 15:02:02 +0100
In-Reply-To: <20081125132600.5112fb24@infradead.org> (Arjan van de Ven's message of "Tue, 25 Nov 2008 13:26:00 -0800")
Message-ID: <878wr6d1r9.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven <arjan@infradead.org> writes:

> From 5b3b09ac82316c2d4000460d586ebe59303c12c2 Mon Sep 17 00:00:00 2001
> From: Arjan van de Ven <arjan@linux.intel.com>
> Date: Tue, 25 Nov 2008 11:41:37 -0800
> Subject: [PATCH] random: add a way to get some random bits into the entropy pools early on
>
> currently the entropy pool gets seeded on the module_init() level, but there
> is at least one consumer of random bits (the oops ID that is printed as part
> of the oops).
> As a result of this, kerneloops.org is seeing a lot of oopses that all share
> the same 'random' number; which used to get filed away as "duplicate".

This should also help networking, which also relies on some non existant
randomness early on currently.

But I think i would prefer to move the complete random initialization
earlier instead of having special case calls for this.

Feeding in DMI and some other system data and perhaps
some other register values would be also a good idea.
The utsname initialization that is currently in there I always found
amusing because there is no way utsname is set that early.

-Andi

-- 
ak@linux.intel.com
