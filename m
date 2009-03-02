Return-Path: <linux-kernel-owner+w=401wt.eu-S1752971AbZCBNoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971AbZCBNoS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 08:44:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751572AbZCBNoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 08:44:06 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:38582 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107AbZCBNoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 08:44:04 -0500
Date: Mon, 2 Mar 2009 07:37:54 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       containers <containers@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Oren Laadan <orenl@cs.columbia.edu>,
       Alexey Dobriyan <adobriyan@gmail.com>, hch@infradead.org
Subject: Re: [RFC][PATCH 8/8] check files for checkpointability
Message-ID: <20090302133754.GA8033@us.ibm.com>
References: <20090227203425.F3B51176@kernel> <20090227203435.98735E54@kernel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090227203435.98735E54@kernel>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Dave Hansen (dave@linux.vnet.ibm.com):
> 
> Introduce a files_struct counter to indicate whether a particular
> file_struct has ever contained a file which can not be
> checkpointed.  This flag is a one-way trip; once it is set, it may
> not be unset.
> 
> We assume at allocation that a new files_struct is clean and may
> be checkpointed.  However, as soon as it has had its files filled
> from its parent's, we check it for real in __scan_files_for_cr().
> At that point, we mark it if it contained any uncheckpointable
> files.
> 
> We also check each 'struct file' when it is installed in a fd
> slot.  This way, if anyone open()s or managed to dup() an
> unsuppored file, we can catch it.
> 
> Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>

So on a practical note, Ingo's scheme appears to be paying off.  In
order for any program's files_struct to be checkpointable right now,
it must be statically compiled, else ld.so (I assume) looks up
/proc/$$/status.  So since proc is not checkpointable, the result
is irreversibly non-checkpointable.

So...  does it make sense to mark proc as checkpointable?  Do we
reasonably assume that the same procfile will be available at
restart?

-serge
