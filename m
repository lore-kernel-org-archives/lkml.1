Return-Path: <linux-kernel-owner+w=401wt.eu-S1756755AbZDNQh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755AbZDNQh3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 12:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753059AbZDNQhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 12:37:12 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:38047 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751744AbZDNQhL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 12:37:11 -0400
Subject: "partial" container checkpoint
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Oren Laadan <orenl@cs.columbia.edu>, xemul@parallels.com,
       containers@lists.linux-foundation.org, mingo@elte.hu,
       linux-kernel@vger.kernel.org, hch@infradead.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       Alexey Dobriyan <adobriyan@gmail.com>
In-Reply-To: <20090414152951.GA7703@us.ibm.com>
References: <20090410023539.GK27788@x200.localdomain>
	 <20090413214701.GA24509@us.ibm.com> <49E424A3.60606@cs.columbia.edu>
	 <20090414152951.GA7703@us.ibm.com>
Content-Type: text/plain
Date: Tue, 14 Apr 2009 09:37:03 -0700
Message-Id: <1239727023.32604.69.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-14 at 10:29 -0500, Serge E. Hallyn wrote:
> I think the perceived need for it comes, as above, from the pure
> checkpoint-a-whole-container-only view.  So long as you will
> checkpoint/restore a whole container, then you'll end up doing
> something requiring privilege anyway.  But that is not all of
> the use cases.

Yeah, there are certainly a lot of shades of gray here.  I've been
talking to some HPC guys in the last couple of days.  They certainly
have a need for checkpoint/restart, but much less of a need for doing
entire containers.  

It also occurs to me that we have the potential to pull some
long-out-of-tree users back in.  VMADump users, for instance:

	http://bproc.sourceforge.net/c268.html

If we could do *just* a selective checkpoint of a single process's VMAs,
the bproc users could probably use sys_checkpoint() in some way.  That's
*way* less than an entire container, but it would be really useful to
some people.   

-- Dave

