Return-Path: <linux-kernel-owner+w=401wt.eu-S1753975AbZIFDSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975AbZIFDSm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Sep 2009 23:18:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753933AbZIFDSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Sep 2009 23:18:40 -0400
Received: from mail-yx0-f141.google.com ([209.85.210.141]:41389 "EHLO
	mail-yx0-f141.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753937AbZIFDSj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Sep 2009 23:18:39 -0400
X-Greylist: delayed 2072 seconds by postgrey-1.27 at vger.kernel.org; Sat, 05 Sep 2009 23:18:39 EDT
MIME-Version: 1.0
Date: Sat, 5 Sep 2009 19:32:31 -0700 (PDT)
In-Reply-To: <dhcf5-263-13@gated-at.bofh.it>
X-IP: 24.83.206.183
References: <dgRNo-3uc-5@gated-at.bofh.it> <dhb9j-1hp-5@gated-at.bofh.it> 
	<dhcf5-263-13@gated-at.bofh.it>
User-Agent: G2/1.0
X-HTTP-UserAgent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; 
	rv:1.9.1.2) Gecko/20090729 Firefox/3.5.2,gzip(gfe),gzip(gfe)
Message-ID: <36bbf267-be27-4c9e-b782-91ed32a1dfe9@g1g2000pra.googlegroups.com>
Subject: Re: question on sched-rt group allocation cap: sched_rt_runtime_us
From: Ani <asinha@zeugmasystems.com>
To: Lucas De Marchi <lucas.de.marchi@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sep 5, 3:50 pm, Lucas De Marchi <lucas.de.mar...@gmail.com> wrote:
>
> Indeed. I've tested this same test program in a single core machine and it
> produces the expected behavior:
>
> rt_runtime_us / rt_period_us     % loops executed in SCHED_OTHER
> 95%                              4.48%
> 60%                              54.84%
> 50%                              86.03%
> 40%                              OTHER completed first
>

Hmm. This does seem to indicate that there is some kind of
relationship with SMP. So I wonder whether there is a way to turn this
'RT bandwidth accumulation' heuristic off. I did an
echo 0 > /proc/sys/kernel/sched_migration_cost
but results were identical to previous.

I figure that if I set it to zero, the regular sched-fair (non-RT)
tasks will be treated as not being cache hot and hence susceptible to
migration. From the code it looks like sched-rt tasks are always
treated as cache cold? Mind you though that I have not yet looked into
the code very rigorously. I knew the O(1) scheduler relatively well,
but I am just begun digging into the new CFS scheduler code.

On a side note, why is there no documentation explain the
sched_migration_cost tuning knob? It would be nice to have one - at
least where the sysctl variable is defined.

--Ani
