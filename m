Return-Path: <linux-kernel-owner+w=401wt.eu-S1757561AbYDAIiz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757561AbYDAIiz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 04:38:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756330AbYDAIio
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 04:38:44 -0400
Received: from styx.suse.cz ([82.119.242.94]:53773 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757413AbYDAIin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 04:38:43 -0400
Date: Tue, 1 Apr 2008 10:38:41 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org
Subject: Re: spinlocks -- why are releases inlined and acquires are not?
In-Reply-To: <20080401083359.GB32272@elte.hu>
Message-ID: <Pine.LNX.4.64.0804011034410.5541@jikos.suse.cz>
References: <Pine.LNX.4.64.0804010202390.5541@jikos.suse.cz>
 <Pine.LNX.4.64.0804010236110.5541@jikos.suse.cz> <20080401083359.GB32272@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Apr 2008, Ingo Molnar wrote:

> > > What is the reason for this asymetry? Shouldn't the acquiring 
> > > functions be implemented in the very same way? Or at least, 
> > > shouldn't all the __lockfunc functions be inlined?
> > i.e. is there any particular reason why we don't have something like 
> > the patch below (implemented for all the lock variants of course, this 
> > is just to demonstrate what I mean)?
> IIRC the main reason we decided to uninline them was image size. So i'd 
> suggest for you to check how this change impacts vmlinux size (on both 
> 64-bit and 32-bit), a typical distro config (or allyesconfig with lock 
> debugging disabled). If you do the test on x86.git/latest you'll also 
> have the CONFIG_OPTIMIZE_INLINING=y and CONFIG_CC_OPTIMIZE_FOR_SIZE=y 
> combination as well, which generates the most compact x86 kernel image 
> ever.

In fact we have received report from one of our users that he is seeing 
approximately 15% performance degradation of mmap() when spinlocks are not 
inlined. I am going to do some performance measurements myself shortly, as 
it seems quite strange, but while at it, I have noticed the aforementioned 
asymetry in spinlock.h, so I just wanted to know if there is any 
particular reason behind that.

-- 
Jiri Kosina
SUSE Labs
