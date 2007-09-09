Return-Path: <linux-kernel-owner+w=401wt.eu-S1758749AbXIIRsZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758749AbXIIRsZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 13:48:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757627AbXIIRsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 13:48:15 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:33494 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757294AbXIIRsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 13:48:14 -0400
Date: Sun, 9 Sep 2007 11:48:11 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 16/22] advansys: Eliminate prototypes
Message-ID: <20070909174811.GH6809@parisc-linux.org>
References: <20070909145358.GG6809@parisc-linux.org> <11893498072821-git-send-email-matthew@wil.cx> <46E4115E.7050203@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46E4115E.7050203@garzik.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 09, 2007 at 11:29:34AM -0400, Jeff Garzik wrote:
> What thoughts, if any, have been given to post-patch code arrangement, 
> besides eliminating prototypes?
> This always struck me as a counterproductive exercise when taken by 
> itself.

Eliminating prototypes saves me from an extra go round of the edit-compile
testcycle when I change the signature of a function.  It probably doesn't
matter to you, but it adds a small amount of annoyance to my day.

> Sure, prototypes were eliminated, but was code packed together 
> in an efficient way afterwards?  Ideally hot path code should be close 
> together, ditto for various other things like error handling code.

I tried to place functions close together that seemed like they were
called together and called from each other.   It's hard to know,
of course, because GCC will make its own decisions about inlining,
for example.  At the end of the day, this is an NP problem.  I remmber
Nat writing grope and using simulated annealing to solve the problem.

> Without further explanation or details about your post-patch analysis, 
> how do we even know the new code arrangement doesn't negatively impact 
> i-cache overall?

We don't, but the new layout is more likely to be good than bad, given
how I did the rearrangement (delete prototypes, try to compile.  Move
called function to before its first caller.  Repeat).  Plus, with all
the other changes I'm making, there's a serious reduction in driver
size.  I haven't compared i-cache sizes specifically, but I'm mostly
removing code, so it should be better.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
