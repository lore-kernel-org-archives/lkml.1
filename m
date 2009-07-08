Return-Path: <linux-kernel-owner+w=401wt.eu-S1756689AbZGHSJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756689AbZGHSJS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 14:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754302AbZGHSJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 14:09:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44112 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754149AbZGHSJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 14:09:08 -0400
Date: Wed, 8 Jul 2009 11:08:12 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alexander Beregalov <a.beregalov@gmail.com>
cc: linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca,
       davej@redhat.com
Subject: Re: [PATCH] cpufreq: fix UP build
In-Reply-To: <1247075867-11355-1-git-send-email-a.beregalov@gmail.com>
Message-ID: <alpine.LFD.2.01.0907081103560.3352@localhost.localdomain>
References: <1247075867-11355-1-git-send-email-a.beregalov@gmail.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 8 Jul 2009, Alexander Beregalov wrote:
>
> From: Alexander Beregalov <a.beregalov@gmail.com> 
> 
> Fix this build error when CONFIG_SMP is not set:
> drivers/cpufreq/cpufreq.c:941: 'managed_policy' undeclared

Grr. DaveJ?

That said, I'd much prefer the fix that does _not_ have this crap in it 
(not new to your diff - it's pre-existing crap):

	>  #ifdef CONFIG_SMP
	>       struct cpufreq_policy *managed_policy;
	> +     struct sys_device *cpu_sys_dev;
	>  #endif

and instead those variables should be declared inside the blocks where 
they are used, not at the top.

The rule should always be: make the scope of a variable as small as 
possible. Don't declare it at the top and try to "save" a declaration when 
it can be used inside multiple blocks as multiple different variables.

Also, that whole function could damn well be split into smaller pieces, 
which would make it much more readable than that horrible 250+ line piece 
of crap monster-function with #ifdef's inside the code.

Please, somebody?

		Linus
