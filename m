Return-Path: <linux-kernel-owner+w=401wt.eu-S933075AbXGPQpf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933075AbXGPQpf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 12:45:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760358AbXGPQpZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 12:45:25 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:6980 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754981AbXGPQpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 12:45:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=MgYZzhP77gel9Z00mLvhkaKnS/43WH5CK7A/lw8ynVWiNkyI7ITAW8wfLZnS80MCJo8YEebZCY5Q4OWMclDpuw3rNnLLMUHaU7/AjOR91iwAIhFgrzmeVjngI1THNU3tB6nqq6oCxsMgkwOZUihvfjqpA4REoYEjz5x3wSYERI4=
Message-ID: <f158dc670707160945g72d92735x1f3d53c343d8d538@mail.gmail.com>
Date: Mon, 16 Jul 2007 10:45:21 -0600
From: "Latchesar Ionkov" <lucho@ionkov.net>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [V9fs-developer] [GIT PULL] 9p Patches for 2.6.23 merge window
Cc: "Eric Van Hensbergen" <ericvh@gmail.com>,
       "V9FS Developers" <v9fs-developer@lists.sourceforge.net>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.0.999.0707160919270.20061@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a4e6962a0707141320p376e51fcp4b1ceb681960e303@mail.gmail.com>
	 <alpine.LFD.0.999.0707151645561.20061@woody.linux-foundation.org>
	 <f158dc670707151730w5fedb53fq11367d1e6fb14d87@mail.gmail.com>
	 <alpine.LFD.0.999.0707160919270.20061@woody.linux-foundation.org>
X-Google-Sender-Auth: 9fd17aae25d9891c
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The original patchset had three patches:

1. Renames all functions and macros
2. Moves the header files from fs/9p to include/net/9p and updates the
C files with the new header locations
3. Moves the C files from fs/9p to net/9p

Unfortunately the three patches were applied as a single one in Eric's
repository and made tracking of the changes harder. We will be more
careful next time.

Thanks for you comments,
    Lucho

On 7/16/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
>
> On Sun, 15 Jul 2007, Latchesar Ionkov wrote:
> >
> > I thought that it is not a good idea to keep the v9fs_ prefix for code
> > that is in different places (fs/9p and net/9p). If keeping the old
> > prefix is more acceptable, I can create a new patch without the
> > "v9fs_"->"p9_" renames.
>
> It's fine, I don't care *that* much, and I already pulled. If it had been
> something more central, I'd have rejected it, but soemthing as specialized
> as the Plan9 fs, I just wanted to point out that this is now how we should
> do things.
>
> In other words: when doing renames it is generally *much* nicer to do a
> 100% rename (perhaps with just _trivial_ changes to make it compile - the
> include statements etc change, and maybe you want to change the name in
> the comment header too).
>
> Doing "move the code and change it at the same time" is considered bad
> form. Movement diffs are much harder to read anyway (a traditional diff
> will show it as a new-file + delete, of course), so the general rule is:
>
>  - move code around _without_ modifying it, so that code movement (whether
>    it's a whole file, or just a set of functions between files) doesn't
>    really introduce any real changes, and is easier to look through the
>    changes.
>
>  - do the actual changes to the code as a separate thing.
>
> This should be true in just about *any* development model, and it's
> especially true in Linux, where patches are the main way people
> communicate.
>
> And when using git, the whole "keep code movement separate from changes"
> has an even more fundamental reason: git can track code movement (again,
> whether moving a whole file or just a function between files), and doing a
> "git blame -C" will actually follow code movement between files. It does
> that by similarity analysis, but it does mean that if you both move the
> code *and* change it at the same time, git cannot see that "oh, that
> function came originally from that other file", and now you get worse
> annotations about where code actually originated.
>
> So next time, please don't move code and change it at the same time.
>
>                 Linus
>
