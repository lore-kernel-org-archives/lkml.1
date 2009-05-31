Return-Path: <linux-kernel-owner+w=401wt.eu-S1752300AbZEaXur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752300AbZEaXur (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 19:50:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751597AbZEaXul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 19:50:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39232 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751469AbZEaXuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 19:50:40 -0400
Date: Sun, 31 May 2009 16:50:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, Matt Helsley <matthltc@us.ibm.com>,
       xemul@parallels.com, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, dave@linux.vnet.ibm.com, mingo@elte.hu
Subject: Re: [PATCH 14/38] Remove struct mm_struct::exe_file et al
Message-Id: <20090531165026.376a914c.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.01.0905311613260.3435@localhost.localdomain>
References: <20090526113618.GJ28083@us.ibm.com>
	<20090526162415.fb9cefef.akpm@linux-foundation.org>
	<20090531215427.GA29534@x200.localdomain>
	<20090531151953.8f8b14b5.akpm@linux-foundation.org>
	<alpine.LFD.2.01.0905311613260.3435@localhost.localdomain>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 31 May 2009 16:15:50 -0700 (PDT) Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Sun, 31 May 2009, Andrew Morton wrote:
> > 
> > What I always find a bit weird is that an MM container is used as the
> > central point for a number of sched obects.  But it's logical, given
> > that the never-before-stated definition of a heavyweight process is
> > "thing which share a VM".
> 
> It has nothing to do with "heavy-weight process" or anything else.
> 
> The thing is, from a scheduling standpoint, one of the primary performance 
> concerns in the TLB switch.
> 
> And there's a 1:1 relationship between TLB switch and MM container, modulo 
> the issue of kernel tasks (and those obviously "borrow" approproate MM 
> structs to avoid the switch).

That's all an obscure performance-oriented internal implementation detail.

> So it's not weird at all. It's very direct, and a very straightforward and 
> obvious relationship.

It's arbitrary!  If we were to gain more performance benefit by
aggregating processes under, say, the fs_struct then that's the way the
kernel would have been implemented.

