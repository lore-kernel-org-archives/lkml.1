Return-Path: <linux-kernel-owner+w=401wt.eu-S1756653AbXKKPu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653AbXKKPu3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 10:50:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754212AbXKKPuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 10:50:21 -0500
Received: from mx1.suse.de ([195.135.220.2]:43279 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754160AbXKKPuU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 10:50:20 -0500
From: Andi Kleen <ak@suse.de>
To: Adrian Bunk <bunk@kernel.org>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 1/6] Suppress A.OUT library support if !CONFIG_BINFMT_AOUT [try #5]
Date: Sun, 11 Nov 2007 16:46:26 +0100
User-Agent: KMail/1.9.1
Cc: David Howells <dhowells@redhat.com>, torvalds@osdl.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-am33-list@redhat.com
References: <20071111142205.GO21669@stusta.de> <1701.1194793436@redhat.com> <20071111151951.GP21669@stusta.de>
In-Reply-To: <20071111151951.GP21669@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711111646.27496.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> My thoughts go more into the direction that we have hundreds of similar
> cases where e.g. a VFS function might currently only by used by OCFS2
> and therefore be dead code for most users, and the only maintainable
> solution will be to solve these at the compiler and/or linker level.

 -ffunction-sections can mostly do it, but only for non modular kernels

One problem is that EXPORT_SYMBOL always creates a reference to the function
even when nothing uses it.

We would need a weak EXPORT_SYMBOL and some way to check references
over main kernel and modules. I suppose it could be done as part of modpost
and then generating a custom linker script that only includes the function
sections referenced by anybody. But to make this work it would require
putting all the EXPORT_SYMBOLs into own sections too, but I suppose
that would be possible.

In the past we had trouble that the explicit linker scripts mentioning every 
function section made the linker very slow, but perhaps that's fixed now.

The whole thing would likely made a lot of out of tree modules unhappy
though. Distribution kernels might need to turn it off generally because of 
that. 

The question is if it would be still have a large enough user base without the 
distribution kernels. If it would be only used by a few users I don't think 
the maintenance overhead would be worth it.

> Andi scheduled it for removal, and I don't know whether he already has a
> patch.

I don't have a patch yet, but I can submit one for -mm* if it's helpful.
It's not very difficult.

-Andi
