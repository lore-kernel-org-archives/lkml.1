Return-Path: <linux-kernel-owner+w=401wt.eu-S933695AbYEVA5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933695AbYEVA5S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 20:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754787AbYEVA5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 20:57:08 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48790 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753675AbYEVA5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 20:57:07 -0400
Date: Thu, 22 May 2008 01:56:57 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul Mackerras <paulus@samba.org>, Takashi Iwai <tiwai@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: Moving include/asm-* [was: Re: Moving sound/* to drivers/ ?]
Message-ID: <20080522005657.GU28946@ZenIV.linux.org.uk>
References: <s5hzlqjz74d.wl%tiwai@suse.de> <alpine.LFD.1.10.0805211431370.3081@woody.linux-foundation.org> <18484.44691.477859.334222@cargo.ozlabs.ibm.com> <alpine.LFD.1.10.0805211635040.3081@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805211635040.3081@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 04:51:57PM -0700, Linus Torvalds wrote:

> So the trivial alternative is to just do
> 
> 	git mv include/asm-xyz arch/xyz/include

Careful - arch/um/include/ exists, so that'll get interesting.

> But the alternative I'd actually *prefer* would avoid the symlink, and 
> would be roughly:
> 
> 	for i in $(arch-list)
> 	do
> 		mkdir arch/$i/include
> 		git mv include/asm-$i arch/$i/asm
> 		
> 	done
> 	git mv include/asm-generic include/asm
> 
> and then remove the symlink to asm entirely, and instead add a 
> -Iarch/xyz/include, and put that as the *first* entry in the include path.

Eh?  git mv include/asm-$i arch/$i/include/asm, then?

> This would mean that:
> 
>  - no symlink games
> 
>  - if some architecture just uses the generic header file, it doesn't need 
>    to do anything: it just wouldn't implement that header file at all, and 
>    the next entry in the search-path would just find the generic 
>    include/asm entry.

Nice, but... how do you pull what's currently asm-generic/foo.h from what's
currently asm-bar/foo.h?  #include_next is _ugly_...
