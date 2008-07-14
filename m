Return-Path: <linux-kernel-owner+w=401wt.eu-S1755476AbYGNPEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476AbYGNPEQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 11:04:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753851AbYGNPED
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 11:04:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56450 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753466AbYGNPEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 11:04:01 -0400
Date: Mon, 14 Jul 2008 08:03:16 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Avi Kivity <avi@qumranet.com>
Subject: Re: [git pull] core, x86: make LIST_POISON less deadly
In-Reply-To: <20080714144828.GA22666@elte.hu>
Message-ID: <alpine.LFD.1.10.0807140758100.3305@woody.linux-foundation.org>
References: <20080714144828.GA22666@elte.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 14 Jul 2008, Ingo Molnar wrote:
>  
> +config ILLEGAL_POINTER_VALUE
> +       hex
> +       default 0 if X86_32
> +       default 0xffffc10000000000 if X86_64

This looks like a singularly bad pointer value on x86-64.

Why not pick something that is *guaranteed* to fault? The above looks like 
any future setup that supports 41 bits of addressing and has extended the 
page tables (yes, it will happen eventually) will find that to be a 
perfectly valid address?

It's also visually confusing, since it's visually very close to a real 
kernel pointer too.

Grr.

Why not use something sane like 0xdead000000000000, which has the high bit 
set but very fundamentally isn't a valid pointer, and never will be? And 
which is a *lot* more visually obvious too!

		Linus
