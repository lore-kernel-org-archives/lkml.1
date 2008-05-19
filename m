Return-Path: <linux-kernel-owner+w=401wt.eu-S1760015AbYESQkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760015AbYESQkb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 12:40:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753102AbYESQkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 12:40:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40977 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752213AbYESQkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 12:40:11 -0400
Date: Mon, 19 May 2008 09:36:56 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Boaz Harrosh <bharrosh@panasas.com>
cc: Alan Stern <stern@rowland.harvard.edu>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>,
       USB Storage list <usb-storage@lists.one-eyed-alien.net>,
       SCSI development list <linux-scsi@vger.kernel.org>
Subject: Re: [Re: Linux 2.6.26-rc2] Write protect on on
In-Reply-To: <4831A60A.5010308@panasas.com>
Message-ID: <alpine.LFD.1.10.0805190929170.32253@woody.linux-foundation.org>
References: <Pine.LNX.4.44L0.0805191106270.15266-100000@iolanthe.rowland.org> <4831A60A.5010308@panasas.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 19 May 2008, Boaz Harrosh wrote:

> Alan Stern wrote:
> > 
> > Yes, it never worked properly.  But now it fails in a bad way whereas 
> > before it failed in a benign way.
> 
> You do realize that, that was pure lock to have a zero'ed buffer.

Umm. Maybe it SHOULD NOT HAVE BEEN!

The thing is, if we can get partial results back, we really *should* 
either error out, or we should have at least cleared the buffer (either 
beforehand or when seeing the partial result). Returning a buffer with the 
old random contents is a bug.

And if clearing the buffer not only avoids any security holes and possible 
undefined behavior, but _also_ ends up fixing the write protect sense 
issue, all the better!

		Linus
