Return-Path: <linux-kernel-owner+w=401wt.eu-S1759288AbZKFSCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759288AbZKFSCU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 13:02:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758050AbZKFSCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 13:02:19 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:54308 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300AbZKFSCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 13:02:18 -0500
Date: Fri, 6 Nov 2009 12:02:10 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de,
       Containers <containers@lists.linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, hpa@zytor.com,
       Alexey Dobriyan <adobriyan@gmail.com>, roland@redhat.com,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [v11][PATCH 8/9] Define clone_with_pids() syscall
Message-ID: <20091106180210.GA31652@us.ibm.com>
References: <20091105053053.GA11289@us.ibm.com> <20091105054124.GH16142@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091105054124.GH16142@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Sukadev Bhattiprolu (sukadev@us.ibm.com):
> +	stack_size = (unsigned long)kca.child_stack_size;
> +	child_stack = (unsigned long)kca.child_stack_base + stack_size;
> +
> +	if (!child_stack)
> +		child_stack = regs->sp;

I'm hooking up the s390 version right now.  Do you think you should
make this

	if (!kca.child_stack_base)
		child_stack = regs->sp;

?

I suppose that in general if I pass in a NULL kca.child_stack_base
I'll also pass in a 0 stacksize, but as a user I'd expect that if
I pass in NULL, the size gets ignored.  Instead, if I pass in NULL
plus a size, then the kernel will take (void *)size as the stacktop.

-serge
