Return-Path: <linux-kernel-owner+w=401wt.eu-S1755369AbZCBP4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369AbZCBP4x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 10:56:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752718AbZCBP4o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 10:56:44 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:35790 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069AbZCBP4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 10:56:43 -0500
Subject: Re: [RFC][PATCH 8/8] check files for checkpointability
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: containers <containers@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       hch@infradead.org, Ingo Molnar <mingo@elte.hu>,
       Alexey Dobriyan <adobriyan@gmail.com>
In-Reply-To: <20090302133754.GA8033@us.ibm.com>
References: <20090227203425.F3B51176@kernel>
	 <20090227203435.98735E54@kernel>  <20090302133754.GA8033@us.ibm.com>
Content-Type: text/plain
Date: Mon, 02 Mar 2009 07:56:31 -0800
Message-Id: <1236009391.26788.447.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-02 at 07:37 -0600, Serge E. Hallyn wrote:
> Quoting Dave Hansen (dave@linux.vnet.ibm.com):
> > 
> > Introduce a files_struct counter to indicate whether a particular
> > file_struct has ever contained a file which can not be
> > checkpointed.  This flag is a one-way trip; once it is set, it may
> > not be unset.
> > 
> > We assume at allocation that a new files_struct is clean and may
> > be checkpointed.  However, as soon as it has had its files filled
> > from its parent's, we check it for real in __scan_files_for_cr().
> > At that point, we mark it if it contained any uncheckpointable
> > files.
> > 
> > We also check each 'struct file' when it is installed in a fd
> > slot.  This way, if anyone open()s or managed to dup() an
> > unsuppored file, we can catch it.
> > 
> > Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
> 
> So on a practical note, Ingo's scheme appears to be paying off.  In
> order for any program's files_struct to be checkpointable right now,
> it must be statically compiled, else ld.so (I assume) looks up
> /proc/$$/status.  So since proc is not checkpointable, the result
> is irreversibly non-checkpointable.
> 
> So...  does it make sense to mark proc as checkpointable?  Do we
> reasonably assume that the same procfile will be available at
> restart?

Can I kick and scream for a minute?  :)

dave@nimitz:~/lse/linux/2.5/linux-2.6.git$ grep -r 'struct file_operations.*{' fs/ | grep /proc/ | wc -l
51

I'll need to go actually look at (and mark) each of those.  But, the
upside is that I'll have to go look at each of those.

-- Dave

