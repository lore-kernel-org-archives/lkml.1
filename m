Return-Path: <linux-kernel-owner+w=401wt.eu-S935198AbZJORT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935198AbZJORT3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 13:19:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758630AbZJORT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 13:19:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57073 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758602AbZJORT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 13:19:27 -0400
Message-ID: <4AD75920.8000303@zytor.com>
Date: Thu, 15 Oct 2009 10:17:20 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Sam Ravnborg <sam@ravnborg.org>, Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Ian Lance Taylor <iant@google.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] x86: linker script syntax nits
References: <20091014221024.EFA79E2F@magilla.sf.frob.com> <20091015033010.GB10068@merkur.ravnborg.org> <20091015063837.GA11645@elte.hu>
In-Reply-To: <20091015063837.GA11645@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2009 11:38 PM, Ingo Molnar wrote:
> 
> We could introduce a COMPAT_ASSERT() wrapper perhaps, to move it more in 
> line with the 'official' syntax.
> 
> Or we could wrap ASSERT() itself (this runs through the preprocessor 
> before going to the linker) - although that would be a pretty obfuscated 
> move.
> 
> At minimum we should add a comment to the first use of ASSERT() here 
> that we assign the current address due to compatibility reasons. (same 
> goes for arch/x86/boot/setup.ld)
> 
> Anyway - any such cleanup would be .33 material.
> 

The tricky part about wrapping ASSERT() is that you have to have a sink
for the old versions of ld.  We use . as the sink, but that changes .
which you don't want to do silently.

The other -- and somewhat less cantankerous way -- is to use a dummy symbol:

#define LINUX_ASSERT(expr, name, string) name = ASSERT(expr, string)

"name" would have to be unique for each instance.

	-hpa
