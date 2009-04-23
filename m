Return-Path: <linux-kernel-owner+w=401wt.eu-S1756256AbZDWIVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256AbZDWIVW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 04:21:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752339AbZDWIU7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 04:20:59 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47820 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752254AbZDWIU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 04:20:58 -0400
Subject: Re: [RFC] __ffs64()
From: Steven Whitehouse <swhiteho@redhat.com>
To: Christoph Lameter <cl@linux.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.1.10.0904221654370.32682@qirst.com>
References: <1240415192.29604.90.camel@localhost.localdomain>
	 <alpine.DEB.1.10.0904221654370.32682@qirst.com>
Content-Type: text/plain
Organization: Red Hat UK Ltd
Date: Thu, 23 Apr 2009 09:22:03 +0100
Message-Id: <1240474923.3396.7.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 2009-04-22 at 16:59 -0400, Christoph Lameter wrote:
> On Wed, 22 Apr 2009, Steven Whitehouse wrote:
> 
> > I'd like to add a new bitop, __ffs64() which I need in order to fix a
> > bug in GFS2. The question is, where should it go?
> 
> I think the location is right.
> 
> > On 64 bit arches, __ffs64() would be a synonym for __ffs(), but on 32
> > bit arches it degenerates to a conditional plus a call to __ffs(). I'm
> > assuming that there would not be a lot of point in optimising this
> > operation on 32 bit arches even if such an instruction was available, so
> > that I should do something like the below patch.
> >
> > Does that seem reasonable, or should I give it a separate header file
> > under asm-generic/bitops/ like some of the similar operations? It looks
> > like I'd have to touch a lot of other files if I were to go that route,
> 
> One issue may be that some 32 bit architectures have a better way of doing
> 64 bit ffs.
> 
Yes, thats what I was worried about. I don't have a wide enough
knowledge of the different architectures to make a judgement about
whether this is likely or not.

I guess maybe the right thing to do is to leave it as I did it in the
patch and if an arch wants to create its own implementation, then it
could be moved at that stage.

Steve.


