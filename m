Return-Path: <linux-kernel-owner+w=401wt.eu-S1761454AbYBEVcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761454AbYBEVcl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 16:32:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758202AbYBEVce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 16:32:34 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47903 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753081AbYBEVcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 16:32:33 -0500
Date: Tue, 5 Feb 2008 13:32:01 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [git pull] x86 updates
In-Reply-To: <47A8D3CF.2080608@zytor.com>
Message-ID: <alpine.LFD.1.00.0802051330240.3110@woody.linux-foundation.org>
References: <20080204161219.GA8092@elte.hu> <alpine.LFD.1.00.0802051043550.9374@woody.linux-foundation.org> <20080205192236.GA26426@uranus.ravnborg.org> <20080205210508.GA14708@elte.hu> <47A8D088.7050209@zytor.com> <20080205211854.GB27589@uranus.ravnborg.org>
 <47A8D3CF.2080608@zytor.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 5 Feb 2008, H. Peter Anvin wrote:
> 
> The difference is quite simple:
> 
> 	a		- this section occupies address space
> 	w		- this section is writable
> 	x		- this section is executable
> 	progbits	- this section has data in the file
> 
> In contrast, a nobits section is implicitly zero-filled.

Well, the real question is "what are the defaults"

> By default:
> 
> .bss 	is (aw,nobits).
> .data 	is (aw,progbits).
> .rodata	is (a,progbits).
> .text	is (ax,progbits).

But what about something like ".init.data"?

I'd assume the defaults for unrecognized segments would have to be 
something sane like (aw,progbits) (ie my patch shouldn't make any 
difference), but where do we find that out?

			Linus
