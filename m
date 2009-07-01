Return-Path: <linux-kernel-owner+w=401wt.eu-S1753040AbZGAHrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040AbZGAHrT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 03:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750969AbZGAHrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 03:47:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49198 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750782AbZGAHrL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 03:47:11 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Oren Laadan <orenl@cs.columbia.edu>, serue@us.ibm.com,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Containers <containers@lists.linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] Disable CLONE_PARENT for init
In-Reply-To: Sukadev Bhattiprolu's message of  Wednesday, 1 July 2009 00:31:41 -0700 <20090701073140.GA14284@us.ibm.com>
References: <20090701073140.GA14284@us.ibm.com>
X-Windows: there's got to be a better way.
Message-Id: <20090701074654.A6C6321D57@magilla.sf.frob.com>
Date: Wed,  1 Jul 2009 00:46:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> When global or container-init processes use CLONE_PARENT, they create a
> multi-rooted process tree. 

I take this to be the real motivation for your change.
But you don't mention it in the code comment.

> +	 * Swapper process sets the handler for SIGCHLD to SIG_DFL. If init
> +	 * creates a sibling and the sibling exits, the SIGCHLD is sent to
> +	 * the swapper (since the swapper's handler for SIGCHLD is SIG_DFL).
> +	 * But since the swapper does not reap its children, the zombie will
> +	 * remain forever. So prevent init from using CLONE_PARENT.

This would be fixed by having swapper set its SIGCHLD to SIG_IGN instead,
so such children self-reap.  That seems like the better fix for that.

If you want to make this change because of container-init issues, I think
you should just say so independent of this global-init case.


Thanks,
Roland
