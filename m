Return-Path: <linux-kernel-owner+w=401wt.eu-S1753103AbZEQOoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103AbZEQOoZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 10:44:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750885AbZEQOoQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 10:44:16 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:36775 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829AbZEQOoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 10:44:15 -0400
Date: Sun, 17 May 2009 15:43:14 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andi Kleen <ak@linux.intel.com>, Ian Campbell <ian.campbell@citrix.com>,
       Jakub Jelinek <jakub@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesper Nilsson <jesper.nilsson@axis.com>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Fix print out of function which called WARN_ON()
In-Reply-To: <alpine.LFD.2.01.0905161342150.3301@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0905171536470.23834@blonde.anvils>
References: <1242404236-17624-1-git-send-email-ian.campbell@citrix.com>
 <alpine.LFD.2.01.0905151018370.3343@localhost.localdomain>
 <4A0DC797.7040502@linux.intel.com> <alpine.LFD.2.01.0905161342150.3301@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 May 2009, Linus Torvalds wrote:
> 
> This patch not only avoids the warnings and gets the right caller 
> information, it cleans up the code too:
> 
>  - it uses '%pS' instead of of sprint_symbol

> -	char function[KSYM_SYMBOL_LEN];

This should be a big improvement, because that buffer on the stack
was netting lots of stale return addresses, printed out with ?s in
the warning's dump_stack().  I had been wanting to add a memset,
but your %pS should circumvent the need for that nicely.

Hugh
