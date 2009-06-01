Return-Path: <linux-kernel-owner+w=401wt.eu-S1753323AbZFAACZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323AbZFAACZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 20:02:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751783AbZFAACR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 20:02:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35705 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751684AbZFAACQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 20:02:16 -0400
Date: Sun, 31 May 2009 17:02:03 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Andrew Morton <akpm@linux-foundation.org>
cc: Alexey Dobriyan <adobriyan@gmail.com>, Matt Helsley <matthltc@us.ibm.com>,
       xemul@parallels.com, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, dave@linux.vnet.ibm.com, mingo@elte.hu
Subject: Re: [PATCH 14/38] Remove struct mm_struct::exe_file et al
In-Reply-To: <20090531165026.376a914c.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.2.01.0905311659350.3435@localhost.localdomain>
References: <20090526113618.GJ28083@us.ibm.com> <20090526162415.fb9cefef.akpm@linux-foundation.org> <20090531215427.GA29534@x200.localdomain> <20090531151953.8f8b14b5.akpm@linux-foundation.org> <alpine.LFD.2.01.0905311613260.3435@localhost.localdomain>
 <20090531165026.376a914c.akpm@linux-foundation.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 31 May 2009, Andrew Morton wrote:
> 
> It's arbitrary!  If we were to gain more performance benefit by
> aggregating processes under, say, the fs_struct then that's the way the
> kernel would have been implemented.

What?

That's like saying that "if quarks were the size of soccer-balls, we'd all 
be pink".

It makes no sense.

When  you claim that it's arbitrary, you're totally ignoring reality, and 
CPU design.

The fact is, TLB's are very fundamental to task switching. filesystems are 
not. It's that simple. IOW, it's not at all arbitrary, it's a direct 
result of how the world works. The "world" for the kernel is the reality 
of CPU's, and in that reality, TLB switching is a huge factor.

There is nothing arbitrary about it at all.

			Linus
