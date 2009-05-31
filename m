Return-Path: <linux-kernel-owner+w=401wt.eu-S1752505AbZEaXQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505AbZEaXQT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 19:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751223AbZEaXQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 19:16:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48885 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750866AbZEaXQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 19:16:10 -0400
Date: Sun, 31 May 2009 16:15:50 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Andrew Morton <akpm@linux-foundation.org>
cc: Alexey Dobriyan <adobriyan@gmail.com>, Matt Helsley <matthltc@us.ibm.com>,
       xemul@parallels.com, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, dave@linux.vnet.ibm.com, mingo@elte.hu
Subject: Re: [PATCH 14/38] Remove struct mm_struct::exe_file et al
In-Reply-To: <20090531151953.8f8b14b5.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.2.01.0905311613260.3435@localhost.localdomain>
References: <20090526113618.GJ28083@us.ibm.com> <20090526162415.fb9cefef.akpm@linux-foundation.org> <20090531215427.GA29534@x200.localdomain> <20090531151953.8f8b14b5.akpm@linux-foundation.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 31 May 2009, Andrew Morton wrote:
> 
> What I always find a bit weird is that an MM container is used as the
> central point for a number of sched obects.  But it's logical, given
> that the never-before-stated definition of a heavyweight process is
> "thing which share a VM".

It has nothing to do with "heavy-weight process" or anything else.

The thing is, from a scheduling standpoint, one of the primary performance 
concerns in the TLB switch.

And there's a 1:1 relationship between TLB switch and MM container, modulo 
the issue of kernel tasks (and those obviously "borrow" approproate MM 
structs to avoid the switch).

So it's not weird at all. It's very direct, and a very straightforward and 
obvious relationship.

			Linus
