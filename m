Return-Path: <linux-kernel-owner+w=401wt.eu-S1754249AbYHSHkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249AbYHSHkh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 03:40:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752455AbYHSHk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 03:40:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47190 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752274AbYHSHk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 03:40:28 -0400
Date: Tue, 19 Aug 2008 00:40:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ico Doornekamp <lkml@zevv.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: TIOCGWINSZ retuns old pty size after receiving SIGWINCH
Message-Id: <20080819004026.2dac3ba6.akpm@linux-foundation.org>
In-Reply-To: <20080810150859.GO3653@pruts.nl>
References: <20080810150859.GO3653@pruts.nl>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Aug 2008 17:08:59 +0200 Ico Doornekamp <lkml@zevv.nl> wrote:

> 
> Hello,
> 
> Recently my X terminals showed annoying behaviour where the application
> in the terminal was not resized properly to the actual size of the X
> terminal emulator window, resulting in a lot of misaligned text on the
> screen. Hunting the issue down from the windowmanager and the terminal
> emulator program, I suspect the problem might lie in the kernel. I'm
> running 2.6.26 on a dual core i386.
> 
> What I see is this: the userspace application receives a SIGWINCH signal
> and acquires the terminal size usign the TIOCGWINSZ ioctl. It seems that
> in some cases the old instead of the new terminal size is returned.
> A small delay before the ioctl seems to 'fix' this behaviour.
> 
> I noticed some changes involving locking in the the pty code in the last
> kernel verions, could one of these changes cause the above behaviour ? If
> so, wouldn't this affect much more users ?
> 

hm, that code is pretty simple and although it does the SIGWINCH and
the window-size setting in a peculiar order, it looks to be race-free.

Approximately what proportion of the time does it go wrong?
