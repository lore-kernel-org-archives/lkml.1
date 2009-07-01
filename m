Return-Path: <linux-kernel-owner+w=401wt.eu-S1754249AbZGAI2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249AbZGAI2Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 04:28:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752596AbZGAI2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 04:28:15 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57973 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752291AbZGAI2N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 04:28:13 -0400
Date: Wed, 1 Jul 2009 10:24:52 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Oren Laadan <orenl@cs.columbia.edu>, serue@us.ibm.com,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Containers <containers@lists.linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] Disable CLONE_PARENT for init
Message-ID: <20090701082452.GA3297@redhat.com>
References: <20090701073140.GA14284@us.ibm.com> <20090701074654.A6C6321D57@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090701074654.A6C6321D57@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01, Roland McGrath wrote:
>
> > When global or container-init processes use CLONE_PARENT, they create a
> > multi-rooted process tree. 
>
> I take this to be the real motivation for your change.
> But you don't mention it in the code comment.
>
> > +	 * Swapper process sets the handler for SIGCHLD to SIG_DFL. If init
> > +	 * creates a sibling and the sibling exits, the SIGCHLD is sent to
> > +	 * the swapper (since the swapper's handler for SIGCHLD is SIG_DFL).
> > +	 * But since the swapper does not reap its children, the zombie will
> > +	 * remain forever. So prevent init from using CLONE_PARENT.
>
> This would be fixed by having swapper set its SIGCHLD to SIG_IGN instead,
> so such children self-reap.  That seems like the better fix for that.

This won't fix the problem. The child won't autoreap itself if ->exit_signal
!= SIGCHLD.

> If you want to make this change because of container-init issues, I think
> you should just say so independent of this global-init case.

Yes, agreed, the comment looks confusing.

Oleg

