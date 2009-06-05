Return-Path: <linux-kernel-owner+w=401wt.eu-S1754784AbZFEPu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784AbZFEPu1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 11:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752157AbZFEPuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 11:50:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60951 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752016AbZFEPuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 11:50:15 -0400
Date: Fri, 5 Jun 2009 08:49:56 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alexey Dobriyan <adobriyan@gmail.com>
cc: Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Matt Helsley <matthltc@us.ibm.com>, xemul@parallels.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       dave@linux.vnet.ibm.com, mingo@elte.hu, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/9] exec_path 1/9: introduce ->exec_path and switch
 /proc/*/exe
In-Reply-To: <20090605154147.GA16766@x200.localdomain>
Message-ID: <alpine.LFD.2.01.0906050848520.6847@localhost.localdomain>
References: <20090526113618.GJ28083@us.ibm.com> <20090526162415.fb9cefef.akpm@linux-foundation.org> <20090531215427.GA29534@x200.localdomain> <20090531151953.8f8b14b5.akpm@linux-foundation.org> <20090603230422.GB853@x200.localdomain> <20090605104517.GA11713@infradead.org>
 <alpine.LFD.2.01.0906050808551.6847@localhost.localdomain> <20090605154147.GA16766@x200.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 5 Jun 2009, Alexey Dobriyan wrote:
> 
> This mapping issue is what created VM_EXECUTABLE/MAP_EXECUTABLE in
> the first place, I assume? Never mind it's cheap hack.
> 
> > and goes along with task->mm, and should be there, not in task_struct.
> 
> Because ->mm can be borrowed to unrelated task and user has to check
> for it.

Not it can't.

You're confusing ->mm with ->active_mm.

The latter can be borrowed. The former can not.

The fact is, the executable is _inherently_ tied to the mm. It's what it 
is mapped into. It makes no sense to tie it to anything else. It's simply 
fundamentally not a "per-thread" thing.

		Linus
