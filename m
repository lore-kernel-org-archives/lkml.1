Return-Path: <linux-kernel-owner+w=401wt.eu-S1758651AbZGHSRf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758651AbZGHSRf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 14:17:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756620AbZGHSR3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 14:17:29 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41623 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755351AbZGHSR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 14:17:29 -0400
Date: Wed, 8 Jul 2009 14:17:18 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alexander Beregalov <a.beregalov@gmail.com>, linux-kernel@vger.kernel.org,
       mathieu.desnoyers@polymtl.ca
Subject: Re: [PATCH] cpufreq: fix UP build
Message-ID: <20090708181718.GC13944@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Alexander Beregalov <a.beregalov@gmail.com>,
	linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca
References: <1247075867-11355-1-git-send-email-a.beregalov@gmail.com> <alpine.LFD.2.01.0907081103560.3352@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0907081103560.3352@localhost.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 08, 2009 at 11:08:12AM -0700, Linus Torvalds wrote:

 > (not new to your diff - it's pre-existing crap):
 > 
 > 	>  #ifdef CONFIG_SMP
 > 	>       struct cpufreq_policy *managed_policy;
 > 	> +     struct sys_device *cpu_sys_dev;
 > 	>  #endif
 > 
 > and instead those variables should be declared inside the blocks where 
 > they are used, not at the top.
 > 
 > The rule should always be: make the scope of a variable as small as 
 > possible. Don't declare it at the top and try to "save" a declaration when 
 > it can be used inside multiple blocks as multiple different variables.
 > 
 > Also, that whole function could damn well be split into smaller pieces, 
 > which would make it much more readable than that horrible 250+ line piece 
 > of crap monster-function with #ifdef's inside the code.

Yes, cpufreq_add_dev is a monster. Its complexity keeps biting us in new ways.

 > Please, somebody?
 
It's something to look at for .32, agreed.

	Dave

