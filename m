Return-Path: <linux-kernel-owner+w=401wt.eu-S936992AbYEVBaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936992AbYEVBaw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 21:30:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755577AbYEVBai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 21:30:38 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:51951 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758383AbYEVBai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 21:30:38 -0400
Date: Thu, 22 May 2008 02:30:35 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul Mackerras <paulus@samba.org>, Takashi Iwai <tiwai@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: Moving include/asm-* [was: Re: Moving sound/* to drivers/ ?]
Message-ID: <20080522013035.GV28946@ZenIV.linux.org.uk>
References: <s5hzlqjz74d.wl%tiwai@suse.de> <alpine.LFD.1.10.0805211431370.3081@woody.linux-foundation.org> <18484.44691.477859.334222@cargo.ozlabs.ibm.com> <alpine.LFD.1.10.0805211635040.3081@woody.linux-foundation.org> <20080522005657.GU28946@ZenIV.linux.org.uk> <alpine.LFD.1.10.0805211818550.3081@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805211818550.3081@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 06:20:27PM -0700, Linus Torvalds wrote:
> 
> 
> On Thu, 22 May 2008, Al Viro wrote:
> > 
> > Eh?  git mv include/asm-$i arch/$i/include/asm, then?
> 
> Yeah, sorry, I dropped an "include/" there. 
> 
> > Nice, but... how do you pull what's currently asm-generic/foo.h from what's
> > currently asm-bar/foo.h?  #include_next is _ugly_...
> 
> I was actually going to suggest #include_next, yes. But if people hate it, 
> we can certainly just keep the current <asm-generic/xyz.h> approach.

Another alternative is to replace asm-generic/ with generic/asm and have
-I include -I arch/$ARCH/include -I include/generic. Then we'd have

linux/foo.h => include/linux/foo.h (one lookup)
asm/foo.h => arch/include/asm/foo.h if it exists (negative on include/asm,
                                                  then one lookup)
          => include/generic/asm/foo.h otherwise (negative on include/asm,
                                                  negative lookup,
                                                  lookup)
generic/asm/foo.h => include/generic/asm/foo.h   (one lookup)

No #include_next at all.  Kludgy, though...  Note that arch/um will need
more interesting treatment in any case and so may things like arch/arm
with its include/asm/arch symlink ;-/
