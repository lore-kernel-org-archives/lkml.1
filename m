Return-Path: <linux-kernel-owner+w=401wt.eu-S1757681AbYA2WX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757681AbYA2WX7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 17:23:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756716AbYA2WXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 17:23:20 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:33809 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756577AbYA2WXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 17:23:13 -0500
Message-Id: <200801292222.m0TMMtEi024184@owlet.beaverton.ibm.com>
To: Max Kellermann <max@duempel.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.23.1: oops in diskstats_show() 
In-reply-to: Your message of "Fri, 25 Jan 2008 14:32:50 +0100."
             <20080125133250.GA12677@swift.blarg.de> 
Date: Tue, 29 Jan 2008 14:22:55 -0800
From: Rick Lindsley <ricklind@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    my kernel 2.6.23.1 oopsed today in diskstats_show(), leaving the
    block_subsys_lock mutex locked.  I have an Athlon 64 X2 (dual-core),
    architecture x86_64.  I have not tried with 2.6.24 yet, but it looks
    like there was no relevant change in 2.6.24.

Hmm. Yes, this should not happen. Having grabbed the block_subsys_lock
mutex should have been sufficient to keep the disk list stable.  And the
evidence you sent along suggests that yes, the gendisk structure may have
gotten cleared after you got a reference to it but before you could get
the data from it.

    Right before the crash, I was torturing cryptsetup to experiment with
    encryption - I created and deleted device mapper objects in a loop.

Creating and deleting block devices ... yeah, this is probably key to
the problem. Can you provide the command or, more likely, script you
were using to do this?

Rick
