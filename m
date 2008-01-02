Return-Path: <linux-kernel-owner+w=401wt.eu-S1757764AbYABTqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757764AbYABTqj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 14:46:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753764AbYABTqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 14:46:32 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37496 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753621AbYABTqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 14:46:31 -0500
Date: Wed, 2 Jan 2008 11:45:56 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Hugh Dickins <hugh@veritas.com>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi@firstfloor.org>, Christoph Lameter <clameter@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] procfs: provide slub's /proc/slabinfo
In-Reply-To: <alpine.LFD.1.00.0801021130210.32517@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.00.0801021143280.32517@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0801021830160.6823@blonde.wat.veritas.com> <84144f020801021109v78e06c6k10d26af0e330fc85@mail.gmail.com> <alpine.LFD.1.00.0801021130210.32517@woody.linux-foundation.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 2 Jan 2008, Linus Torvalds wrote:
> 
> Actually, I'd much rather just do this instead (on top of your patch)

Side note - and I didn't do this - this also allows you to disable 
slabinfo for those people who think it is pointless.

In particular, you could just make that

> +config SLABINFO
> +	bool
> +	depends on PROC_FS
> +	depends on SLAB || SLUB
> +	default y

Kconfig entry use something like

	bool "Enable /proc/slabinfo support"

(perhaps adding an "if EMBEDDED" at the end), and now people can decide 
whether they actually want it or not (independently of whether they use 
SLUB or SLAB or whatever). But I left it hardcoded to on, just because I'm 
not sure it's worth it.

		Linus
