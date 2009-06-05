Return-Path: <linux-kernel-owner+w=401wt.eu-S1755590AbZFEPL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590AbZFEPL0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 11:11:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753130AbZFEPLR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 11:11:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37404 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751693AbZFEPLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 11:11:16 -0400
Date: Fri, 5 Jun 2009 08:10:50 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Christoph Hellwig <hch@infradead.org>
cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Matt Helsley <matthltc@us.ibm.com>, xemul@parallels.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       dave@linux.vnet.ibm.com, mingo@elte.hu, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/9] exec_path 1/9: introduce ->exec_path and switch
 /proc/*/exe
In-Reply-To: <20090605104517.GA11713@infradead.org>
Message-ID: <alpine.LFD.2.01.0906050808551.6847@localhost.localdomain>
References: <20090526113618.GJ28083@us.ibm.com> <20090526162415.fb9cefef.akpm@linux-foundation.org> <20090531215427.GA29534@x200.localdomain> <20090531151953.8f8b14b5.akpm@linux-foundation.org> <20090603230422.GB853@x200.localdomain>
 <20090605104517.GA11713@infradead.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 5 Jun 2009, Christoph Hellwig wrote:
>
> On Thu, Jun 04, 2009 at 03:04:22AM +0400, Alexey Dobriyan wrote:
> > ->exec_path is copied on clone(2) and put at do_exit() time.
> > 
> > ->exec_path is going to replace struct mm_struct::exe_file et al
> > and allows to remove VM_EXECUTABLE flag while keeping readlink("/proc/*/exe")
> > without loop over all VMAs.
> 
> Why don't you leave it in mm_struct?  That'll avoid having to mess with
> it in clone, and given that exec always replaces the whole VM it's a
> more natural fit anyway.

Oh, I didn't even notice that, because I just assumed it was in mm_struct 
already due to the earlier discussion.

So I concur with Christoph - that field should be in the mm_struct. The 
executable is a "mapping" issue, and goes along with task->mm, and should 
be there, not in task_struct.

So it should be copied at fork() time when you do the dup_mm(), not 
anywhere else.

		Linus
