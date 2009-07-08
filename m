Return-Path: <linux-kernel-owner+w=401wt.eu-S1755835AbZGHAqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835AbZGHAqR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 20:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753824AbZGHAqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 20:46:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55234 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607AbZGHAqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 20:46:05 -0400
Message-ID: <4A53EC4A.1000403@zytor.com>
Date: Tue, 07 Jul 2009 17:46:02 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: "John A. Gregor" <john.gregor@qlogic.com>
CC: ralph.campbell@qlogic.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86_64/__iowrite32_copy: don't use string move for PIO
 writes
References: <1246907224-22758-1-git-send-email-john.gregor@qlogic.com> <4A526CE6.30200@zytor.com> <4a526e77.IPiyTZWRWfll2+00%john.gregor@qlogic.com> <4A527EE4.1080102@zytor.com> <4a528c40.zpEvWzPTM5aCPBai%john.gregor@qlogic.com> <4A5290C5.5040905@zytor.com> <4a537279./HlkzM7mavpN0Wx2%john.gregor@qlogic.com>
In-Reply-To: <4a537279./HlkzM7mavpN0Wx2%john.gregor@qlogic.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John A. Gregor wrote:
> 
> Anyway, we're very likely going to have to stick with asm for X86_64 no
> matter how it gets implemented both for performance and as protection
> against the compiler generating a rep movs sequence.
> 
> So, I see at least a couple possible courses of action:
> 
> 1. Redefine __iowrite32_copy(), document it better, and take the
>    new asm.
> 2. Delete the .S file, warn about the possibility of the compiler
>    generating a rep movs sequence in the C code, and the ipath driver
>    will have a private copy routine again.
> 

I discussed this with H.J. Lu (x86 gcc maintainer), and he stated rather
unequivocally that gcc will not generate string instructions for a
volatile store, and that the gcc team considers that part of the
definition for volatile.  So the C version is guaranteed to be good; we
should just remove the assembly version.

Redefining a public API -- no matter if you were the original authors --
is not an option.  If you need something other than __iowrite32_copy()
or __iowrite64_copy() you should define a new API or make it a private
one.  Either which way, a C implementation is guaranteed to be safe.

	-hpa
