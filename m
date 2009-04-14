Return-Path: <linux-kernel-owner+w=401wt.eu-S1757447AbZDNQsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447AbZDNQsy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 12:48:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757348AbZDNQs3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 12:48:29 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:55868 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757338AbZDNQs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 12:48:28 -0400
Subject: Re: [PATCH 10/30] cr: core stuff
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org,
       containers@lists.linux-foundation.org, xemul@parallels.com,
       mingo@elte.hu, orenl@cs.columbia.edu, hch@infradead.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20090414154139.GA8085@us.ibm.com>
References: <20090410023539.GK27788@x200.localdomain>
	 <20090413214701.GA24509@us.ibm.com>
	 <20090414152752.GC27461@x200.localdomain>
	 <20090414154139.GA8085@us.ibm.com>
Content-Type: text/plain
Date: Tue, 14 Apr 2009 09:48:24 -0700
Message-Id: <1239727704.32604.80.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-14 at 10:41 -0500, Serge E. Hallyn wrote:
> > Module can legally support C/R for its files.
> > In the end it most certainly will end up with module registering restart
> 
> Which module?  The module defining a filesystem?
> 
> In that case I'm just not clear on how the restart code will know which
> fs's file_operations to use to pick a fops->restart() fn.

There's not an f_op on the restart side -- there can't be.  The problem
is that we get a CR_FD_FOO object and need to call off into the "foo"
code to recreate the 'struct file'.  To me, that screams of a nice list
of function handlers indexed be CR_FD_FOO.

So, we have a list of these sitting around somewhere:

int restore_fd_func(struct cr_ctx *ctx, struct cr_fd_hdr *fd, void *private)

and when we see a CR_FD_HDR object, we look up its type and call the
respective handler.  The handler will get enough data to go and restore
the fd.  The fd number and other things common to all fds should be
present in the cr_fd_hdr.

-- Dave

