Return-Path: <linux-kernel-owner+w=401wt.eu-S1756503AbZDUBEa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756503AbZDUBEa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 21:04:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752603AbZDUBEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 21:04:21 -0400
Received: from mail-bw0-f163.google.com ([209.85.218.163]:51252 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597AbZDUBEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 21:04:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=CzG+KbU66wgeM5JSg6lLBRzMLcxmTLSiQjW5RnyS477Olc3MCOAs9YukAEPnRuYAOz
         yvuaqW/WEHOj9PDw6pHhF5SRmKVwK+G2nxQCjI7YpCuS/Em8+AWA6xJu0rBAkou8TbgS
         vgL3b5Rq2v8b3+BrKMdhg3aJYVU9xNMovQl+0=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v2 0/4] Add support for compiling with -ffunction-sections -fdata-sections
Date: Tue, 21 Apr 2009 03:05:03 +0200
User-Agent: KMail/1.8.2
Cc: Tim Abbott <tabbott@mit.edu>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@mit.edu>, Waseem Daher <wdaher@mit.edu>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <andi@firstfloor.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Jeff Arnold <jbarnold@mit.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jon Masters <jonathan@jonmasters.org>
References: <1238973278-31735-1-git-send-email-tabbott@mit.edu> <alpine.DEB.1.10.0904201255080.30705@vinegar-pot.mit.edu> <alpine.LFD.2.00.0904201637280.2199@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0904201637280.2199@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904210305.03933.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 21 April 2009 01:40, Linus Torvalds wrote:
> Quite frankly, every time I see something like this, I shudder.
> 
> Why?
> 
> The bugs in the toolchains tend to be infinite and _really_ annoying. 

Most bugs are annoying. :)

> We'll end up with everything from "gcc-xyz cannot handle it" to 
> "binutils-abc which was pre-released by RH/Ubuntu/SUSE will SIGSEGV". 
> 
> And those are the _good_ cases. The bad cases are just silently 
> miscompiled/linked stuff under certain circumstances.
> 
> In other words, I'm not going to merge it without a _lot_ of people 
> pushing me on it with nice numbers etc. Because I absolutely hate the 
> tools issues that I'm convinced will happen the moment I merge it.

In some cases, section garbage collection discards nearly 10% of dead
code/data from kernel image. Actually, every time I add it to
a software project, I see quite an amount of dead code/data
eliminated. Even sadistic manual splitting of every function
and data object into its own .o file doesn't match it.

I can put it another way: let machine do what it does better,
and faster, than humans ever can:

I was pushing a patch for aic7xxx driver which eliminated ~150k
of dead code. It took a lot of time to eventually make it reach
mainline kernel. On and off, it took years.

With section garbage collection, that patch would not be even needed,
as gcc+ld would automagically detect that that code is dead.
--
vda
