Return-Path: <linux-kernel-owner+w=401wt.eu-S1752861AbZGTSVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861AbZGTSVl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 14:21:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751544AbZGTSVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 14:21:41 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:48696 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbZGTSVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 14:21:40 -0400
Date: Mon, 20 Jul 2009 20:21:39 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Damien Wyart <damien.wyart@free.fr>, Greg KH <gregkh@suse.de>,
       Wolfgang Walter <wolfgang.walter@stwm.de>, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.30.2: does not boot
Message-ID: <20090720182139.GA6784@merkur.ravnborg.org>
References: <20090720040813.GC11940@kroah.com> <200907201613.22483.wolfgang.walter@stwm.de> <20090720150916.GB10015@suse.de> <20090720180333.GA2905@brouette> <alpine.LFD.2.01.0907201110390.13838@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0907201110390.13838@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 20, 2009 at 11:16:17AM -0700, Linus Torvalds wrote:
> 
> 
> On Mon, 20 Jul 2009, Damien Wyart wrote:
> > 
> > I am seeing a similar problem (no hang but an immediate reboot) on the
> > same distro. I tried to bisect but got no good kernel in the end.
> > 
> > To clarify things I recompiled again 2.6.30.1 with the orginial .config
> > and it also failed to boot (I was happy to have renamed it so the
> > working kernel was still available). I suspected a recent gcc 4.3
> > upgrade so downgraded gcc, but no luck, still getting the same problem.
> > So for now I am quite stuck, but there is clearly a bad problem
> > somewhere...
> 
> Hmm. So you _had_ a working self-compiled 2.6.30 kernel at some point?
> 
> One thing to look out for is that a compiler upgrade/downgrade will be 
> invisible to the kernel build system, so if you downgrade the compiler and 
> recompile, you may not actually recompile things at all.
> 
> The kernel build system _should_ notice when the build flags change, but 
> gcc versions changing under it, not so much. So you might want to do a 
> "make clean" to be sure.

The build system does notice if the build flag changes - with the
excemption that it does not care about the ordering of the build flags.

gcc version changes are not detected as long as the name of gcc stays
the same - which it does in all normal cases.

	Sam
