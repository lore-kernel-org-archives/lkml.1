Return-Path: <linux-kernel-owner+w=401wt.eu-S1753906AbZGWOyz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906AbZGWOyz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 10:54:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753169AbZGWOyy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 10:54:54 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:36130 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461AbZGWOyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 10:54:53 -0400
Date: Thu, 23 Jul 2009 09:54:38 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Oren Laadan <orenl@librato.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@osdl.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-api@vger.kernel.org,
       Dave Hansen <dave@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Pavel Emelyanov <xemul@openvz.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Oren Laadan <orenl@cs.columbia.edu>
Subject: Re: [RFC v17][PATCH 22/60] c/r: external checkpoint of a task
	other than ourself
Message-ID: <20090723145438.GA12945@us.ibm.com>
References: <1248256822-23416-1-git-send-email-orenl@librato.com> <1248256822-23416-23-git-send-email-orenl@librato.com> <20090722175223.GA19389@us.ibm.com> <4A67E7D7.9060800@librato.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A67E7D7.9060800@librato.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Oren Laadan (orenl@librato.com):
> 
> 
> Serge E. Hallyn wrote:
> > Quoting Oren Laadan (orenl@librato.com):
> >> Now we can do "external" checkpoint, i.e. act on another task.
> > 
> > ...
> > 
> >>  long do_checkpoint(struct ckpt_ctx *ctx, pid_t pid)
> >>  {
> >>  	long ret;
> >>
> >> +	ret = init_checkpoint_ctx(ctx, pid);
> >> +	if (ret < 0)
> >> +		return ret;
> >> +
> >> +	if (ctx->root_freezer) {
> >> +		ret = cgroup_freezer_begin_checkpoint(ctx->root_freezer);
> >> +		if (ret < 0)
> >> +			return ret;
> >> +	}
> > 
> > Self-checkpoint of a task in root freezer is now denied, though.
> > 
> > Was that intentional?
> 
> Yes.
> 
> "root freezer" is an arbitrary task in the checkpoint subtree or
> container. It is used to verify that all checkpointed tasks - except
> for current, if doing self-checkpoint - belong to the same freezer
> group.
> 
> Since current is busy calling checkpoint(2), and since we only permit
> checkpoint of (cgroup-) frozen tasks, then - by definition - it cannot
> possibly belong to the same group. If it did, it would itself be frozen
> like its fellows and unable to call checkpoint(2).
> 
> Oren.

Ok, well I don't know what was happening yesterday.  Today it's
restart that is failing, and as you pointed out on irc that's
on s390 only.  I'll send out a patch this afternoon to fix that.

Yesterday I must not have read the output right I guess...

thanks,
-serge
