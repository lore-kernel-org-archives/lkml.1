Return-Path: <linux-kernel-owner+w=401wt.eu-S935910AbYEVBgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935910AbYEVBgW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 21:36:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759006AbYEVBgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 21:36:12 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54334 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758216AbYEVBgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 21:36:11 -0400
Date: Thu, 22 May 2008 02:36:08 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Paul Mackerras <paulus@samba.org>, Takashi Iwai <tiwai@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: Moving include/asm-* [was: Re: Moving sound/* to drivers/ ?]
Message-ID: <20080522013608.GW28946@ZenIV.linux.org.uk>
References: <s5hzlqjz74d.wl%tiwai@suse.de> <alpine.LFD.1.10.0805211431370.3081@woody.linux-foundation.org> <18484.44691.477859.334222@cargo.ozlabs.ibm.com> <alpine.LFD.1.10.0805211635040.3081@woody.linux-foundation.org> <20080522005657.GU28946@ZenIV.linux.org.uk> <alpine.LFD.1.10.0805211818550.3081@woody.linux-foundation.org> <1211419419.6908.12.camel@brick> <alpine.LFD.1.10.0805211827010.3081@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805211827010.3081@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 06:29:43PM -0700, Linus Torvalds wrote:
> 
> 
> On Wed, 21 May 2008, Harvey Harrison wrote:
> > 
> > What about say, sparc64 that has a lot of #include <asm-sparc/foo.h>
> 
> Ahh, I didn't realize people did that.
> 
> I assume (but am too lazy to check) that UML probably does something 
> similar for its arch-specific stuff.

arch/um/include/*.h
arch/um/include/sysdep-<target>/*.h
include/asm-um/*.h

plus

arch/um/include/sysdep -> sysdep-<target>
and
include/asm-um/arch -> ../asm-<target>

Note that uml has two halves - kernel-side and userland-side.  The latter
is build with host search path, etc., with addition of arch/um/include.
The former is normal kernel code, with addition of arch/um/include again.
So some things in that sucker are for kernel-side and some - for userland
side...
