Return-Path: <linux-kernel-owner+w=401wt.eu-S1755697AbYEVQ2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755697AbYEVQ2l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 12:28:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753274AbYEVQ2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 12:28:33 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:60630 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753210AbYEVQ2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 12:28:33 -0400
Date: Thu, 22 May 2008 12:27:31 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Paul Mackerras <paulus@samba.org>, Takashi Iwai <tiwai@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: Moving include/asm-* [was: Re: Moving sound/* to drivers/ ?]
Message-ID: <20080522162731.GB9500@c2.user-mode-linux.org>
References: <s5hzlqjz74d.wl%tiwai@suse.de> <alpine.LFD.1.10.0805211431370.3081@woody.linux-foundation.org> <18484.44691.477859.334222@cargo.ozlabs.ibm.com> <alpine.LFD.1.10.0805211635040.3081@woody.linux-foundation.org> <20080522005657.GU28946@ZenIV.linux.org.uk> <alpine.LFD.1.10.0805211818550.3081@woody.linux-foundation.org> <1211419419.6908.12.camel@brick> <alpine.LFD.1.10.0805211827010.3081@woody.linux-foundation.org> <20080522042059.GA17173@c2.user-mode-linux.org> <20080522052607.GY28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080522052607.GY28946@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2008 at 06:26:07AM +0100, Al Viro wrote:
> It's a bit worse, though - there is target-dependent stuff in arch/um/include
> *and* in include/asm-um; the latter is done in a very painful way - see
> include/asm-um/module-i386.h and include/asm-um/module-x86_64.h, etc. and
> logics that creates a symlink for each of those.
> 
> Is there any reason why module.h is not simply
> 
> #include <sysdep/module.h>
> 
> with these suckers sitting in arch/um/include/sysdep-{i386,x86_64}/ resp.?

My thinking was that include/asm-um is for stuff that's visible to the
rest of the kernel and arch/um/include is for UML-internal stuff.

Your patch does simplify things somewhat, though.

Would you consider a include/asm-um/$(ARCH) containing all the
foo-$(ARCH) headers to be worse than moving them to
arch/um/include/sysdep-$(ARCH)?

				Jeff

-- 
Work email - jdike at linux dot intel dot com
