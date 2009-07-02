Return-Path: <linux-kernel-owner+w=401wt.eu-S1756121AbZGBJ4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121AbZGBJ4m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 05:56:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751743AbZGBJ4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 05:56:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58620 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751059AbZGBJ4c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 05:56:32 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
       Serge Hallyn <serue@us.ibm.com>, David Howells <dhowells@redhat.com>,
       James Morris <jmorris@namei.org>, linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch 3/3] elf: use a macro instead of a raw number
In-Reply-To: Amerigo Wang's message of  Thursday, 2 July 2009 17:38:41 +0800 <4A4C8021.8070509@redhat.com>
References: <20090701050840.6188.84560.sendpatchset@localhost.localdomain>
	<20090701050900.6188.41697.sendpatchset@localhost.localdomain>
	<20090701073810.A80FC21D57@magilla.sf.frob.com>
	<4A4C8021.8070509@redhat.com>
X-Windows: don't get frustrated without it.
Message-Id: <20090702095554.4913B404FD@magilla.sf.frob.com>
Date: Thu,  2 Jul 2009 02:55:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> But in the kernel code, pr_fname is copied from ->comm, they should
> be equal, shouldn't they?

The point is that we are not at liberty to change the size of pr_fname.
Its size and layout are known to userland and thus set in stone.  To
have a larger size, we would have to invent a new NT_* type code with a
new layout that would also be known to userland.  It's not worth the
bother.  

Nowadays a debugger can see AT_EXECFN in auxv (NT_AUXV in core files,
/proc/pid/auxv live), and look at that address in the user memory (core
file or process).  That's clobberable on the user-mode stack, but it can
be of unbounded size.


Thanks,
Roland
