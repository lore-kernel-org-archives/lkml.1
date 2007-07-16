Return-Path: <linux-kernel-owner+w=401wt.eu-S932847AbXGPQaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932847AbXGPQaA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 12:30:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761441AbXGPQ3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 12:29:53 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34173 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759614AbXGPQ3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 12:29:52 -0400
Date: Mon, 16 Jul 2007 09:29:35 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Latchesar Ionkov <lucho@ionkov.net>
cc: Eric Van Hensbergen <ericvh@gmail.com>,
       V9FS Developers <v9fs-developer@lists.sourceforge.net>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [V9fs-developer] [GIT PULL] 9p Patches for 2.6.23 merge window
In-Reply-To: <f158dc670707151730w5fedb53fq11367d1e6fb14d87@mail.gmail.com>
Message-ID: <alpine.LFD.0.999.0707160919270.20061@woody.linux-foundation.org>
References: <a4e6962a0707141320p376e51fcp4b1ceb681960e303@mail.gmail.com> 
 <alpine.LFD.0.999.0707151645561.20061@woody.linux-foundation.org>
 <f158dc670707151730w5fedb53fq11367d1e6fb14d87@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 15 Jul 2007, Latchesar Ionkov wrote:
>
> I thought that it is not a good idea to keep the v9fs_ prefix for code
> that is in different places (fs/9p and net/9p). If keeping the old
> prefix is more acceptable, I can create a new patch without the
> "v9fs_"->"p9_" renames.

It's fine, I don't care *that* much, and I already pulled. If it had been 
something more central, I'd have rejected it, but soemthing as specialized 
as the Plan9 fs, I just wanted to point out that this is now how we should 
do things.

In other words: when doing renames it is generally *much* nicer to do a 
100% rename (perhaps with just _trivial_ changes to make it compile - the 
include statements etc change, and maybe you want to change the name in 
the comment header too).

Doing "move the code and change it at the same time" is considered bad 
form. Movement diffs are much harder to read anyway (a traditional diff 
will show it as a new-file + delete, of course), so the general rule is:

 - move code around _without_ modifying it, so that code movement (whether 
   it's a whole file, or just a set of functions between files) doesn't 
   really introduce any real changes, and is easier to look through the 
   changes.

 - do the actual changes to the code as a separate thing.

This should be true in just about *any* development model, and it's 
especially true in Linux, where patches are the main way people 
communicate.

And when using git, the whole "keep code movement separate from changes" 
has an even more fundamental reason: git can track code movement (again, 
whether moving a whole file or just a function between files), and doing a 
"git blame -C" will actually follow code movement between files. It does 
that by similarity analysis, but it does mean that if you both move the 
code *and* change it at the same time, git cannot see that "oh, that 
function came originally from that other file", and now you get worse 
annotations about where code actually originated.

So next time, please don't move code and change it at the same time.

		Linus
