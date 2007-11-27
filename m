Return-Path: <linux-kernel-owner+w=401wt.eu-S1754617AbXK0Byn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617AbXK0Byn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 20:54:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753467AbXK0Byg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 20:54:36 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47059 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753451AbXK0Byf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 20:54:35 -0500
Date: Mon, 26 Nov 2007 17:53:46 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Roland McGrath <roland@redhat.com>
cc: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/18] x86 vDSO: arch/x86/vdso/vdso32
In-Reply-To: <20071120232715.0803426F8BE@magilla.localdomain>
Message-ID: <alpine.LFD.0.9999.0711261745160.5869@woody.linux-foundation.org>
References: <20071119215944.01B7C26F8BE@magilla.localdomain> <20071119220425.6002E26F8BE@magilla.localdomain> <alpine.LFD.0.9999.0711201402520.25057@localhost.localdomain> <20071120205759.3533A26F8BE@magilla.localdomain> <alpine.LFD.0.9999.0711202348470.25057@localhost.localdomain>
 <20071120232715.0803426F8BE@magilla.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 20 Nov 2007, Roland McGrath wrote:
>
> > git format-patch -p
> > 
> > does the trick at least here :)
> 
> Ok, I can use that in future.  I hope it still means that in the eventual
> merged state, GIT will be aware of all the renames.

Git doesn't care. You can do renames by hand, or with "git mv", you can do 
them as a delete/create pair, you can use "git-apply" with a rename patch, 
and you can do them by re-typing in all of the file contents from scratch.

Regardless of how the rename is done, git will represent the data the 
exact same way: the state of the tree before and after. 

The rename-patches are a lot denser and a lot more readable for humans (ie 
you can actually see what *happens*, unlike a traditional stupid unified 
diff), and I was hoping that eventually somebody in the GNU patch 
community would see how wonderful the extended patch information is, but 
when I tried to write a patch to "patch" to do it, I almost dug out my 
eyes with spoons from looking at the source code, so I haven't actually 
helped it happen.

So you can ask for patches in traditional format (*most* git command lines 
will default to that anyway, and only give a copy-patch with -C or -M on 
the command line), or people could realize that "git-apply" actually works 
even on non-git source code, and just stop using that abomination that is 
"patch" with all of it's totally wrong and unsafe defaults (*).

But whatever works. I'm currently skipping the patches since they didn't 
seem like 2.6.24 fodder anyway.

			Linus

(*) Let me count the ways: applying patches partially when it fails 
half-way through a series. Defaulting to totally randomly guessing the 
path-name skip depth when not explicitly given a -pX option. Defaulting to 
"--fuzz=2" which is almost guaranteed to apply a patch even when it makes 
no sense what-so-ever. Yes, git-apply has stricter rules, but they are 
stricter for damn good reasons. For people who want the insane unsafe GNU 
patch defaults, they just have to specifically ask for unsafe modes..
