Return-Path: <linux-kernel-owner+w=401wt.eu-S932330AbYBNUTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932330AbYBNUTb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 15:19:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753164AbYBNUTW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 15:19:22 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:45389 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbYBNUTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 15:19:21 -0500
Message-ID: <47B4A208.7040407@cs.helsinki.fi>
Date: Thu, 14 Feb 2008 22:18:16 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.9 (Macintosh/20071031)
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Daniel Walker <dwalker@mvista.com>, Ingo Molnar <mingo@elte.hu>,
       Richard Knutsson <ricknu-0@student.ltu.se>,
       Andi Kleen <andi@firstfloor.org>, Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH 3/4] kmemcheck v4
References: <47B49DB2.2090402@gmail.com> <47B49E39.7070904@gmail.com>
In-Reply-To: <47B49E39.7070904@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vegard Nossum wrote:
>  From 4ce1c09e38b2402dc04f0246916f3c23abe8f3e1 Mon Sep 17 00:00:00 2001
> From: Vegard Nossum <vegard.nossum@gmail.com>
> Date: Thu, 14 Feb 2008 19:25:39 +0100
> Subject: [PATCH] kmemcheck: make SLUB use kmemcheck
> 
> With kmemcheck enabled, SLUB needs to do this:
> 
> 1. Request twice as much memory as would normally be needed. The bottom 
> half
>    of the memory is what the user actually sees and uses; the upper half
>    contains the so-called shadow memory, which stores the status of each 
> byte
>    in the bottom half, e.g. initialized or uninitialized.
> 2. Tell kmemcheck which parts of memory that should be marked 
> uninitialized.
>    There are actually a few more states, such as "not yet allocated" and
>    "recently freed".
> 
> If a slab cache is set up using the SLAB_NOTRACK flag, it will never return
> memory that can take page faults because of kmemcheck.
> 
> If a slab cache is NOT set up using the SLAB_NOTRACK flag, callers can 
> still
> request memory with the __GFP_NOTRACK flag. This does not prevent the page
> faults from occuring, however, but marks the object in question as being
> initialized so that no warnings will ever be produced for this object.
> 
> Signed-off-by: Vegard Nossum <vegardno@ifi.uio.no>

Looks good to me.

Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
