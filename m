Return-Path: <linux-kernel-owner+w=401wt.eu-S1754315AbZFEQsn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315AbZFEQsn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 12:48:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752733AbZFEQse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 12:48:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57472 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752676AbZFEQse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 12:48:34 -0400
Date: Fri, 5 Jun 2009 09:48:02 -0700 (PDT)
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
In-Reply-To: <20090605160943.GA5262@x200.localdomain>
Message-ID: <alpine.LFD.2.01.0906050942450.6847@localhost.localdomain>
References: <20090526113618.GJ28083@us.ibm.com> <20090526162415.fb9cefef.akpm@linux-foundation.org> <20090531215427.GA29534@x200.localdomain> <20090531151953.8f8b14b5.akpm@linux-foundation.org> <20090603230422.GB853@x200.localdomain> <20090605104517.GA11713@infradead.org>
 <alpine.LFD.2.01.0906050808551.6847@localhost.localdomain> <20090605154147.GA16766@x200.localdomain> <alpine.LFD.2.01.0906050848520.6847@localhost.localdomain> <20090605160943.GA5262@x200.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 5 Jun 2009, Alexey Dobriyan wrote:
> 
> It's borrowed by kernel thread of course, not userspace task.

.. and even if it is, what's the problem? 

That kernel thread has borroed whe VM for a while. It effectively _is_ a 
thread of the process now. So it's technically not even wrong to 
explicitly allow things like /proc/*/exe to see it as such.

But you can hide it by just checking some flag in the thread structure if 
you really want to.

But when creating a regular thread, you should _not_ need to take a 
spinlock and duplicate the executable path!

		Linus
