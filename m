Return-Path: <linux-kernel-owner+w=401wt.eu-S1755927AbYGJWxG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927AbYGJWxG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 18:53:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754151AbYGJWwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 18:52:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51877 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753927AbYGJWwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 18:52:54 -0400
Date: Thu, 10 Jul 2008 15:51:48 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Roland McGrath <roland@redhat.com>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86_64: fix delayed signals
In-Reply-To: <20080710224256.AD038154218@magilla.localdomain>
Message-ID: <alpine.LFD.1.10.0807101549590.2936@woody.linux-foundation.org>
References: <20080710215039.2A143154218@magilla.localdomain> <alpine.LFD.1.10.0807101459000.2936@woody.linux-foundation.org> <20080710224256.AD038154218@magilla.localdomain>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 10 Jul 2008, Roland McGrath wrote:
>
> > But if you really want that behaviour, then re-introducing the loop would 
> > likely be the better approach (or should be combined), since I think you 
> > effectively just re-introduced it (at a much bigger granularity).
> 
> I don't think so.  Firstly, TIF_SIGPENDING is not the only flag in
> question.  There are other reasons to re-enter do_notify_resume().
> If those are set during signal processing et al, they should take
> effect before going back to user mode.

You're ignoring the background question - we expressly _stopped_ doing 
this long ago. So the real issue was the ".. if you really .." part.

Do we really? What's the actual downside here?

		Linus
