Return-Path: <linux-kernel-owner+w=401wt.eu-S1759967AbZBYUJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759967AbZBYUJS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 15:09:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757685AbZBYUJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 15:09:05 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41563 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756886AbZBYUJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 15:09:04 -0500
Date: Wed, 25 Feb 2009 12:06:53 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Roland McGrath <roland@redhat.com>
cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Chris Evans <scarybeasts@gmail.com>,
       David Howells <dhowells@redhat.com>, Don Howard <dhoward@redhat.com>,
       Eugene Teo <eugene@redhat.com>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Tavis Ormandy <taviso@sdf.lonestar.org>,
       Vitaly Mayatskikh <vmayatsk@redhat.com>, stable@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] copy_process: fix CLONE_PARENT && ->exit_signal
 interaction
In-Reply-To: <20090225193927.1ED25FC3DA@magilla.sf.frob.com>
Message-ID: <alpine.LFD.2.00.0902251156160.3111@localhost.localdomain>
References: <20090225190211.GA7445@redhat.com> <20090225193927.1ED25FC3DA@magilla.sf.frob.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 25 Feb 2009, Roland McGrath wrote:
>
> As I think I said before, I don't really know what the actual use case is
> for CLONE_PARENT without CLONE_THREAD.  So it's easy to approve changing
> its behavior, but I do vaguely worry about who expected what behavior before.

I think changing it is wrong. 

I can easily see somebody using CLONE_PARENT to get the correct getppid 
semantics in the thread, and then setting the signal to zero to not make 
the parent see the thread go away. I think both yours and Oleg's patch 
break that.

And there _are_ programs that have used clone() directly - not using any 
pthreads emulation layer. Some game used it for audio threads etc.

So at the very least it should accept zero for "no signal". And quite 
frankly, it would be good to try to see if there are other alternatives.

		Linus
