Return-Path: <linux-kernel-owner+w=401wt.eu-S1762161AbXEQBQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762161AbXEQBQT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 21:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756382AbXEQBQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 21:16:12 -0400
Received: from terminus.zytor.com ([192.83.249.54]:56149 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755753AbXEQBQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 21:16:12 -0400
Message-ID: <464BACCC.7070504@zytor.com>
Date: Wed, 16 May 2007 18:15:56 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Christian <haveaniceday@cv-sv.de>,
       linux-kernel@vger.kernel.org, ak@suse.de
Subject: Re: 2.6.22-rc1 does not boot on VIA C3_2 cause of X86_CMPXCHG64
References: <464B9D2C.7040704@cv-sv.de> <20070517004209.GE16810@redhat.com>
In-Reply-To: <20070517004209.GE16810@redhat.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones wrote:
> 
> The C3s all have cx8, but it needs to be enabled in an MSR first.
> (See arch/i386/kernel/cpu/centaur.c , search for CX8)
> 
> Did we add code that uses cmpxchg8b before identify_cpu() gets run ?
> I've not been paying attention to .22rc (busy trying to beat .21 into shape for F7)
> so I may have missed something obvious. Andi?
> 

Andi added code to verify that we can actually execute on the processor
before protected mode (so we can still get a message out through the
BIOS.)  That code presumably doesn't know of the MSR that needs to be
touched.

That code is in assembly in Andi's version, my rewritten version has it
in C.  I should add this code.

	-hpa
