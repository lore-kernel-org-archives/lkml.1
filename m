Return-Path: <linux-kernel-owner+w=401wt.eu-S1759311AbYDCA6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759311AbYDCA6g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 20:58:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753162AbYDCA61
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 20:58:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44317 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751886AbYDCA61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 20:58:27 -0400
Date: Wed, 2 Apr 2008 17:57:54 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
cc: Al Viro <viro@ZenIV.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/7] asm-generic: suppress sparse warning in ioctl.h
In-Reply-To: <1207182818.5740.26.camel@brick>
Message-ID: <alpine.LFD.1.00.0804021752040.14670@woody.linux-foundation.org>
References: <1207182818.5740.26.camel@brick>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 2 Apr 2008, Harvey Harrison wrote:
>
> 1 ? 0 : x
> 
> is not valid in contexts where C requires integer constant expressions.
> Index in static array initializer is one of those.

So I don't much like this one, because (a) we could just make sparse 
accept it and (b) gcc _does_ accept it and gives us nicer error messages. 

Well, maybe "nicer" is wrong (because it's a link-time one), but at least 
not a _totally_ misleading one.

What does "division by zero" mean as an error message? Also, if I recall 
correctly, last time we tried something like this (admittedly long ago), 
some compilers would actually make it a run-time error, not a compile-time 
one - it would simply refuse optimize the 1/0 into a value at all, and 
just generate a run-time divide.

So I'm not even sure that all versions of gcc will even complain at all 
(although it might have been icc).

			Linus
