Return-Path: <linux-kernel-owner+w=401wt.eu-S1765434AbYBMP3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765434AbYBMP3d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 10:29:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756292AbYBMP3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 10:29:25 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34210 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753622AbYBMP3Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 10:29:24 -0500
Date: Wed, 13 Feb 2008 16:29:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: pageexec@freemail.hu
Cc: Sam Ravnborg <sam@ravnborg.org>, Arjan van de Ven <arjan@infradead.org>,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: vmsplice exploits, stack protector and Makefiles
Message-ID: <20080213152900.GA28959@elte.hu>
References: <20080212090001.3fcc4ca0@laptopd505.fenrus.org> <47B30F05.29637.9A21F9B@pageexec.freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B30F05.29637.9A21F9B@pageexec.freemail.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* pageexec@freemail.hu <pageexec@freemail.hu> wrote:

> patches to get CONFIG_CC_STACKPROTECTOR_ALL actually to work (it 
> includes the Makefile patch proposed in this thread already).
> 
> note that the fix to ACPI is an actual stack corruption bug (caught by 
> ssp thanks to a lucky stack layout), due to the misuse of the pci 
> accessor functions, probably a whole-tree audit is in order for 
> similar bugs.
> 
> note also that the vsyscall functions (more precisely, all the code 
> that goes into .vsyscall* sections) had better be separated into their 
> own .c files so that they can be compiled without -mcmodel=kernel and 
> use %fs for getting the ssp cookie, if ssp is desired at all there).

thanks, i've picked up your patch into x86.git#mm and also made 
stackprotector-all default-enabled so that we get more test coverage of 
this critical security feature. x86.git#mm can be picked up via:

  http://people.redhat.com/mingo/x86.git/README

head of the tree:

  ---------------->
  commit e1d96d3e489d02b12984fb3c755b0f9a9ae0fe5f
  Author: Ingo Molnar <mingo@elte.hu>
  Date:   Wed Feb 13 16:15:34 2008 +0100

      x86: enable stack-protector by default

      also enable the rodata and nx tests.
  <----------------

your patch booted fine here with stackprotector-all enabled.

	Ingo
