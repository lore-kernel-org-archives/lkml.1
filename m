Return-Path: <linux-kernel-owner+w=401wt.eu-S1753424AbZGVR5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424AbZGVR5o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 13:57:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751735AbZGVR5o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 13:57:44 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:37023 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbZGVR5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 13:57:43 -0400
Date: Wed, 22 Jul 2009 12:52:23 -0500
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
Message-ID: <20090722175223.GA19389@us.ibm.com>
References: <1248256822-23416-1-git-send-email-orenl@librato.com> <1248256822-23416-23-git-send-email-orenl@librato.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248256822-23416-23-git-send-email-orenl@librato.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Oren Laadan (orenl@librato.com):
> Now we can do "external" checkpoint, i.e. act on another task.

...

>  long do_checkpoint(struct ckpt_ctx *ctx, pid_t pid)
>  {
>  	long ret;
> 
> +	ret = init_checkpoint_ctx(ctx, pid);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (ctx->root_freezer) {
> +		ret = cgroup_freezer_begin_checkpoint(ctx->root_freezer);
> +		if (ret < 0)
> +			return ret;
> +	}

Self-checkpoint of a task in root freezer is now denied, though.

Was that intentional?

-serge
