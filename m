Return-Path: <linux-kernel-owner+w=401wt.eu-S1761817AbYFETs3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761817AbYFETs3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 15:48:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751442AbYFETsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 15:48:22 -0400
Received: from [198.99.130.12] ([198.99.130.12]:51322 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbYFETsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 15:48:21 -0400
Date: Thu, 5 Jun 2008 15:47:32 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Nix <nix@esperi.org.uk>
Cc: dhazelton@enter.net, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 1/6] UML - Deal with host time going backwards
Message-ID: <20080605194732.GB13348@c2.user-mode-linux.org>
References: <20080603123211.e129c222.akpm@linux-foundation.org> <200806031543.56864.dhazelton@enter.net> <878wxmfg99.fsf@hades.wkstn.nix> <20080603130709.fcf6a751.akpm@linux-foundation.org> <20080603210048.GA12182@c2.user-mode-linux.org> <4846A75E.40305@goop.org> <20080604193715.GA11943@c2.user-mode-linux.org> <4846F577.10603@goop.org> <20080605153008.GC7311@c2.user-mode-linux.org> <87k5h392bd.fsf@hades.wkstn.nix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k5h392bd.fsf@hades.wkstn.nix>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 05, 2008 at 07:14:30PM +0100, Nix wrote:
> It comes with glibc, and even ls uses it (for clock_gettime(), to
> determine what format to use for date display).
> 
> I'd say using it is about as safe as can be.

Without adding -lrt to the link line here (F7), I get

arch/um/os-Linux/built-in.o: In function `nsecs':
/home/jdike/linux/2.6/linux-2.6.22/arch/um/os-Linux/time.c:84: undefined reference to `clock_gettime'
collect2: ld returned 1 exit status

A little odd for a system call...

> Does this really only apply on top of 2.6.22? Which of the bewildering
> blizzard of time-fixup patches we've been exchanging do I need? :)

I have it on top of 2.6.26-rc2-mm1, plus all the other patches I've
sent to Andrew.  The patch which started this discussion is the one
you really need though, since this backs it out.

    	   		Jeff

-- 
Work email - jdike at linux dot intel dot com
