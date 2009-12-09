Return-Path: <linux-kernel-owner+w=401wt.eu-S1754512AbZLIPNQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512AbZLIPNQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 10:13:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754053AbZLIPNO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 10:13:14 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43837 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752869AbZLIPNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 10:13:13 -0500
Date: Wed, 9 Dec 2009 07:12:16 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
cc: Al Viro <viro@ZenIV.linux.org.uk>, David Miller <davem@davemloft.net>,
       Ollie Wild <aaw@google.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Rik van Riel <riel@redhat.com>, viro@ftp.linux.org.uk,
       linux-arch@vger.kernel.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCHSET] mremap/mmap mess
In-Reply-To: <Pine.LNX.4.64.0912091041250.23659@sister.anvils>
Message-ID: <alpine.LFD.2.00.0912090709130.3560@localhost.localdomain>
References: <20091208060701.GM14381@ZenIV.linux.org.uk> <Pine.LNX.4.64.0912081142280.31223@sister.anvils> <Pine.LNX.4.64.0912081254500.3365@sister.anvils> <20091208.130802.25121122.davem@davemloft.net> <20091208220638.GN14381@ZenIV.linux.org.uk>
 <Pine.LNX.4.64.0912091041250.23659@sister.anvils>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 9 Dec 2009, Hugh Dickins wrote:
> 
> David: Yes, that's one of my fears too - I don't think
> rlimits would pose any new problem, but building up the argv+env below
> sp on the execer's userstack would be in danger of colliding with the
> vma below if the space allowed to that userstack is too small.

For threads, the stack is usually pretty small, so yeah, it would severely 
limit threads doing execve. 

That's supposed to be unusual and is frowned upon, but we've spent a fair 
amount of effort on making sure it works, so I think it would be 
unacceptable.

And I really don't see what the problem with our current approach is. We 
have a nice source array - the originating VM, and a nice destination 
array - the resulting VM, and trying to exchange that nice conceptual 
setup with another setup with _different_ problems that isn't even as 
clean sounds like a major mistake to me.

		Linus
