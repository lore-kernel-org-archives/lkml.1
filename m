Return-Path: <linux-kernel-owner+w=401wt.eu-S1757445AbXIYQke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757445AbXIYQke (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 12:40:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751387AbXIYQk2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 12:40:28 -0400
Received: from vena.lwn.net ([206.168.112.25]:40478 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750980AbXIYQk1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 12:40:27 -0400
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Michael Kerrisk <mtk-manpages@gmx.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2/4] new timerfd API v2 - new timerfd API 
From: corbet@lwn.net (Jonathan Corbet)
In-reply-to: Your message of "Mon, 24 Sep 2007 13:22:37 PDT."
             <send-serie.davidel@xmailserver.org.3854.1190665358.2> 
Date: Tue, 25 Sep 2007 10:40:26 -0600
Message-ID: <12492.1190738426@lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

One quick question:

> Like the previous timerfd API implementation, read(2) and poll(2) are supported
> (with the same interface).

Looking at that interface, it appears that a process doing a read() on a
timerfd with no timer set will block for a very long time.  It's an
obvious "don't do that" situation, but perhaps we could help an
occasional developer get a clue by returning something like -EINVAL when
the timer has not been set?

jon

