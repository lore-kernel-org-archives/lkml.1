Return-Path: <linux-kernel-owner+w=401wt.eu-S1757349AbYFEVmz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757349AbYFEVmz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 17:42:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752617AbYFEVmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 17:42:45 -0400
Received: from 41-052.adsl.zetnet.co.uk ([194.247.41.52]:50242 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588AbYFEVmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 17:42:44 -0400
To: Jeff Dike <jdike@addtoit.com>
Cc: dhazelton@enter.net, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 1/6] UML - Deal with host time going backwards
References: <20080603123211.e129c222.akpm@linux-foundation.org>
	<200806031543.56864.dhazelton@enter.net>
	<878wxmfg99.fsf@hades.wkstn.nix>
	<20080603130709.fcf6a751.akpm@linux-foundation.org>
	<20080603210048.GA12182@c2.user-mode-linux.org>
	<4846A75E.40305@goop.org>
	<20080604193715.GA11943@c2.user-mode-linux.org>
	<4846F577.10603@goop.org>
	<20080605153008.GC7311@c2.user-mode-linux.org>
	<87k5h392bd.fsf@hades.wkstn.nix>
	<20080605194732.GB13348@c2.user-mode-linux.org>
From: Nix <nix@esperi.org.uk>
Emacs: where editing text is like playing Paganini on a glass harmonica.
Date: Thu, 05 Jun 2008 22:41:55 +0100
In-Reply-To: <20080605194732.GB13348@c2.user-mode-linux.org> (Jeff Dike's message of "Thu, 5 Jun 2008 15:47:32 -0400")
Message-ID: <87bq2f8spo.fsf@hades.wkstn.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b28 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC-dcc-servers-Metrics: hades 1049; Body=6 Fuz1=6 Fuz2=6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 Jun 2008, Jeff Dike uttered the following:

> On Thu, Jun 05, 2008 at 07:14:30PM +0100, Nix wrote:
>> It comes with glibc, and even ls uses it (for clock_gettime(), to
>> determine what format to use for date display).
>> 
>> I'd say using it is about as safe as can be.
>
> Without adding -lrt to the link line here (F7), I get

Yes, you'll definitely *need* -lrt for clock_*().

> arch/um/os-Linux/built-in.o: In function `nsecs':
> /home/jdike/linux/2.6/linux-2.6.22/arch/um/os-Linux/time.c:84: undefined reference to `clock_gettime'
> collect2: ld returned 1 exit status
>
> A little odd for a system call...

I think it's in there because it's part of the POSIX realtime
extensions, so you should have to, as it were, assent to using something
that's not as portable as just using libc. It makes more sense than
libm, anyway.

(It's completely moot for UML of course :) )

-- 
`If you are having a "ua luea luea le ua le" kind of day, I can only
 assume that you are doing no work due [to] incapacitating nausea caused 
 by numerous lazy demons.' --- Frossie
