Return-Path: <linux-kernel-owner+w=401wt.eu-S1753816AbZCIShb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816AbZCIShb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 14:37:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751452AbZCIShW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 14:37:22 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33244 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751315AbZCIShV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 14:37:21 -0400
Date: Mon, 9 Mar 2009 19:33:56 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: David Howells <dhowells@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Chris Evans <scarybeasts@gmail.com>, Don Howard <dhoward@redhat.com>,
       Eugene Teo <eugene@redhat.com>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Tavis Ormandy <taviso@sdf.lonestar.org>,
       Vitaly Mayatskikh <vmayatsk@redhat.com>, stable@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] copy_process: fix CLONE_PARENT && parent_exec_id
	interaction
Message-ID: <20090309183356.GA32432@redhat.com>
References: <20090225190211.GA7445@redhat.com> <20090225193927.1ED25FC3DA@magilla.sf.frob.com> <alpine.LFD.2.00.0902251156160.3111@localhost.localdomain> <20090225212039.GA11883@redhat.com> <20090226215945.GA12520@redhat.com> <alpine.LFD.2.00.0902261410581.3111@localhost.localdomain> <20090226223031.GA14477@redhat.com> <20090302212256.GA19262@redhat.com> <alpine.LFD.2.00.0903021332130.3111@localhost.localdomain> <2712.1236617156@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2712.1236617156@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09, David Howells wrote:
>
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > -	/* Our parent execution domain becomes current domain
> > -	   These must match for thread signalling to apply */
>
> Should you retain this comment somewhere?

This comment should be changed, but I failed to make the new one.
Actually, this was one of the reasons why the first patch I sent
http://marc.info/?l=linux-kernel&m=123602926516698
didn't touch the first ""p->parent_exec_id = ...".

There is a fat comment in exit_notify(), perhaps we can just add
/* see the comment in exit_notify() */.

But the "good" commenent should also explain that, since we re-use
->real_parent, the child also "inherits" the rights _and_ restrictions
to send ->exit_signal != SIGCHLD.

Oleg.

