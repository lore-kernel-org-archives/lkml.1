Return-Path: <linux-kernel-owner+w=401wt.eu-S1756159AbXGPSsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159AbXGPSsj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 14:48:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752135AbXGPSsb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 14:48:31 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48861 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752174AbXGPSsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 14:48:30 -0400
Date: Mon, 16 Jul 2007 11:47:26 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Satyam Sharma <ssatyam@cse.iitk.ac.in>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Al Viro <viro@ftp.linux.org.uk>, Ulrich Drepper <drepper@redhat.com>
Subject: Re: [PATCH] utime(s): Honour CAP_FOWNER when times==NULL
In-Reply-To: <20070716185423.1607.78787.sendpatchset@cselinux1.cse.iitk.ac.in>
Message-ID: <alpine.LFD.0.999.0707161142210.20061@woody.linux-foundation.org>
References: <20070716185423.1607.78787.sendpatchset@cselinux1.cse.iitk.ac.i
 n>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 17 Jul 2007, Satyam Sharma wrote:
>
> [PATCH] utime(s): Honour CAP_FOWNER when times==NULL
> 
> do_utimes() does not honour CAP_FOWNER when times==NULL.
> Trivial and obvious one-line fix.

Ahh, ok. Is this old, or was it introduced recently (I'm looking at my 
recent change to that area, it doesn't seem to introduce this)?

IOW, how did you even notice this?

Also, while your one-liner looks correct, it does make me wonder: the 
whole

	if ((current->fsuid != inode->i_uid) && !capable(CAP_FOWNER))

test is a rather common test, and in fact, arguably, every time you see 
one part of it, you should probably see the other. Would it make sense to 
make a helper inline function to do this, and replace all users? Doing a

	git grep 'fsuid.*\<i_uid\>'

seems to show quite a few cases of this pattern..

		Linus
