Return-Path: <linux-kernel-owner+w=401wt.eu-S1753891AbZGAIFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891AbZGAIFf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 04:05:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753571AbZGAIFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 04:05:00 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:57835 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885AbZGAIE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 04:04:56 -0400
Date: Wed, 1 Jul 2009 01:01:06 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Oren Laadan <orenl@cs.columbia.edu>, serue@us.ibm.com,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Containers <containers@lists.linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] Disable CLONE_PARENT for init
Message-ID: <20090701080106.GA14762@us.ibm.com>
References: <20090701073140.GA14284@us.ibm.com> <20090701074654.A6C6321D57@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090701074654.A6C6321D57@magilla.sf.frob.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath [roland@redhat.com] wrote:
| > When global or container-init processes use CLONE_PARENT, they create a
| > multi-rooted process tree. 
| 
| I take this to be the real motivation for your change.
| But you don't mention it in the code comment.

Well, it was - when I started. But my understanding of the comments was that
the constraint could be extended to global init as well for the following
reason.

| 
| > +	 * Swapper process sets the handler for SIGCHLD to SIG_DFL. If init
| > +	 * creates a sibling and the sibling exits, the SIGCHLD is sent to
| > +	 * the swapper (since the swapper's handler for SIGCHLD is SIG_DFL).
| > +	 * But since the swapper does not reap its children, the zombie will
| > +	 * remain forever. So prevent init from using CLONE_PARENT.
| 
| This would be fixed by having swapper set its SIGCHLD to SIG_IGN instead,
| so such children self-reap.  That seems like the better fix for that.

Yes, that would fix the global init case.

| 
| If you want to make this change because of container-init issues, I think
| you should just say so independent of this global-init case.

So can I leave the check for SIGNAL_UNKILLABLE but simplify the comments
to refer to the multi-rooted process tree ?
