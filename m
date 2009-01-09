Return-Path: <linux-kernel-owner+w=401wt.eu-S1757327AbZAIVQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757327AbZAIVQd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 16:16:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755644AbZAIVQW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 16:16:22 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37865 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754937AbZAIVQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 16:16:21 -0500
Date: Fri, 9 Jan 2009 13:16:12 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Len Brown <lenb@kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org,
       Linux Power Management List <linux-pm@lists.osdl.org>
Subject: Re: git mv (was Re: [git pull] ACPI & Suspend patches for
 2.6.29-rc0)
In-Reply-To: <alpine.LFD.2.00.0901091537530.16697@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0901091305160.6528@localhost.localdomain>
References: <alpine.LFD.2.00.0901090550590.4091@localhost.localdomain> <alpine.LFD.2.00.0901091200150.6528@localhost.localdomain> <alpine.LFD.2.00.0901091537530.16697@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 9 Jan 2009, Len Brown wrote:
> 
> I guess using 'git mv' gave me the false expectation
> that git actually tracks moves like other SCMs
> and it would show up that way in the diff -- though
> now that I think about it, I like the comparison
> of the two endpoints that git did even better.

The main reason "git mv" exists at all is just people migrating from other 
places expecting it. It's largely just purely synthetic sugar - it has 
almost no meaning to git long-term.

[ Technically, it _is_ meaningful, in that it obviously not just moves the 
  file in the checked-out copy, but it also moves the index information 
  around. So "git mv" clearly does something, but it's not important in 
  the big picture.

  So using "git mv" is really nothing fundamental - it doesn't really 
  matter to the end result, and if you had done the 'mv' by just applying 
  a patch to delete the old file and create a new one, the actual commit 
  would have been 100% identical. Think of it as a convenience function, 
  and you won't be wrong. ]

> gitk doesn't use --follow by default, and when it is added, the history 
> looks pretty strange.

Heh. That's because "--follow" is a total hack, and doesn't do the nice 
(and pretty complicated) parent rewriting that the real "git log" family 
of operations normally do.

So yeah, "--follow" is broken. It's really a quick hack there for people 
who come from some other SCM to feel more comfy with git. If you come from 
SVN or CVS, you never had proper history, and you never had "gitk" anyway, 
and so "gitk --follow" doesn't really work. But it makes the pure 
_textual_ logs look a bit like CVS/SVN.

I'd love to make --follow work better and integrate more, but I've been so 
successful at never using it myself that I don't much care. And it really 
is not a very natural thing for git to do, so the hackiness is somewhat 
inherent.

			Linus
