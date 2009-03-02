Return-Path: <linux-kernel-owner+w=401wt.eu-S1756226AbZCBVfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226AbZCBVfg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 16:35:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753147AbZCBVf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 16:35:26 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33525 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752075AbZCBVfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 16:35:25 -0500
Date: Mon, 2 Mar 2009 13:33:40 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Oleg Nesterov <oleg@redhat.com>
cc: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Chris Evans <scarybeasts@gmail.com>,
       David Howells <dhowells@redhat.com>, Don Howard <dhoward@redhat.com>,
       Eugene Teo <eugene@redhat.com>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Tavis Ormandy <taviso@sdf.lonestar.org>,
       Vitaly Mayatskikh <vmayatsk@redhat.com>, stable@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] copy_process: fix CLONE_PARENT && parent_exec_id
 interaction
In-Reply-To: <20090302212256.GA19262@redhat.com>
Message-ID: <alpine.LFD.2.00.0903021332130.3111@localhost.localdomain>
References: <20090225190211.GA7445@redhat.com> <20090225193927.1ED25FC3DA@magilla.sf.frob.com> <alpine.LFD.2.00.0902251156160.3111@localhost.localdomain> <20090225212039.GA11883@redhat.com> <20090226215945.GA12520@redhat.com> <alpine.LFD.2.00.0902261410581.3111@localhost.localdomain>
 <20090226223031.GA14477@redhat.com> <20090302212256.GA19262@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 2 Mar 2009, Oleg Nesterov wrote:
> 
> I am re-sending this patch simplified to one-liner. If this patch is
> accepted, I think it makes sense to move the first
> "p->parent_exec_id = p->self_exec_id" in copy_process() down, under
> the "else" branch. Just for readability.
> 
> Note! This patch doesn't even try to address the original CVE. Let me
> repeat, I am not the security expert, please correct me. But, unless
> parent or child change security context (via exec), it is OK to send
> any ->exit_signal when the child exits.
> 
> Comments?

I think this looks correct and sane. And I agree with your "also move down 
the "p->parent_exec_id = p->self_exec_id" thing. In fact, I'd agree with 
it so much that I think it should be part of this patch, just because that 
not only clarifies the code, but it also makes it more obvious what the 
real change of this one single _patch_ is.

No?

		Linus
