Return-Path: <linux-kernel-owner+w=401wt.eu-S1758673AbYG1P50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758673AbYG1P50 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 11:57:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754180AbYG1P5S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 11:57:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49888 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751717AbYG1P5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 11:57:17 -0400
Date: Mon, 28 Jul 2008 08:53:46 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrea Righi <righi.andrea@gmail.com>
cc: akpm@linux-foundation.org, linux-mm@kvack.org, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] mm: unify pmd_free() implementation
In-Reply-To: <1217260287-13115-1-git-send-email-righi.andrea@gmail.com>
Message-ID: <alpine.LFD.1.10.0807280851130.3486@nehalem.linux-foundation.org>
References: <> <1217260287-13115-1-git-send-email-righi.andrea@gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 28 Jul 2008, Andrea Righi wrote:
>
> Move multiple definitions of pmd_free() from different include/asm-* into
> mm/util.c.

But this is horrible, because it forces a totally unnecessary function 
call for that empty function.

Yeah, the function will be cheap, but the call itself will not be (it's a 
C language barrier and basically disables optimizations around it, causing 
thigns like register spill/reload for no good reason).

		Linus
