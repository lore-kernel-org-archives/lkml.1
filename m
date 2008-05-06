Return-Path: <linux-kernel-owner+w=401wt.eu-S933118AbYEFX2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933118AbYEFX2e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 19:28:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755400AbYEFX2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 19:28:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35941 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754307AbYEFX2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 19:28:23 -0400
Date: Tue, 6 May 2008 16:27:27 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ulrich Drepper <drepper@redhat.com>
cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net,
       akpm@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de
Subject: Re: [PATCH] fix UML on x86-64
In-Reply-To: <200805062304.m46N4h6d007206@devserv.devel.redhat.com>
Message-ID: <alpine.LFD.1.10.0805061625090.32269@woody.linux-foundation.org>
References: <200805062304.m46N4h6d007206@devserv.devel.redhat.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 6 May 2008, Ulrich Drepper wrote:
>
> This patch breaks UML for me on x86-64 running Fedora 8 (gcc 4.1.2):

It breaks things how?

Because on x86, the cut-off is gcc4 vs pre-4. See arch/x86/Makefile:

        KBUILD_CFLAGS += $(shell if [ $(call cc-version) -lt 0400 ] ; then \
                echo $(call cc-option,-fno-unit-at-a-time); fi ;)

and it's a bit distressing that these compiler flags are set two different 
ways (in fact, I was already bothered by the fact that UML sets it totally 
independently of x86 in the first place).

So what is the UML failure behaviour with gcc-4.1.2?

			Linus
