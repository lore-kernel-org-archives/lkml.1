Return-Path: <linux-kernel-owner+w=401wt.eu-S936613AbYEBWdq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936613AbYEBWdq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 18:33:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762619AbYEBWdj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 18:33:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45168 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758887AbYEBWdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 18:33:38 -0400
Date: Fri, 2 May 2008 15:33:06 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: "Carlos R. Mafra" <crmafra@ift.unesp.br>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/time.c: Silence gcc warning 'integer constant to
 large for long type'
In-Reply-To: <alpine.LFD.1.10.0805021515120.5994@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0805021528080.5994@woody.linux-foundation.org>
References: <200805021858.m42Iw4Lj025952@tazenda.hos.anvin.org> <alpine.LFD.1.10.0805021407030.5994@woody.linux-foundation.org> <481B888F.3070302@zytor.com> <alpine.LFD.1.10.0805021515120.5994@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 2 May 2008, Linus Torvalds wrote:
> 
> The thing is, if C code needs to do
> 
> 	U64_C(HZ_TO_USEC_MUL32)
> 
> to use the macro HZ_TO_USEC_MUL32, then that is a *bug* in the macro.

Ok, it seems worse than that. I don't see the point of that U64_C thing at 
all.

Those macros are only used in C code. 

The values should have the right C types already (ie "ull" at the end of 
big constants to make sure we don't trigger warnings). And no, we do NOT 
want to have 5 different macro names for five different versions of the 
same macro. That's just insane.

Make the timeconst.h file just contain sane macros. No preprocessor games 
etc. Just make it say

	#define USEC_TO_HZ_MUL32 ..correct-value-here..

and not even generate macros with values that cannot be used (ie >64 
bits).

		Linus
